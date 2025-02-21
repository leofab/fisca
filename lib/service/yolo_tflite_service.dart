import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_vision/flutter_vision.dart';
import 'package:image/image.dart';
import 'package:path_provider/path_provider.dart';
import 'package:logger/logger.dart';

class YoloTfliteService {
  Future<List<File>> runModel(Uint8List file) async {
    try {
      FlutterVision vision = FlutterVision();
      final image = await decodeImageFromList(file);
      final imageHeight = image.height;
      final imageWidth = image.width;
      await vision.loadYoloModel(
        modelPath: 'assets/best_float32.tflite',
        labels: 'assets/labels.txt',
        modelVersion: 'yolov8',
        quantization: true,
        numThreads: 2,
        useGpu: true,
      );

      final results = await vision.yoloOnImage(
        bytesList: file,
        imageHeight: imageHeight,
        imageWidth: imageWidth,
        iouThreshold: 0.5,
        confThreshold: 0.4,
        classThreshold: 0.5,
      );
      Logger().i('Results: ${results.toString()}');
      List<File> croppedImageFiles = [];
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final imageImage = decodeImage(file);
      for (var i = 0; i < results.length; i++) {
        var result = results[i];
        int x1 = (result["box"][0]).toInt();
        int y1 = (result["box"][1]).toInt();
        int x2 = (result["box"][2]).toInt();
        int y2 = (result["box"][3]).toInt();

        int width = x2 - x1;
        int height = y2 - y1;

        final croppedImage =
            copyCrop(imageImage!, x: x1, y: y1, width: width, height: height);

        Uint8List croppedImageBytes =
            Uint8List.fromList(encodePng(croppedImage));
        String filePath = '${directory.path}/cropped_image_${timestamp}_$i.png';
        File croppedFile = File(filePath);
        await croppedFile.writeAsBytes(croppedImageBytes);
        result['tag'] == 'LABEL'
            ? croppedImageFiles.insert(0, croppedFile)
            : croppedImageFiles.add(croppedFile);
      }
      await vision.closeYoloModel();
      Logger().i('Number of cropped images: ${croppedImageFiles.length}');
      return croppedImageFiles;
    } catch (e) {
      Logger().e(e);
      rethrow;
    }
  }
}
