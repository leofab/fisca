import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class GoogleTextExtractService {
  Future<String> extractText(File file) async {
    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );
    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    String text = recognizedText.text;
    textRecognizer.close();
    text = extractHighestValue(text) ?? text;
    return text;
  }

  String? extractHighestValue(String text) {
    final regex = RegExp(r'\b\d+[.,]\d{2}\b');

    final matches = regex.allMatches(text);

    if (matches.isEmpty) {
      return 'null';
    }

    final values = matches.map((match) {
      String value = match.group(0)!;
      value = value.replaceAll(',', '.');
      return double.parse(value);
    }).toList();

    final highestValue = values.reduce((a, b) => a > b ? a : b);

    return highestValue.toStringAsFixed(2);
  }
}
