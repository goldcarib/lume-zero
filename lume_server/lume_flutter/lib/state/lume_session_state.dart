import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:lume_server_client/lume_server_client.dart';
import 'package:window_manager/window_manager.dart';
import '../services/ai_manager.dart';
import '../services/ai_assistant_service.dart';

enum LumeQuality {
  eco,      // 1-2 FPS, high compression
  balanced, // 5-10 FPS, mid compression
  high      // WebRTC performance
}

class PointOfInterest {
  final String id;
  final double x;
  final double y;
  final DateTime createdAt;

  PointOfInterest({
    required this.id,
    required this.x,
    required this.y,
    required this.createdAt,
  });
}

/// State manager for Lume session using ChangeNotifier
class LumeSessionState extends ChangeNotifier {
  final Client _client;
  final AiManager _aiManager = AiManager();
  
  String? _sessionId;
  String? _passcode;
  StreamSubscription<SessionMessage>? _streamSubscription;
  bool _isDisposed = false;
  
  // Current remote pointer event
  PointerEvent? _currentPointerEvent;
  
  // Current frame data (for Client view)
  FrameEvent? _currentFrame;
  
  // History of last 5 pointer positions for tail effect
  final List<PointerEvent> _pointerHistory = [];
  static const int _maxHistoryLength = 5;
  
  // Actions
  PointerEvent? _lastActionEvent;
  
  // Throttling for outgoing events (30fps = 33ms)
  DateTime? _lastSentTime;
  static const Duration _throttleDuration = Duration(milliseconds: 33);
  
  // Connection status
  bool _isConnected = false;
  String? _error;
  
  // Quality Settings
  LumeQuality _quality = LumeQuality.balanced;
  
  // Points of Interest
  final List<PointOfInterest> _pois = [];
  static const int _maxPoiCount = 5;
  static const Duration _poiDuration = Duration(seconds: 15);
  Timer? _actionTimer;

  // AI & Telemetry
  final List<Uint8List> _historyBuffer = [];
  static const int _maxHistoryBuffer = 5;
  String? _aiContextSummary;
  bool _isGuardianAlertActive = false;
  String? _guardianAlertMessage;
  
  // Diagnostic logs
  final List<String> _diagnosticLogs = [];
  static const int _maxLogLength = 10;
  
  // WebRTC Signaling callback
  void Function(String type, String? sdp, String? candidate, String? sdpMid, int? sdpMlineIndex)? onSignalingMessage;

  LumeSessionState(this._client) {
    _aiManager.init().then((_) => notifyListeners());
  }
  
  // Getters
  String? get sessionId => _sessionId;
  String? get passcode => _passcode;
  PointerEvent? get currentPointerEvent => _currentPointerEvent;
  FrameEvent? get currentFrame => _currentFrame;
  PointerEvent? get lastActionEvent => _lastActionEvent;
  List<PointerEvent> get pointerHistory => List.unmodifiable(_pointerHistory);
  bool get isConnected => _isConnected;
  String? get error => _error;
  LumeQuality get quality => _quality;
  List<PointOfInterest> get pois => List.unmodifiable(_pois);
  List<String> get diagnosticLogs => List.unmodifiable(_diagnosticLogs);
  
  AiManager get aiManager => _aiManager;
  String? get aiContextSummary => _aiContextSummary;
  bool get isGuardianAlertActive => _isGuardianAlertActive;
  String? get guardianAlertMessage => _guardianAlertMessage;
  
  /// Get the current event being pointed at (for overlays)
  PointerEvent? get pointingAt => _lastActionEvent;

  @override
  void notifyListeners() {
    if (!_isDisposed) {
      super.notifyListeners();
    }
  }

  void setQuality(LumeQuality newQuality) {
    if (_quality == newQuality) return;
    _quality = newQuality;
    notifyListeners();
    debugPrint('Quality set to: $newQuality');
  }
  
  /// Join a session room
  Future<void> joinSession(String sessionId, {String? passcode}) async {
    try {
      _sessionId = sessionId;
      _passcode = passcode;
      _error = null;
      
      final stream = _client.pointerStream.subscribe(sessionId, passcode: passcode);
      
      _streamSubscription = stream.listen(
        _onSessionMessageReceived,
        onError: _onStreamError,
        onDone: _onStreamDone,
      );
      
      _isConnected = true;
      notifyListeners();
      
      debugPrint('Joined session: $sessionId');
    } catch (e) {
      _error = 'Failed to join session: $e';
      _isConnected = false;
      notifyListeners();
      debugPrint(_error);
    }
  }

  /// Request support from a specific group
  /// This assigns a random room and provisions AI from the group config
  Future<LumeSession> requestGroupSupport(String groupName) async {
    try {
      final lumeSession = await _client.queue.requestSupport(groupName);
      
      // Automatically retrieve the group's AI config
      final group = await _client.group.getGroup(groupName);
      if (group != null) {
        // provision AI using the group's settings
        await _aiManager.provisionGroupAi(
          provider: 'Gemini', 
          secret: group.encryptedAiConfig,
          knowledgeBase: group.knowledgeBase,
          groupId: groupName,
        );
      }
      
      // Join the assigned room
      await joinSession(lumeSession.roomId);
      return lumeSession;
    } catch (e) {
      _error = 'Failed to request support: $e';
      notifyListeners();
      rethrow;
    }
  }

