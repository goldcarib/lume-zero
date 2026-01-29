import 'package:serverpod/serverpod.dart';
import '../generated/protocol.dart';

class GroupEndpoint extends Endpoint {
  /// Create a new support group
  Future<void> createGroup(Session session, LumeGroup group) async {
    await LumeGroup.db.insertRow(session, group);
  }

  /// Retrieve group configuration (including encrypted AI config)
  Future<LumeGroup?> getGroup(Session session, String name) async {
    return await LumeGroup.db.findFirstRow(
      session,
      where: (t) => t.name.equals(name),
    );
  }
  
  /// Update the group's AI configuration or knowledge base
  Future<bool> updateGroupSettings(
    Session session, 
    String name, 
    String adminHash,
    {String? encryptedAiConfig, String? knowledgeBase}
  ) async {
    final group = await getGroup(session, name);
    if (group == null || group.adminHash != adminHash) {
      session.log('Unauthorized group update attempt for: $name');
      return false;
    }
    
    if (encryptedAiConfig != null) group.encryptedAiConfig = encryptedAiConfig;
    if (knowledgeBase != null) group.knowledgeBase = knowledgeBase;
    
    await LumeGroup.db.updateRow(session, group);
    return true;
  }
}
