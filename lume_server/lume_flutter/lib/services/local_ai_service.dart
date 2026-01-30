import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'ai_assistant_service.dart';

class LocalAiService implements AiAssistantService {
  String? _endpoint;
  
  @override
  String get name => 'Ollama (Local)';

  @override
  Future<void> initialize(String secret) async {
    _endpoint = secret; // In this case, secret is the URL e.g. http://127.0.0.1:11434
  }

  @override
  Future<AiAnalysisResult> analyzeFrame(Uint8List frameData) async {
    if (_endpoint == null) throw Exception('Local AI endpoint not set');

    final base64Image = base64Encode(frameData);
    
    try {
      final response = await http.post(
        Uri.parse('$_endpoint/api/generate'),
        body: jsonEncode({
          'model': 'llava', // Defaulting to llava as it is vision capable
          'prompt': 'Analyze this desktop screenshot for common remote access scams. Return [SAFE] if no threat is found, otherwise [THREAT: description].',
          'images': [base64Image],
          'stream': false,
        }),
      ).timeout(const Duration(seconds: 15));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final text = data['response'] ?? '';
        final isThreat = text.toUpperCase().contains('[THREAT');
        
        String description = 'Unknown threat detected';
        if (isThreat) {
          final parts = text.split('THREAT:');
          if (parts.length > 1) {
            description = parts[1].replaceAll(']', '').trim();
          }
        }

        return AiAnalysisResult(
          isThreat: isThreat,
          description: description,
          rawResponse: text,
        );
      }
    } catch (e) {
      return AiAnalysisResult(isThreat: false, description: 'Error: $e', rawResponse: '');
    }
    
    return AiAnalysisResult(isThreat: false, description: 'Unknown error', rawResponse: '');
  }

  @override
  Future<String> generateSummary(List<Uint8List> frames) async {
    // Summarizing multiple frames might be slow for local AI, but let's try with the last one
    if (frames.isEmpty) return 'No activity history.';
    
    final result = await analyzeFrame(frames.last);
    return 'Context: ${result.rawResponse}';
  }

  @override
  Future<String> askButler(Uint8List frameData, String question, {String? knowledgeBase}) async {
    if (_endpoint == null) throw Exception('Local AI endpoint not set');

    final knowledgePart = knowledgeBase != null 
        ? 'Using this information: \n\n$knowledgeBase\n\n'
        : '';

    final base64Image = base64Encode(frameData);
    
    try {
      final response = await http.post(
        Uri.parse('$_endpoint/api/generate'),
        body: jsonEncode({
          'model': 'llava',
          'prompt': '$knowledgePart Question: $question',
          'images': [base64Image],
          'stream': false,
        }),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['response'] ?? 'Butler could not respond.';
      }
    } catch (e) {
      return 'Butler Error: $e';
    }
    return 'Butler Error: Unknown response from local AI.';
  }
}
