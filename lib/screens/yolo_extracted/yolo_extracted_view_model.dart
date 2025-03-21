import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class YoloExtractedViewModel extends ChangeNotifier {
  final ImagePicker _imagePicker = ImagePicker();

  XFile? _capturedImage;
  XFile? get capturedImage => _capturedImage;
  Uint8List? _capturedImageBytes;
  Uint8List get capturedImageBytes => _capturedImageBytes == null ? Uint8List(0) : _capturedImageBytes!;
  File get capturedImageFile => File(_capturedImage!.path);

  Future<void> takePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );

      if (image != null) {
        _capturedImage = null;
        _capturedImage = image;
        _capturedImageBytes = null;
        _capturedImageBytes = await image.readAsBytes();
        notifyListeners();
      }
    } catch (e) {
      Logger().d('Error capturing image: $e');
      rethrow;
    }
  }

  void clearState() {
    _capturedImage = null;
    _capturedImageBytes = null;
  }
}
