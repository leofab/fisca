import 'dart:io';

import 'package:app/screens/camera/camera_view_model.dart';
import 'package:flutter/material.dart';
import 'package:app/service/google_text_extract_service.dart';
import 'package:provider/provider.dart';

class ExtractedView extends StatelessWidget {
  const ExtractedView({super.key});

  @override
  Widget build(BuildContext context) {
    final cameraViewModel = Provider.of<CameraViewModel>(context);
    if (cameraViewModel.capturedImage != null) {
      return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text('Extracted Text'),
        ),
        body: FutureBuilder(
            future: GoogleTextExtractService()
                .extractText(cameraViewModel.capturedImageFile),
            builder: (context, snapshot) {
              return Center(child: Text(snapshot.data ?? ''));
            }),
      );
    }
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: true,
          title: const Text('Extracted Text'),
        ),
        body: Center(child: Text('No image captured')));
  }
}
