import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/screens/yolo_extracted/yolo_extracted_view_model.dart';
import 'package:app/service/yolo_tflite_service.dart';

class YoloExtractedView extends StatelessWidget {
  const YoloExtractedView({super.key});
  @override
  Widget build(BuildContext context) {
    final yoloExtractedViewModel = Provider.of<YoloExtractedViewModel>(context);
    /*
    final Size screen = MediaQuery.of(context).size;
    final factorX =
        screen.width / (yoloExtractedViewModel.capturedImageImageWidth);
    final imgRatio = yoloExtractedViewModel.capturedImageImageWidth /
        yoloExtractedViewModel.capturedImageImageHeight;
    final newWidth = yoloExtractedViewModel.capturedImageImageWidth * factorX;
    final newHeight = newWidth / imgRatio;
    final factorY =
        newHeight / (yoloExtractedViewModel.capturedImageImageHeight);
    final pady = (screen.height - newHeight) / 2;
    final colorPick = const Color.fromARGB(255, 50, 233, 30);
    */
    return Scaffold(
        appBar: AppBar(
          title: Text('Yolo Extracted View'),
        ),
        body: FutureBuilder(
          future: YoloTfliteService()
              .runModel(yoloExtractedViewModel.capturedImageBytes),
          builder: (context, snapshot) => Center(
              child: snapshot.hasData
                  ? Image.file(
                      yoloExtractedViewModel.capturedImageFile,
                    )
                  : CircularProgressIndicator()),
        ));
  }
}
