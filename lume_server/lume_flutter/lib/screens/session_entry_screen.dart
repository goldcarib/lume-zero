import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../state/lume_session_state.dart';
import '../theme/lume_theme.dart';
import 'host_screen.dart';
import 'client_screen.dart';
import 'support_queue_screen.dart';

/// Session Entry Screen
/// 
/// Simple entry screen where users enter a Room ID and choose Host/Helper role
class SessionEntryScreen extends StatefulWidget {
  const SessionEntryScreen({super.key});

  @override
  State<SessionEntryScreen> createState() => _SessionEntryScreenState();
}

class _SessionEntryScreenState extends State<SessionEntryScreen> {
  final _roomIdController = TextEditingController();
  final _passcodeController = TextEditingController();
  // URL controller removed
  bool _isJoining = false;
  bool _isManualJoinMode = false;
  bool _isGroupMode = false;
  bool _usePasscode = false;

  @override
  void dispose() {
    _roomIdController.dispose();
    _passcodeController.dispose();
    super.dispose();
  }

  void _generateRoomId() {
    const chars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789'; // Readable alphanumeric
    final random = Random();
    final id = String.fromCharCodes(Iterable.generate(
      6, (_) => chars.codeUnitAt(random.nextInt(chars.length)),
    ));
    setState(() {
      _roomIdController.text = id;
    });
  }

