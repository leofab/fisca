import 'package:app/service/google_text_extract_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/screens/yolo_extracted/yolo_extracted_view_model.dart';
import 'package:app/service/yolo_tflite_service.dart';
import 'package:app/service/http_service.dart' as http;

class YoloExtractedView extends StatefulWidget {
  const YoloExtractedView({super.key});

  @override
  State<YoloExtractedView> createState() => _YoloExtractedViewState();
}

class _YoloExtractedViewState extends State<YoloExtractedView> {
  final _formKey = GlobalKey<FormState>();
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
        builder: (context, snapshot) => Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (snapshot.hasData && snapshot.data != null) ...<Widget>[
                Image.file(snapshot.data![0]),
                SizedBox(height: 24),
                FutureBuilder(
                  future: GoogleTextExtractService()
                      .extractText((snapshot.data![0])),
                  builder: (context, snapshot) => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (snapshot.hasData && snapshot.data != null)
                        FutureBuilder(
                            future: http.HttpService().cnpjGetName(
                                GoogleTextExtractService()
                                    .extractCnpj(snapshot.data!)!),
                            builder: (context, snapshot) => Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    if (snapshot.hasData &&
                                        snapshot.data != null)
                                      TextFormField(
                                        decoration: const InputDecoration(
                                          border: OutlineInputBorder(),
                                          labelText: 'Name',
                                        ),
                                        initialValue: snapshot.data,
                                      )
                                    else
                                      const Center(
                                          child: CircularProgressIndicator()),
                                  ],
                                ))
                      else
                        const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                Image.file(snapshot.data![1]),
                SizedBox(height: 24),
                FutureBuilder(
                  future:
                      GoogleTextExtractService().extractText(snapshot.data![1]),
                  builder: (context, snapshot) => Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      if (snapshot.hasData && snapshot.data != null)
                        TextFormField(
                          decoration: const InputDecoration(
                            border: OutlineInputBorder(),
                            labelText: 'Value',
                          ),
                          initialValue: GoogleTextExtractService()
                              .extractHighestValue(snapshot.data!),
                        )
                      else
                        const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
              ] else
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
