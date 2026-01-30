import 'dart:typed_data';

/// Analysis result from an AI Assistant
class AiAnalysisResult {
  final bool isThreat;
  final String description;
  final String rawResponse;

  AiAnalysisResult({
    required this.isThreat,
    required this.description,
    required this.rawResponse,
  });
}

/// Abstract interface for AI Assistant providers (Gemini, Ollama, etc.)
abstract class AiAssistantService {
  /// Name of the provider (e.g., 'Gemini', 'Ollama')
  String get name;

  /// Analyze a frame for security threats or scammers
  Future<AiAnalysisResult> analyzeFrame(Uint8List frameData);

  /// Generate a contextual summary from a set of frames
  Future<String> generateSummary(List<Uint8List> frames);

  /// Ask the "Butler" a question about the current frame, potentially using a knowledge base
  Future<String> askButler(Uint8List frameData, String question, {String? knowledgeBase});

  /// Initialize with a key or endpoint
  Future<void> initialize(String secret);
}
