import 'dart:async';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:window_manager/window_manager.dart';
import 'package:screen_retriever/screen_retriever.dart';
import '../state/lume_session_state.dart';
import '../services/webrtc_service.dart';
import '../widgets/ghost_cursor.dart';
import '../widgets/action_overlays.dart';
import '../widgets/privacy_overlay.dart';
import '../services/screen_service.dart';
import '../services/ffmpeg_capture_service.dart';
import '../widgets/poi_marker.dart';
import '../widgets/ai_guardian_overlay.dart';
import '../theme/lume_theme.dart';
import 'package:win32/win32.dart';
import 'dart:ffi' hide Size;

class HostScreen extends StatefulWidget {
  const HostScreen({super.key});

  @override
  State<HostScreen> createState() => _HostScreenState();
}

class _HostScreenState extends State<HostScreen> with WindowListener {
  final WebRTCService _webRTCService = WebRTCService();
  final ScreenService _screenService = ScreenService();
  final FfmpegCaptureService _ffmpegService = FfmpegCaptureService();
  bool _isSharing = false;
  Timer? _mouseCheckTimer;
  Timer? _fallbackCaptureTimer;
  Timer? _guardianTimer;
  bool _isIgnoringMouse = true;
  String _captureMode = 'ffmpeg'; // Reverted to FFmpeg (Golden Path)
  
  // Toolbar State
  Offset _toolbarPosition = const Offset(100, 20); // Default top-left-ish
  final double _toolbarWidth = 450.0;
  final double _toolbarHeight = 80.0;

