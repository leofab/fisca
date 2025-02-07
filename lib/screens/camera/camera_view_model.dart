import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart';
import 'package:logger/logger.dart';

class CameraViewModel with ChangeNotifier {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _capturedImage;
  XFile? get capturedImage => _capturedImage;
  File get capturedImageFile => File(_capturedImage!.path);
  List<double> _preprocIm = [];
  List<double> get preprocIm => _preprocIm;

  Future<void> takePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );

      if (image != null) {
        _capturedImage = image;
        notifyListeners();
      }
    } catch (e) {
      Logger().d('Error capturing image: $e');
      rethrow;
    }
  }

  Future<List<double>> preprocessImage(XFile imageFile) async {
    final File file = File(imageFile.path);
    final imageBytes = await file.readAsBytes();

    final image = decodeImage(imageBytes);

    final resizedImage = copyResize(image!, width: 640, height: 640);

    final normalizedImage = List<double>.filled(1 * 640 * 640 * 3, 0);
    int index = 0;
    for (var y = 0; y < 640; y++) {
      for (var x = 0; x < 640; x++) {
        final pixel = resizedImage.getPixel(x, y);
        normalizedImage[index++] = pixel.r / 255.0;
        normalizedImage[index++] = pixel.g / 255.0;
        normalizedImage[index++] = pixel.b / 255.0;
      }
    }

    _preprocIm = normalizedImage;
    //Logger().d('Preprocessed image: $_preprocIm');

    notifyListeners();

    return normalizedImage;
  }

  void clearImage() {
    _capturedImage = null;
    notifyListeners();
  }
}
