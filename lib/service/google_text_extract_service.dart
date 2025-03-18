import 'dart:io';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:logger/logger.dart';

class GoogleTextExtractService {
  Future<String> extractText(File file) async {
    final textRecognizer = TextRecognizer(
      script: TextRecognitionScript.latin,
    );
    final InputImage inputImage = InputImage.fromFile(file);
    final RecognizedText recognizedText =
        await textRecognizer.processImage(inputImage);
    final text = recognizedText.text;
    textRecognizer.close();
    return text;
  }

  String? extractHighestValue(String text) {
    final regex = RegExp(r'\b\d+[.,]\d{2}(?!%)\b');

    final matches = regex.allMatches(text);

    if (matches.isEmpty) {
      return 'null';
    }

    final values = matches.map((match) {
      final value = (match.group(0)!).replaceAll(',', '.');
      return double.parse(value);
    }).toList();

    final highestValue = values.last;

    return highestValue.toStringAsFixed(2);
  }

  String? extractCnpj(String text) {
    final regex = RegExp(
        r'(?:PJ|NPJ|CNPJ)[^\d]*(\d{2}\.\d{3}\.\d{3}\/\d{4}\-\d{2}|\d{14})');
    final match = regex.firstMatch(text);

    if (match == null) {
      return 'null';
    }
    final cnpj = match.group(1)!.replaceAll(RegExp(r'[^\d]'), '');
    Logger().i('cnpj: $cnpj');

    return cnpj;

    //return '${cnpj.substring(0, 2)}.${cnpj.substring(2, 5)}.${cnpj.substring(5, 8)}/${cnpj.substring(8, 12)}-${cnpj.substring(12)}';
  }
}
