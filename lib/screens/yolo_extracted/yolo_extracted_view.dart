import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:app/screens/camera/camera_view_model.dart';

class YoloExtractedView extends StatefulWidget {
  @override
  _YoloExtractedViewState createState() => _YoloExtractedViewState();
}

class _YoloExtractedViewState extends State<YoloExtractedView> {
  List<dynamic> _output = [];
  Future<void> runModel(List<double> input) async {
    final interpreter =
        await Interpreter.fromAsset('assets/best_float32.tflite');

    final outputShape = interpreter.getOutputTensor(0).shape;
    final outputBuffer = List.filled(outputShape.reduce((a, b) => a * b), 0)
        .reshape(outputShape);
    interpreter.run(input, outputBuffer);
    setState(() {
      _output = outputBuffer;
    });

    Logger().d('Output shape: $outputShape');
    interpreter.close();
  }

  @override
  Widget build(BuildContext context) {
    final cameraViewModel = Provider.of<CameraViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Yolo Extracted View'),
      ),
      body: FutureBuilder<void>(
        future: cameraViewModel.preprocessImage(cameraViewModel.capturedImage!),
        builder: (context, snapshot) {
          if (cameraViewModel.preprocIm.isNotEmpty) {
            return FutureBuilder<void>(
                future: runModel(cameraViewModel.preprocIm),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.done) {
                    return Center(child: Text('Output: ${_output.shape}'));
                  }
                  return Center(child: CircularProgressIndicator());
                });
          } else {
            return Center(child: Text('No image captured'));
          }
        },
      ),
    );
  }
}
