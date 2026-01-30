import 'package:shared_preferences/shared_preferences.dart';
import 'ai_assistant_service.dart';
import 'gemini_ai_service.dart';
import 'local_ai_service.dart';

class AiManager {
  static const String _kProviderKey = 'lume_ai_provider';
  static const String _kSecretKey = 'lume_ai_secret';
  static const String _kEnabledKey = 'lume_ai_enabled';
  static const String _kKnowledgeBaseKey = 'lume_ai_kb';
  static const String _kGroupIdKey = 'lume_group_id';

  SharedPreferences? _prefs;
  AiAssistantService? _activeService;
  bool _isEnabled = false;
  String? _knowledgeBase;
  String? _groupId;

  bool get isEnabled => _isEnabled;
  AiAssistantService? get activeService => _activeService;
  String? get knowledgeBase => _knowledgeBase;
  String? get groupId => _groupId;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isEnabled = _prefs?.getBool(_kEnabledKey) ?? false;
    
    final provider = _prefs?.getString(_kProviderKey) ?? 'Gemini';
    final secret = _prefs?.getString(_kSecretKey) ?? '';
    _knowledgeBase = _prefs?.getString(_kKnowledgeBaseKey);
    _groupId = _prefs?.getString(_kGroupIdKey);

    if (_isEnabled && secret.isNotEmpty) {
      await _setupService(provider, secret);
    }
  }

  /// Manually configure AI settings
  Future<void> setSettings({
    required bool enabled,
    required String provider,
    required String secret,
    String? knowledgeBase,
    String? groupId,
  }) async {
    _isEnabled = enabled;
    _knowledgeBase = knowledgeBase;
    _groupId = groupId;

    await _prefs?.setBool(_kEnabledKey, enabled);
    await _prefs?.setString(_kProviderKey, provider);
    await _prefs?.setString(_kSecretKey, secret);
    
    if (knowledgeBase != null) {
      await _prefs?.setString(_kKnowledgeBaseKey, knowledgeBase);
    } else {
      await _prefs?.remove(_kKnowledgeBaseKey);
    }

    if (groupId != null) {
      await _prefs?.setString(_kGroupIdKey, groupId);
    } else {
      await _prefs?.remove(_kGroupIdKey);
    }

    if (enabled && secret.isNotEmpty) {
      await _setupService(provider, secret);
    } else {
      _activeService = null;
    }
  }

  /// Provision AI from a group (usually triggered by a server response)
  Future<void> provisionGroupAi({
    required String provider,
    required String secret,
    required String? knowledgeBase,
    required String groupId,
  }) async {
    _isEnabled = true;
    _knowledgeBase = knowledgeBase;
    _groupId = groupId;
    // We don't persist these as they are group-inherited for the session
    await _setupService(provider, secret);
  }

  String getProvider() => _prefs?.getString(_kProviderKey) ?? 'Gemini';
  String getSecret() => _prefs?.getString(_kSecretKey) ?? '';

  Future<void> _setupService(String provider, String secret) async {
    if (provider == 'Gemini' || provider == 'Gemini Pro') {
      _activeService = GeminiAiService();
    } else {
      _activeService = LocalAiService();
    }
    await _activeService?.initialize(secret);
  }
}
