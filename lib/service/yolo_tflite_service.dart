import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';

class YoloTfliteService {
  Future<List<Map<String, dynamic>>> runModel(Uint8List file) async {
    FlutterVision vision = FlutterVision();
    final image = await decodeImageFromList(file);
    final imageHeight = image.height;
    final imageWidth = image.width;
    await vision.loadYoloModel(
      modelPath: 'assets/best_float32.tflite',
      labels: 'assets/labels.txt',
      modelVersion: 'yolov8',
      quantization: false,
      numThreads: 2,
      useGpu: true,
    );

    final result = await vision.yoloOnImage(
      bytesList: file,
      imageHeight: imageHeight,
      imageWidth: imageWidth,
      iouThreshold: 0.5,
      confThreshold: 0.4,
      classThreshold: 0.5,
    );
    for (var element in result) {
      element['imgWidth'] = imageWidth;
      element['imgHeight'] = imageHeight;
    }
    await vision.closeYoloModel();
    return result;
  }
}
