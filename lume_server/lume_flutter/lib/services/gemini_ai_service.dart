import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'ai_assistant_service.dart';

class GeminiAiService implements AiAssistantService {
  GenerativeModel? _model;
  String _modelName = 'gemini-1.5-flash'; // Default
  
  @override
  String get name => 'Gemini';

  @override
  Future<void> initialize(String secret) async {
    _modelName = 'gemini-2.5-flash';
    _model = GenerativeModel(
      model: _modelName,
      apiKey: secret,
    );
  }

  @override
  Future<AiAnalysisResult> analyzeFrame(Uint8List frameData) async {
    if (_model == null) throw Exception('Gemini AI not initialized');

    final prompt = TextPart('''
      Analyze this desktop screenshot for common remote access scams. 
      Look for: fake 'System Infected' popups, requests for gift cards, 
      or prompts to open 'AnyDesk', 'TeamViewer' or 'UltraViewer' if it looks suspicious.
      
      Return your response exactly in this format:
      [SAFE] if no threat is found.
      [THREAT: description] if a threat is found.
    ''');

    final imagePart = DataPart('image/jpeg', frameData);
    
    final response = await _model!.generateContent([
      Content.multi([prompt, imagePart])
    ]);

    final text = response.text ?? '';
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

  @override
  Future<String> generateSummary(List<Uint8List> frames) async {
    if (_model == null) throw Exception('Gemini AI not initialized');
    if (frames.isEmpty) return 'No activity history found.';

    final prompt = TextPart('''
      You are an assistant for a technical helper. 
      Look at these sequence of screenshots taken from the user's computer.
      Summarize in ONE short sentence what the user was doing so the helper can catch up.
      Example: "User was attempting to fix a Printer Error in Settings."
    ''');

    final contents = [
      Content.multi([
        prompt,
        ...frames.map((f) => DataPart('image/jpeg', f)),
      ])
    ];

    final response = await _model!.generateContent(contents);
    return response.text ?? 'Could not generate summary.';
  }

  @override
  Future<String> askButler(Uint8List frameData, String question, {String? knowledgeBase}) async {
    if (_model == null) throw Exception('Gemini AI not initialized');

    final knowledgePart = knowledgeBase != null 
        ? 'Use this knowledge base text to help answer the question: \n\n$knowledgeBase\n\n'
        : '';

    final prompt = TextPart('''
      You are a "Butler" assistant for a technical helper. 
      $knowledgePart
      The helper is asking this question about the attached screenshot: "$question"
      Provide a concise and helpful answer based on the visual evidence and the knowledge base.
    ''');

    final contents = [
      Content.multi([
        prompt,
        DataPart('image/jpeg', frameData),
      ])
    ];

    try {
      print('[Gemini]: Asking Butler ($question) using model: $_modelName');
      final response = await _model!.generateContent(contents).timeout(const Duration(seconds: 30));
      final text = response.text;
      
      if (text == null || text.isEmpty) {
        print('[Gemini]: Received empty response.');
        return 'Butler is unable to provide an answer at this time (Empty response).';
      }
      
      print('[Gemini]: Received response: ${text.substring(0, text.length > 50 ? 50 : text.length)}...');
      return text;
    } catch (e) {
      print('[Gemini Error]: $e');
      return 'Butler Error: $e';
    }
  }
}