  @override
  void initState() {
    super.initState();
    windowManager.addListener(this);
    _webRTCService.init();
    
    // Setup signaling
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final sessionState = context.read<LumeSessionState>();
      _webRTCService.onSignal = (type, sdp, candidate, sdpMid, sdpMlineIndex) {
        sessionState.sendSignaling(
          type: type,
          sdp: sdp,
          candidate: candidate,
          sdpMid: sdpMid,
          sdpMlineIndex: sdpMlineIndex,
        );
      };
      
      sessionState.onSignalingMessage = (type, sdp, candidate, sdpMid, sdpMlineIndex) {
        if (type == 'use_compatibility_mode') {
          _startCompatibilityMode();
        } else if (type == 'use_ffmpeg_mode') {
          _startFfmpegMode();
        } else {
          _webRTCService.handleSignal(type, sdp, candidate, sdpMid, sdpMlineIndex);
        }
      };
    });
    
    // Auto-discover FFmpeg and initialize
    _ffmpegService.initialize().then((found) {
       if (!found && mounted) {
         ScaffoldMessenger.of(context).showSnackBar(
           const SnackBar(
             content: Text('Warning: FFmpeg not found. Screen sharing may not work.'),
             backgroundColor: Colors.red,
             duration: Duration(seconds: 5),
           ),
         );
       }
    });
  }

  @override
  void dispose() {
    windowManager.removeListener(this);
    _mouseCheckTimer?.cancel();
    _fallbackCaptureTimer?.cancel();
    _guardianTimer?.cancel();
    _webRTCService.dispose();
    super.dispose();
  }

  Future<void> _startSharing() async {
    setState(() => _isSharing = true);
    
    // Apply Capture Exclusion (Hide from helper)
    try {
      final hwnd = GetActiveWindow();
      if (hwnd != 0) {
        SetWindowDisplayAffinity(hwnd, WDA_EXCLUDEFROMCAPTURE);
        debugPrint('Applied capture exclusion to HWND: $hwnd');
      }
    } catch (e) {
      debugPrint('Failed to apply capture exclusion: $e');
    }

    // Configure window for overlay mode
    await windowManager.setFullScreen(true);
    await windowManager.setBackgroundColor(Colors.transparent);
    // Enable click-through
    await windowManager.setIgnoreMouseEvents(true);
    
    // Start capture based on mode
    if (_captureMode == 'ffmpeg') {
       await _startFfmpegMode(); // Use efficient, silent FFmpeg stream
    } else if (_captureMode == 'webrtc') {
      await _webRTCService.startScreenShare();
    } else {
      await _startCompatibilityMode();
    }

    // Configure window for overlay mode
    await windowManager.setFullScreen(true);
    await windowManager.setBackgroundColor(Colors.transparent);
    // Enable click-through
    await windowManager.setIgnoreMouseEvents(true);
    await windowManager.setAlwaysOnTop(true);

    // Start AI Guardian & Telemetry if enabled
    _startAiFeatures();
    
    // Start smart mouse detection
    _mouseCheckTimer = Timer.periodic(const Duration(milliseconds: 200), (_) => _checkMouseFocus());
  }

  void _startAiFeatures() {
    final sessionState = context.read<LumeSessionState>();
    if (!sessionState.aiManager.isEnabled) return;

    // 1. Initial Context Summary (What was I doing?)
    Future.delayed(const Duration(seconds: 2), () {
      sessionState.requestContextSummary();
    });

    // 2. Guardian Mode (Scam Detection)
    _guardianTimer = Timer.periodic(const Duration(seconds: 15), (timer) async {
      if (!_isSharing) return;

      Uint8List? frame;
      
      // If we are in FFmpeg mode, we should NOT trigger a new capture
      // because that invokes screen_capturer which makes noise/freezes.
      if (_captureMode == 'ffmpeg') {
         // In a real implementation, we'd cache the last frame from the stream.
         // For now, we'll SKIP the separate capture to silence the noise 
         // and rely on the stream itself if possible, or implement a silent cache.
         // BUT simplest fix: Use the ffmpeg service to grab a frame silently if possible
         // or just use the last frame hash.
         
         // Better fix: Let's grab a fresh silent frame using FFmpeg 
         // since we know that works silently.
         frame = await _ffmpegService.captureFrame(quality: 20);
      } else {
         // Fallback for other modes
         frame = await _screenService.captureScreenshot();
      }

      if (frame != null) {
        final ai = sessionState.aiManager.activeService;
        if (ai != null) {
          try {
            final result = await ai.analyzeFrame(frame);
            if (result.isThreat) {
              sessionState.triggerGuardianAlert(result.description);
            }
          } catch (e) {
            debugPrint('AI Guardian Error: $e');
          }
        }
      }
    });
  }

  Future<void> _checkMouseFocus() async {
    if (!_isSharing) return;
    
    
    try {
      final mousePos = await screenRetriever.getCursorScreenPoint();
      final bool isOverToolbar = 
          mousePos.dx >= _toolbarPosition.dx && 
          mousePos.dx <= _toolbarPosition.dx + _toolbarWidth && 
          mousePos.dy >= _toolbarPosition.dy && 
          mousePos.dy <= _toolbarPosition.dy + _toolbarHeight;
      
      final bool shouldEnableMouse = isOverToolbar;
      
      if (shouldEnableMouse && _isIgnoringMouse) {
        await windowManager.setIgnoreMouseEvents(false);
        _isIgnoringMouse = false;
      } else if (!shouldEnableMouse && !_isIgnoringMouse) {
        await windowManager.setIgnoreMouseEvents(true);
        _isIgnoringMouse = true;
      }
    } catch (e) {
      // Fallback to safety if screenRetriever fails
      if (!_isIgnoringMouse) {
        await windowManager.setIgnoreMouseEvents(true);
        _isIgnoringMouse = true;
      }
    }
  }

  Future<void> _startCompatibilityMode() async {
    final sessionState = context.read<LumeSessionState>();
    setState(() => _captureMode = 'snapshot');
    print('Switching to Compatibility Mode (Snapshots) at ${sessionState.quality}');
    
    _stopCaptureTimers();
    
    // Adjust timing based on quality
    final interval = switch (sessionState.quality) {
      LumeQuality.eco => const Duration(seconds: 1),
      LumeQuality.balanced => const Duration(milliseconds: 500),
      LumeQuality.high => const Duration(milliseconds: 333),
    };

    final qualityValue = switch (sessionState.quality) {
      LumeQuality.eco => 60,
      LumeQuality.balanced => 40,
      LumeQuality.high => 20,
    };

    _fallbackCaptureTimer = Timer.periodic(interval, (timer) async {
       if (!sessionState.isConnected) return;
       
       final result = await _screenService.captureCompressedFrame(quality: qualityValue);
       if (result != null) {
         sessionState.sendFrame(result.data, width: result.width, height: result.height);
       }
    });
  }

  Future<void> _startFfmpegMode() async {
    final sessionState = context.read<LumeSessionState>();
    setState(() => _captureMode = 'ffmpeg');
    print('Switching to FFmpeg Mode (Silent Snapshots) at ${sessionState.quality}');
    
    _stopCaptureTimers();

    // Adjust timing and quality based on selection
    final interval = switch (sessionState.quality) {
      LumeQuality.eco => const Duration(seconds: 2),
      LumeQuality.balanced => const Duration(seconds: 1),
      LumeQuality.high => const Duration(milliseconds: 500),
    };

    final qv = switch (sessionState.quality) {
      LumeQuality.eco => 20,
      LumeQuality.balanced => 8,
      LumeQuality.high => 5,
    };

    // Get screen size ONCE to pass to client (for pointer normalization)
    // This assumes screen size doesn't change during session, which is fair.
    int width = 1920; 
    int height = 1080;
    try {
      final display = await screenRetriever.getPrimaryDisplay();
      width = display.size.width.toInt();
      height = display.size.height.toInt();
    } catch (e) {
      debugPrint('Error getting display size: $e');
    }

    _ffmpegService.startPeriodicCapture(interval, (data) {
       sessionState.sendFrame(
         ByteData.view(data.buffer),
         width: width,
         height: height
       );
    }, quality: qv);
  }

  void _stopCaptureTimers() {
    _fallbackCaptureTimer?.cancel();
    _ffmpegService.stop();
  }

   Future<void> _stopSharing() async {
    try {
      _mouseCheckTimer?.cancel();
      _stopCaptureTimers();
      _webRTCService.dispose();
      
      final sessionState = context.read<LumeSessionState>();
      await sessionState.leaveSession(); // End session on server/state

      await windowManager.setAlwaysOnTop(false);
      await windowManager.setFullScreen(false);
      await windowManager.setBackgroundColor(Colors.white);
      await windowManager.setIgnoreMouseEvents(false);

      // Reset Capture Exclusion (make visible to capture again)
      final hwnd = GetActiveWindow();
      if (hwnd != 0) {
        SetWindowDisplayAffinity(hwnd, WDA_NONE);
        debugPrint('Reset capture exclusion for HWND: $hwnd');
      }
    } catch (e) {
      debugPrint('Error during stopSharing: $e');
    }

    // Exit the application completely to avoid blank screen
    if (mounted) {
      SystemNavigator.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isSharing) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Share Screen'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              context.read<LumeSessionState>().leaveSession();
              Navigator.pop(context);
            },
          ),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Ready to share screen'),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                icon: const Icon(Icons.screen_share),
                label: const Text('Start Sharing & Overlay'),
                onPressed: _startSharing,
              ),
              const SizedBox(height: 20),
              const Text(
                'Note: Window will become transparent and click-through.\nUse Alt+F4 or Taskbar to close.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    // Overlay Mode
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Consumer<LumeSessionState>(
        builder: (context, state, _) {
          final currentEvent = state.currentPointerEvent;
          final history = state.pointerHistory;
          final lastAction = state.lastActionEvent;
          
          return Stack(
            children: [
              // Ghost Cursor
              if (currentEvent != null)
                GhostCursor(
                  currentEvent: currentEvent,
                  history: history,
                  screenWidth: MediaQuery.of(context).size.width,
                  screenHeight: MediaQuery.of(context).size.height,
                ),
                
               // Action Overlays (Look here, check this)
          if (state.pointingAt != null)
            _buildActionOverlay(state.pointingAt!, MediaQuery.of(context).size),

          // Points of Interest
          ...state.pois.map((poi) => PoiMarker(
            key: ValueKey(poi.id),
            x: poi.x * MediaQuery.of(context).size.width,
            y: poi.y * MediaQuery.of(context).size.height,
            duration: const Duration(seconds: 15),
          )),

          // AI Guardian Alert
          if (state.isGuardianAlertActive)
            AiGuardianOverlay(
              message: state.guardianAlertMessage ?? 'Potential security threat detected.',
              onDismiss: () async {
                state.dismissGuardianAlert();
                // Resume click-through
                await windowManager.setIgnoreMouseEvents(true);
              },
            ),
            
          // Draggable Toolbar
           Positioned(
             left: _toolbarPosition.dx,
             top: _toolbarPosition.dy,
             child: GestureDetector(
               onPanUpdate: (details) {
                 setState(() {
                   _toolbarPosition += details.delta;
                 });
               },
               child: _buildUnifiedToolbar(state),
             ),
           ),
        ],
      );
    },
  ),
);
}

  Widget _buildUnifiedToolbar(LumeSessionState state) {
    return Container(
      width: _toolbarWidth,
      // height: _toolbarHeight, // Let it size itself, we check loose bounds
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.black87,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 16,
            spreadRadius: 4,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Row(
            children: [
              const Icon(Icons.drag_indicator, color: Colors.white38, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Session: ${state.sessionId ?? "..."}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                ),
              ),
              IconButton(
                onPressed: _stopSharing,
                icon: const Icon(Icons.stop_circle, color: Colors.redAccent),
                tooltip: 'Stop Sharing',
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const Divider(color: Colors.white10),
          // Controls
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (state.aiManager.isEnabled)
                 Tooltip(
                  message: 'AI Guardian Active',
                  child: Icon(Icons.shield, color: LumeTheme.primaryGold, size: 16),
                ),
              _buildQualityToggle("ECO", state.quality == LumeQuality.eco, () => _updateQuality(state, LumeQuality.eco)),
              _buildQualityToggle("BALANCED", state.quality == LumeQuality.balanced, () => _updateQuality(state, LumeQuality.balanced)),
              _buildQualityToggle("HIGH", state.quality == LumeQuality.high, () => _updateQuality(state, LumeQuality.high)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQualityToggle(String label, bool active, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        backgroundColor: active ? Colors.white10 : Colors.transparent,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(
        label, 
        style: TextStyle(
          fontSize: 10, 
          color: active ? LumeTheme.primaryGold : Colors.white54,
          fontWeight: active ? FontWeight.bold : FontWeight.normal
        )
      ),
    );
  }

  void _updateQuality(LumeSessionState state, LumeQuality quality) {
    state.setQuality(quality);
    if (_captureMode == 'snapshot') _startCompatibilityMode();
    if (_captureMode == 'ffmpeg') _startFfmpegMode();
  }
  
  Widget _buildActionOverlay(dynamic actionEvent, Size screenSize) {
    // Reuse logic from SessionScreen or refactor to shared widget
    // Ideally duplicate logic for now for speed
    if (actionEvent.action == null) return const SizedBox.shrink();
    
    final x = actionEvent.x * screenSize.width;
    final y = actionEvent.y * screenSize.height;
    
    Widget overlay;
    switch (actionEvent.action) {
      case 'look_here':
        overlay = const LookHereRing();
        break;
      case 'check_box':
        overlay = const ArrowPointer();
        break;
      default:
        return const SizedBox.shrink();
    }
    
    return Positioned(
      left: x - 50,
      top: y - 50,
      child: overlay,
    );
  }

}
