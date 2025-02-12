import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/screens/yolo_extracted/yolo_extracted_view_model.dart';
import 'package:app/service/yolo_tflite_service.dart';

class YoloExtractedView extends StatelessWidget {
  const YoloExtractedView({super.key});
  @override
  Widget build(BuildContext context) {
    //final yoloExtractedViewModel = Provider.of<YoloExtractedViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Yolo Extracted View'),
      ),
      /*
        body: FutureBuilder(
          future: YoloTfliteService()
              .runModel(yoloExtractedViewModel.capturedImageFile),
          builder: (context, snapshot) =>
              Center(child: Text(snapshot.hasData ? snapshot.data! : 'null')),
        )
        */
    );
  }
}
