import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lume_server_client/lume_server_client.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';
import 'state/lume_session_state.dart';
import 'screens/session_entry_screen.dart';
import 'theme/lume_theme.dart';

import 'package:window_manager/window_manager.dart';

import 'dart:io';
import 'dart:convert';
import 'package:path/path.dart' as p;

// Default Configuration (Fallback)
const String kDefaultLocalUrl = 'https://lume-zero.onrender.com/';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();
  
  // Load Runtime Config
  final config = await _loadConfig();
  final String serverUrl = config['serverUrl'] ?? kDefaultLocalUrl;
  
  debugPrint('🚀 Starting Lume with Server URL: $serverUrl');
  
  final client = Client(
    serverUrl,
  )..connectivityMonitor = FlutterConnectivityMonitor();
  
  runApp(LumeApp(serverpodClient: client));
}

/// Loads configuration from 'config.json' next to the executable
Future<Map<String, dynamic>> _loadConfig() async {
  try {
    // Get executable directory
    final exePath = Platform.resolvedExecutable;
    final dir = p.dirname(exePath);
    final configPath = p.join(dir, 'config.json');
    final configFile = File(configPath);

    if (await configFile.exists()) {
      final content = await configFile.readAsString();
      final Map<String, dynamic> json = jsonDecode(content);
      return json;
    }
  } catch (e) {
    debugPrint('⚠️ Failed to load config.json: $e');
  }
  
  // Return empty map to use defaults
  return {};
}

/// Main Lume Application
class LumeApp extends StatelessWidget {
  final Client serverpodClient;
  
  const LumeApp({
    super.key,
    required this.serverpodClient,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LumeSessionState(serverpodClient),
      child: MaterialApp(
        title: 'Lume',
        theme: LumeTheme.darkTheme,
        home: const SessionEntryScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
