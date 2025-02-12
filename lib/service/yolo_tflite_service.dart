import 'dart:io';
import 'package:flutter_vision/flutter_vision.dart';

class YoloTfliteService {
  Future<String> runModel(File file) async {
    FlutterVision vision = FlutterVision();
    final imageBytes = await file.readAsBytes();
    await vision.loadYoloModel(
      modelPath: 'assets/best_float32.tflite',
      labels: 'assets/labels.txt',
      modelVersion: 'yolov8',
      quantization: false,
      numThreads: 1,
      useGpu: false,
    );

    final result = await vision.yoloOnImage(
      bytesList: imageBytes,
      imageHeight: 640,
      imageWidth: 640,
      iouThreshold: 0.8,
      confThreshold: 0.4,
      classThreshold: 0.5,
    );
    await vision.closeYoloModel();
    return result.toString();
  }
}
