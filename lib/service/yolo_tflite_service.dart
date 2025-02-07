import 'dart:io';
import 'package:logger/logger.dart';
import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class YoloTfliteService {
  Future<String> runModel(File input) async {
    try {
      final imageBytes = await input.readAsBytes();
      final image = decodeImage(imageBytes);
      final resizedImage = copyResize(image!, width: 640, height: 640);
      final normalizedImage = List<double>.filled(640 * 640 * 3, 0);
      int index = 0;
      for (var y = 0; y < 640; y++) {
        for (var x = 0; x < 640; x++) {
          final pixel = resizedImage.getPixel(x, y);
          normalizedImage[index++] = pixel.r / 255.0;
          normalizedImage[index++] = pixel.g / 255.0;
          normalizedImage[index++] = pixel.b / 255.0;
        }
      }
      final interpreter =
          await Interpreter.fromAsset('assets/best_float32.tflite');
      final inputShape = interpreter.getInputTensor(0).shape;
      if (normalizedImage.length != inputShape.reduce((a, b) => a * b)) {
        Logger().e(
          'Invalid input size: Expected ${inputShape.reduce((a, b) => a * b)}, got ${normalizedImage.length}',
        );
        interpreter.close();
        return "Error: Incorrect input shape";
      }
      final inputTensor = normalizedImage.reshape(inputShape);
      final outputShape = interpreter.getOutputTensor(0).shape;
      final outputBuffer = List.filled(outputShape.reduce((a, b) => a * b), 0)
          .reshape(outputShape);
      interpreter.run(inputTensor, outputBuffer);
      interpreter.close();
      return outputBuffer.shape.toString();
    } catch (e) {
      Logger().e('Error running model: $e');
      rethrow;
    }
  }
}
