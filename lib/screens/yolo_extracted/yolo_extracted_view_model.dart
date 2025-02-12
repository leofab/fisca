import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class YoloExtractedViewModel extends ChangeNotifier {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _capturedImage;
  XFile? get capturedImage => _capturedImage;
  File get capturedImageFile => File(_capturedImage!.path);

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
}
