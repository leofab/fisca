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
  Uint8List get capturedImageBytes => _capturedImageBytes!;
  /*
  late Image _capturedImageImage;
  Image get capturedImageImage => _capturedImageImage;
  double _capturedImageImageHeight = 0;
  double get capturedImageImageHeight => _capturedImageImageHeight;
  double _capturedImageImageWidth = 0;
  double get capturedImageImageWidth => _capturedImageImageWidth;
  */
  File get capturedImageFile => File(_capturedImage!.path);

  Future<void> takePhoto() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 100,
      );

      if (image != null) {
        _capturedImage = image;
        _capturedImageBytes = await image.readAsBytes();
        notifyListeners();
      }
      /*
      _capturedImageImage = Image.file(File(capturedImage!.path));
      _capturedImageImageHeight = (capturedImageImage.height) as double;
      _capturedImageImageWidth = (capturedImageImage.width) as double;
      notifyListeners();
      */
    } catch (e) {
      Logger().d('Error capturing image: $e');
      rethrow;
    }
  }
}