  /// Helper: Get list of waiting sessions for a group
  Future<List<LumeSession>> getWaitingSessions(String groupName) async {
    return await _client.queue.getWaitingSessions(groupName);
  }

  /// Helper: Start assisting a host from the queue
  Future<void> startAssisting(String roomId) async {
    await _client.queue.startAssisting(roomId);
    await joinSession(roomId);
  }
  
  /// Leave the current session
   Future<void> leaveSession() async {
    debugPrint('Leaving session: $_sessionId');
    await _streamSubscription?.cancel();
    _streamSubscription = null;
    _sessionId = null;
    _passcode = null;
    _currentPointerEvent = null;
    _pointerHistory.clear();
    _isConnected = false;
    _error = null;
    _diagnosticLogs.clear();
    _historyBuffer.clear();
    _aiContextSummary = null;
    _isGuardianAlertActive = false;
    onSignalingMessage = null; // Clear signaling callback to avoid leaks
    notifyListeners();
  }
  
  /// Send a pointer event to the server
  Future<void> sendPointerEvent({
    required double normalizedX,
    required double normalizedY,
    required String type,
    double? scrollX,
    double? scrollY,
    String? action,
    String? message,
  }) async {
    if (_sessionId == null || !_isConnected) return;
    
    // Throttle move events
    if (type == 'move') {
      final now = DateTime.now();
      if (_lastSentTime != null && 
          now.difference(_lastSentTime!) < _throttleDuration) {
        return;
      }
      _lastSentTime = now;
    }
    
    try {
      final pointerEvent = PointerEvent(
        x: normalizedX,
        y: normalizedY,
        sessionId: _sessionId!,
        type: type,
        timestamp: DateTime.now(),
        scrollX: scrollX,
        scrollY: scrollY,
        action: action,
        message: message,
      );
      
      final wrapper = SessionMessage(
        sessionId: _sessionId!,
        timestamp: DateTime.now(),
        pointer: pointerEvent,
        passcode: _passcode,
      );
      
      await _client.pointerStream.broadcast(wrapper);
    } catch (e) {
      debugPrint('Failed to send event: $e');
    }
  }
  
  /// Send a frame event (screen share)
  Future<void> sendFrame(ByteData data, {int? width, int? height}) async {
    if (_sessionId == null || !_isConnected) return;
    
    try {
      final frameEvent = FrameEvent(
        sessionId: _sessionId!,
        data: data,
        timestamp: DateTime.now(),
        width: width,
        height: height,
      );
      
      final wrapper = SessionMessage(
        sessionId: _sessionId!,
        timestamp: DateTime.now(),
        frame: frameEvent,
        passcode: _passcode,
      );
      
      await _client.pointerStream.broadcast(wrapper);

      // Add to history buffer for Contextual Telemetry
      _historyBuffer.add(Uint8List.fromList(data.buffer.asUint8List()));
      if (_historyBuffer.length > _maxHistoryBuffer) {
        _historyBuffer.removeAt(0);
      }
    } catch (e) {
      debugPrint('Failed to send frame: $e');
    }
  }
  
  /// Send a WebRTC signaling message
  Future<void> sendSignaling({
    required String type,
    String? sdp,
    String? candidate,
    String? sdpMid,
    int? sdpMlineIndex,
  }) async {
    if (_sessionId == null || !_isConnected) return;
    
    try {
      final wrapper = SessionMessage(
        sessionId: _sessionId!,
        timestamp: DateTime.now(),
        signalingType: type,
        sdp: sdp,
        candidate: candidate,
        sdpMid: sdpMid,
        sdpMlineIndex: sdpMlineIndex,
        passcode: _passcode,
      );
      
      await _client.pointerStream.broadcast(wrapper);
    } catch (e) {
      debugPrint('Failed to send signaling: $e');
    }
  }
  
  void _onSessionMessageReceived(dynamic event) {
    if (event is! SessionMessage) return;
    
    final time = DateTime.now().toIso8601String().split('T')[1].split('.')[0];
    String msgType = 'Unknown';
    if (event.pointer != null) msgType = 'Pointer(${event.pointer!.type})';
    else if (event.frame != null) msgType = 'Frame(${event.frame!.data.lengthInBytes} bytes)';
    else if (event.signalingType != null) msgType = 'Signaling(${event.signalingType})';
    else {
      // If all are null, let's log the sessionId and timestamp to confirm it's at least the right object
      msgType = 'Empty(sid: ${event.sessionId.substring(0, 4)}..., t: ${event.timestamp.second}s)';
    }
    
    _diagnosticLogs.add('[$time] RECV: $msgType');
    if (_diagnosticLogs.length > _maxLogLength) _diagnosticLogs.removeAt(0);
    
    notifyListeners();

    if (event.pointer != null) {
      _handlePointerEvent(event.pointer!);
    }
    
    if (event.frame != null) {
      _currentFrame = event.frame;
      notifyListeners();
    }
    
    if (event.signalingType != null) {
      if (event.signalingType == 'error') {
        _error = event.sdp ?? 'Unknown security error';
        _isConnected = false;
        _streamSubscription?.cancel();
        notifyListeners();
        debugPrint('Session Security Error: $_error');
      } else {
        onSignalingMessage?.call(
          event.signalingType!,
          event.sdp,
          event.candidate,
          event.sdpMid,
          event.sdpMlineIndex,
        );
      }
    }
  }
  
