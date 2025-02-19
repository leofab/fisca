import 'package:app/service/google_text_extract_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/screens/yolo_extracted/yolo_extracted_view_model.dart';
import 'package:app/service/yolo_tflite_service.dart';

class YoloExtractedView extends StatefulWidget {
  const YoloExtractedView({super.key});

  @override
  State<YoloExtractedView> createState() => _YoloExtractedViewState();
}

class _YoloExtractedViewState extends State<YoloExtractedView> {
  /*
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _valueController = TextEditingController();
  */
  @override
  Widget build(BuildContext context) {
    final yoloExtractedViewModel = Provider.of<YoloExtractedViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Text('Yolo Extracted View'),
      ),
      body: FutureBuilder(
        future: YoloTfliteService()
            .runModel(yoloExtractedViewModel.capturedImageBytes),
        builder: (context, snapshot) => Stack(fit: StackFit.expand, children: [
          if (snapshot.hasData && snapshot.data != null)
            for (var item in snapshot.data!) ...[
              FutureBuilder(
                  future: GoogleTextExtractService().extractText(item),
                  builder: (context, snapshot) =>
                      Text(snapshot.data.toString()))
            ]
          else
            const Center(child: CircularProgressIndicator()),
        ]),
      ),
    );
  }
}
