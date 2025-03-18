import 'package:app/service/google_text_extract_service.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:app/screens/yolo_extracted/yolo_extracted_view_model.dart';
import 'package:app/service/yolo_tflite_service.dart';
import 'package:app/service/http_service.dart' as http;
import 'package:app/service/db_service.dart' as db;
import 'package:app/screens/charts/line_chart_view_model.dart'
    as line_chart_viewmodel;

class YoloExtractedView extends StatefulWidget {
  const YoloExtractedView({super.key});

  @override
  State<YoloExtractedView> createState() => _YoloExtractedViewState();
}

class _YoloExtractedViewState extends State<YoloExtractedView> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> expanseDb = {};

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
                                        validator: (value) => value!.isEmpty
                                            ? "Campo obrigatório"
                                            : null,
                                        onSaved: (newValue) =>
                                            expanseDb['title'] = newValue,
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
                          validator: (value) =>
                              value!.isEmpty ? "Campo obrigatório" : null,
                          onSaved: (newValue) => expanseDb['amount'] = newValue,
                        )
                      else
                        const Center(child: CircularProgressIndicator()),
                    ],
                  ),
                ),
                SizedBox(height: 24),
                TextFormField(
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Data',
                  ),
                  initialValue: DateTime.now().toString(),
                  validator: (value) =>
                      value!.isEmpty ? "Campo obrigatório" : null,
                  onSaved: (newValue) => expanseDb['date'] = newValue,
                ),
              ] else
                const Center(child: CircularProgressIndicator()),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            try {
              _formKey.currentState!.save();
              _formKey.currentState!.reset();
              await db.DBService().insertExpense(expanseDb);
              await line_chart_viewmodel.LineChartViewModel().getFlSpots();
              expanseDb = {};
              yoloExtractedViewModel.clearState();
            } catch (e) {
              Logger().e(e);
            } finally {
              if (context.mounted) {
                showDialog(
                    context: context,
                    builder: (context) {
                      return const AlertDialog(
                        title: Text("Gasto salvo com sucesso!"),
                      );
                    });
                Navigator.popAndPushNamed(context, '/home');
              }
            }
          }
        },
        child: Icon(Icons.save),
      ),
    );
  }
}