  void _handlePointerEvent(PointerEvent event) {
    _currentPointerEvent = event;
    
    // Handle actions
    if (event.type == 'action') {
      _lastActionEvent = event;
      
      // Auto-clear action after 3 seconds so overlays don't stick
      _actionTimer?.cancel();
      _actionTimer = Timer(const Duration(seconds: 3), () {
        _lastActionEvent = null;
        notifyListeners();
      });

      if (event.action == 'drop_poi') {
        _handleDropPoi(event);
      }
    }
    
    // Add to history for tail effect (only moves)
    if (event.type == 'move') {
      _pointerHistory.add(event);
      if (_pointerHistory.length > _maxHistoryLength) {
        _pointerHistory.removeAt(0);
      }
    }
    
    notifyListeners();
  }
  
  void _onStreamError(dynamic error) {
    _error = 'Stream error: $error';
    _isConnected = false;
    notifyListeners();
  }
  
  void _onStreamDone() {
    _isConnected = false;
    notifyListeners();
  }
  
  @override
  void dispose() {
    _isDisposed = true;
    _actionTimer?.cancel();
    _streamSubscription?.cancel();
    super.dispose();
  }
  
  /// Consume the last action (clear it so it doesn't re-trigger)
  void consumeLastAction() {
    _lastActionEvent = null;
  }

  void _handleDropPoi(PointerEvent event) {
    if (_pois.length >= _maxPoiCount) {
      _pois.removeAt(0); // Clutter control
    }

    final poi = PointOfInterest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      x: event.x,
      y: event.y,
      createdAt: DateTime.now(),
    );

    _pois.add(poi);
    notifyListeners();

    // Auto-remove after duration
    Timer(_poiDuration, () {
      _pois.removeWhere((p) => p.id == poi.id);
      notifyListeners();
    });
  }

  /// Trigger Guardian Alert
  void triggerGuardianAlert(String message) {
    _isGuardianAlertActive = true;
    _guardianAlertMessage = message;
    notifyListeners();
    
    // We must ensure the window is clickable to dismiss this!
    WindowManager.instance.setIgnoreMouseEvents(false);
  }

  void dismissGuardianAlert() {
    _isGuardianAlertActive = false;
    _guardianAlertMessage = null;
    notifyListeners();
  }

  /// Request a summary of recent activity (Contextual Telemetry)
  Future<void> requestContextSummary() async {
    final ai = _aiManager.activeService;
    if (ai == null || _historyBuffer.isEmpty) return;

    try {
      _aiContextSummary = 'AI is summarizing...';
      notifyListeners();
      
      _aiContextSummary = await ai.generateSummary(_historyBuffer);
      notifyListeners();
      
      // Also broadcast this summary to the helper as a message
      await sendPointerEvent(
        normalizedX: 0, 
        normalizedY: 0, 
        type: 'info', 
        message: 'AI CONTEXT: $_aiContextSummary'
      );
    } catch (e) {
      _aiContextSummary = 'Failed to generate summary: $e';
      notifyListeners();
    }
  }

  /// Ask the AI Butler a specific question about the current screen
  /// Optionally uses the Group's Knowledge Base (RAG)
  Future<String> askButler(String question) async {
    final ai = _aiManager.activeService;
    // For Helper side, we use the current frame received from Host
    if (ai == null || _currentFrame == null) return 'Butler is currently unreachable.';

    try {
      _diagnosticLogs.add('[AI Butler]: Thinking...');
      notifyListeners();

      final answer = await ai.askButler(
        _currentFrame!.data.buffer.asUint8List(
          _currentFrame!.data.offsetInBytes,
          _currentFrame!.data.lengthInBytes,
        ), 
        question, 
        knowledgeBase: _aiManager.knowledgeBase,
      );
      
      _diagnosticLogs.add('[AI Butler]: $answer');
      if (_diagnosticLogs.length > _maxLogLength) _diagnosticLogs.removeAt(0);
      notifyListeners();
      
      return answer;
    } catch (e) {
      return 'Butler Error: $e';
    }
  }
}

/// Helper extension for coordinate normalization
extension CoordinateNormalization on LumeSessionState {
  static Map<String, double> normalize({
    required double x,
    required double y,
    required double screenWidth,
    required double screenHeight,
  }) {
    return {
      'x': (x / screenWidth).clamp(0.0, 1.0),
      'y': (y / screenHeight).clamp(0.0, 1.0),
    };
  }
}