  void _copyRoomId() {
    if (_roomIdController.text.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _roomIdController.text));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Room ID copied to clipboard')),
      );
    }
  }

  Future<void> _joinSession({required bool isHost}) async {
    final roomId = _roomIdController.text.trim().toUpperCase();
    
    if (roomId.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter or generate a Room ID')),
      );
      return;
    }
    
    setState(() => _isJoining = true);
    
    try {
      final sessionState = context.read<LumeSessionState>();
      final passcode = _usePasscode || !_isManualJoinMode && _passcodeController.text.isNotEmpty 
          ? _passcodeController.text.trim() 
          : null;
          
      await sessionState.joinSession(roomId, passcode: passcode);
      
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => isHost ? const HostScreen() : const ClientScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to join: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isJoining = false);
      }
    }
  }

  Future<void> _joinGroupSupport() async {
    final groupName = _roomIdController.text.trim().toUpperCase();
    if (groupName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a Group Name (e.g., TECH-HELP)')),
      );
      return;
    }

    setState(() => _isJoining = true);
    try {
      final state = context.read<LumeSessionState>();
      await state.requestGroupSupport(groupName);
      if (mounted) {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const HostScreen()),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to join queue: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isJoining = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              LumeTheme.backgroundDark,
              LumeTheme.surfaceDark,
            ],
          ),
        ),
        child: Center(
          child: Card(
            margin: const EdgeInsets.all(32),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              padding: const EdgeInsets.all(48),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo/Title
                  ShaderMask(
                    shaderCallback: (bounds) => LumeTheme.goldGradient
                        .createShader(bounds),
                    child: const Text(
                      'LUME',
                      style: TextStyle(
                        fontSize: 56,
                        fontWeight: FontWeight.w300,
                        letterSpacing: 8,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  Text(
                    'Collaborative Real-Time Assistant',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: LumeTheme.softBlue,
                      letterSpacing: 1.5,
                    ),
                  ),
                  
                  const SizedBox(height: 48),
                  
                  if (!_isManualJoinMode && !_isGroupMode) ...[
                    // Initial Choice - Share Screen is now primary
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.screen_share, size: 28),
                        label: const Text(
                          'SHARE SCREEN',
                          style: TextStyle(fontSize: 16, letterSpacing: 1.2),
                        ),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 24),
                          backgroundColor: LumeTheme.primaryGold,
                          foregroundColor: Colors.black,
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        onPressed: _isJoining ? null : () {
                          _generateRoomId();
                          _joinSession(isHost: true);
                        },
                      ),
                    ),

                    const SizedBox(height: 16),

                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.remove_red_eye, size: 20),
                        label: const Text('JOIN SESSION'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                          side: const BorderSide(color: Colors.white24),
                        ),
                        onPressed: () => setState(() => _isManualJoinMode = true),
                      ),
                    ),
                  ] else if (_isGroupMode) ...[
                    // Group Support Mode
                    Text(
                      'Request Organizational Support',
                      style: TextStyle(color: LumeTheme.softBlue, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _roomIdController,
                      autofocus: true,
                      decoration: const InputDecoration(
                        labelText: 'Enter Group/Org Name',
                        hintText: 'e.g. FAMILY-TECH',
                        prefixIcon: Icon(Icons.business_rounded),
                      ),
                      onSubmitted: (_) => _joinGroupSupport(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isJoining ? null : _joinGroupSupport,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.all(20),
                        ),
                        child: const Text('JOIN SUPPORT QUEUE'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => setState(() => _isGroupMode = false),
                      child: const Text('BACK TO INDIVIDUAL ROLE'),
                    ),
                  ] else ...[
                    // Join Mode (Enter ID)
                    Text(
                      'Enter Session ID to Join',
                      style: TextStyle(color: LumeTheme.softBlue, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _roomIdController,
                      autofocus: true,
                      decoration: InputDecoration(
                        labelText: 'Session ID',
                        hintText: 'Enter ID to join',
                        prefixIcon: const Icon(Icons.meeting_room),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () {
                            _roomIdController.clear();
                            setState(() => _isManualJoinMode = false);
                          },
                        ),
                      ),
                      onSubmitted: (_) => _joinSession(isHost: false),
                      style: const TextStyle(letterSpacing: 4, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _passcodeController,
                      decoration: const InputDecoration(
                        labelText: 'Session Passcode',
                        hintText: 'Enter password if required',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      obscureText: true,
                      textInputAction: TextInputAction.go,
                      onSubmitted: (_) => _joinSession(isHost: false),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () => setState(() => _isManualJoinMode = false),
                          child: const Text('CANCEL'),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: _isJoining ? null : () => _joinSession(isHost: false),
                          child: const Text('CONNECT NOW'),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 32),
                  
                  // AI Settings Toggle
                  TextButton.icon(
                    onPressed: () => _showAiSettings(context),
                    icon: const Icon(Icons.psychology, size: 20, color: LumeTheme.primaryGold),
                    label: const Text('AI ASSISTANT SETTINGS', style: TextStyle(color: LumeTheme.softBlue, fontSize: 12)),
                  ),

                  const SizedBox(height: 16),
                  
                  // Info text
                  Text(
                    _isManualJoinMode 
                        ? 'Ask the host for their 6-digit room code.' 
                        : 'Host shares their screen. Helper views and guides.',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Colors.white54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _showAiSettings(BuildContext context) {
    final state = context.read<LumeSessionState>();
    final manager = state.aiManager;
    
    bool enabled = manager.isEnabled;
    String provider = manager.getProvider();
    final secretController = TextEditingController(text: manager.getSecret());

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              const Icon(Icons.auto_awesome, color: LumeTheme.primaryGold),
              const SizedBox(width: 12),
              const Text('AI Assistant Settings'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SwitchListTile(
                title: const Text('Enable AI Features'),
                subtitle: const Text('Guardian Mode & Auto-Summary'),
                value: enabled,
                onChanged: (v) => setDialogState(() => enabled = v),
              ),
              if (enabled) ...[
                const Divider(),
                ListTile(
                  title: const Text('AI Provider'),
                  trailing: DropdownButton<String>(
                    value: provider,
                    items: ['Gemini', 'Ollama (Local)']
                        .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                        .toList(),
                    onChanged: (v) => setDialogState(() => provider = v!),
                  ),
                ),
                TextField(
                  controller: secretController,
                  obscureText: provider == 'Gemini',
                  decoration: InputDecoration(
                    labelText: provider == 'Gemini' ? 'API Key' : 'Endpoint URL',
                    hintText: provider == 'Gemini' ? 'Enter Gemini Key' : 'http://127.0.0.1:11434',
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Privacy Note: Keys are stored locally on your device and never sent to Lume servers.',
                  style: TextStyle(fontSize: 11, color: Colors.white54, fontStyle: FontStyle.italic),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: () async {
                await manager.setSettings(
                  enabled: enabled,
                  provider: provider,
                  secret: secretController.text.trim(),
                );
                if (mounted) Navigator.pop(context);
              },
              child: const Text('SAVE & CLOSE'),
            ),
          ],
        ),
      ),
    );
  }
}
