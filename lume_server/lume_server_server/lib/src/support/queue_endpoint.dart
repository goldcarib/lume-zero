import 'dart:math';
import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class QueueEndpoint extends Endpoint {
  /// Host requests support from a specific group
  Future<LumeSession> requestSupport(Session session, String groupId) async {
    // Generate a fresh random room ID
    final roomId = _generateRoomId();
    
    final lumeSession = LumeSession(
      roomId: roomId,
      groupId: groupId,
      status: SessionStatus.waiting,
      createdAt: DateTime.now(),
    );
    
    await LumeSession.db.insertRow(session, lumeSession);
    return lumeSession;
  }

  /// Helper gets all pending requests for their group
  Future<List<LumeSession>> getWaitingSessions(Session session, String groupId) async {
    return await LumeSession.db.find(
      session,
      where: (t) => t.groupId.equals(groupId) & (t.status.equals(SessionStatus.waiting)),
      orderBy: (t) => t.createdAt,
    );
  }

  /// Helper marks a session as active and joins it
  Future<bool> startAssisting(Session session, String roomId) async {
    final lumeSession = await LumeSession.db.findFirstRow(
      session,
      where: (t) => t.roomId.equals(roomId),
    );
    
    if (lumeSession == null) return false;
    
    lumeSession.status = SessionStatus.active;
    await LumeSession.db.updateRow(session, lumeSession);
    return true;
  }

  String _generateRoomId() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
    final random = Random();
    return List.generate(6, (index) => chars[random.nextInt(chars.length)]).join();
  }
}
