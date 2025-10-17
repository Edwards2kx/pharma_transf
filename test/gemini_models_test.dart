// ignore_for_file: avoid_print

import 'dart:developer';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_gemini/flutter_gemini.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Gemini model initialization', () async {
    // Arrange - Set up any necessary variables or state
    await dotenv.load(fileName: ".env");
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    Gemini.init(apiKey: apiKey!);

    final gemini = Gemini.instance;
    try {
      final info = await gemini.info(model: 'gemini-pro');
      print('Model Info: $info');
    } catch (e) {
      log('Error fetching model info: $e');
    }
    print('mensaje intermedio');
    try {
      final models = await gemini.listModels();
      models.forEach((model) => print('Available Model: ${model.name}'));
    } catch (e) {
      log('Error listing models: $e');
    }
  });
  test('Gemini text prompt test', () async {
    // Arrange - Set up any necessary variables or state
    await dotenv.load(fileName: ".env");
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    Gemini.init(apiKey: apiKey!);

    final gemini = Gemini.instance;
    Candidates? geminiResponse;
    try {
      geminiResponse = await gemini.prompt(
        parts: [
          Part.text('Primer presidente de Colombia'),
        ],
        // model: 'gemini-2.5-flash-lite-preview-06-17',
      );
      print('Response from Gemini: ${geminiResponse?.content?.parts?[0]}');
    } catch (e) {
      log('Error during text prompt: $e');
    }
  });
}
