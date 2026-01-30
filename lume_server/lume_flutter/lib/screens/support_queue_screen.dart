import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lume_server_client/lume_server_client.dart';
import '../state/lume_session_state.dart';
import '../theme/lume_theme.dart';
import 'client_screen.dart';

class SupportQueueScreen extends StatefulWidget {
  const SupportQueueScreen({super.key});

  @override
  State<SupportQueueScreen> createState() => _SupportQueueScreenState();
}

class _SupportQueueScreenState extends State<SupportQueueScreen> {
  final _groupController = TextEditingController();
  List<LumeSession>? _waitingSessions;
  bool _isLoading = false;

  Future<void> _refreshQueue() async {
    final groupName = _groupController.text.trim().toUpperCase();
    if (groupName.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final sessions = await context.read<LumeSessionState>().getWaitingSessions(groupName);
      setState(() => _waitingSessions = sessions);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Helper Dashboard')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _groupController,
                    decoration: const InputDecoration(
                      labelText: 'Manage Group Support',
                      hintText: 'Enter Group ID (e.g. TECH-HELP)',
                    ),
                    onSubmitted: (_) => _refreshQueue(),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton.filled(
                  icon: const Icon(Icons.refresh),
                  onPressed: _isLoading ? null : _refreshQueue,
                ),
              ],
            ),
            const SizedBox(height: 32),
            if (_waitingSessions == null)
              const Expanded(
                child: Center(
                  child: Text('Enter a Group ID to see waiting users.', 
                    style: TextStyle(color: Colors.white38)),
                ),
              )
            else if (_waitingSessions!.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('All clear! No users waiting for help.', 
                    style: TextStyle(color: Colors.greenAccent)),
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: _waitingSessions!.length,
                  itemBuilder: (context, index) {
                    final session = _waitingSessions![index];
                    final waitTime = DateTime.now().difference(session.createdAt);
                    
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      color: LumeTheme.surfaceDark,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: waitTime.inMinutes > 5 ? Colors.red : LumeTheme.primaryGold,
                          child: const Icon(Icons.person, color: Colors.black),
                        ),
                        title: Text('Session ${session.roomId}'),
                        subtitle: Text('Waiting for ${waitTime.inMinutes}m ${waitTime.inSeconds % 60}s'),
                        trailing: ElevatedButton(
                          onPressed: () => _joinSession(session.roomId),
                          child: const Text('HELP NOW'),
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _joinSession(String roomId) async {
    try {
      await context.read<LumeSessionState>().startAssisting(roomId);
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const ClientScreen()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to join: $e')));
    }
  }
}
