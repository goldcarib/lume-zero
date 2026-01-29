import 'dart:async';
import '../generated/protocol.dart';
import 'package:serverpod/serverpod.dart';

/// Streaming endpoint for real-time session events (pointers + frames)
class PointerStreamEndpoint extends Endpoint {
  
  /// Map of sessionId -> Set of StreamControllers for that session
  static final Map<String, Set<StreamController<SessionMessage>>> _sessionStreams = {};
  
  /// Map of sessionId -> Passcode (ephemeral)
  static final Map<String, String> _sessionPasscodes = {};
  
  /// Stream endpoint that clients subscribe to
  Stream<SessionMessage> subscribe(Session session, String sessionId, {String? passcode}) async* {
    final controller = StreamController<SessionMessage>();
    
    // Validate passcode if session already exists
    if (_sessionPasscodes.containsKey(sessionId)) {
      if (_sessionPasscodes[sessionId] != passcode) {
        session.log('Client denied: Invalid passcode for session $sessionId');
        yield SessionMessage(
          sessionId: sessionId,
          timestamp: DateTime.now(),
          signalingType: 'error',
          sdp: 'Invalid session passcode',
        );
        return;
      }
    } else if (passcode != null && passcode.isNotEmpty) {
      // First client (Host) sets the passcode
      _sessionPasscodes[sessionId] = passcode;
      session.log('Session $sessionId created with passcode');
    }
    
    _sessionStreams.putIfAbsent(sessionId, () => {}).add(controller);
    
    session.log('Client joined session: $sessionId');
    
    try {
      await for (final event in controller.stream) {
        yield event;
      }
    } finally {
      _sessionStreams[sessionId]?.remove(controller);
      
      if (_sessionStreams[sessionId]?.isEmpty ?? false) {
        _sessionStreams.remove(sessionId);
        _sessionPasscodes.remove(sessionId); // Clean up passcode
      }
      
      controller.close();
      session.log('Client left session: $sessionId');
    }
  }
  
  /// Broadcast a session message to all clients in the same session
  Future<void> broadcast(Session session, SessionMessage message) async {
    // Add server timestamp if missing (though usually set by client or here)
    // We can recreate it to ensure server time
    final stampedMessage = message.copyWith(timestamp: DateTime.now());
    
    final streams = _sessionStreams[message.sessionId];
    
    if (streams == null || streams.isEmpty) {
      return;
    }
    
    for (final controller in streams) {
      if (!controller.isClosed) {
        controller.add(stampedMessage);
      }
    }
  }
  
  /// Get the number of active clients in a session
  Future<int> getSessionClientCount(Session session, String sessionId) async {
    return _sessionStreams[sessionId]?.length ?? 0;
  }
}
