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
        body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: FutureBuilder(
                    future: GoogleTextExtractService()
                        .extractText(cameraViewModel.capturedImageFile),
                    builder: (context, snapshot) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('CNPJ: '),
                            Center(
                              child: Text(snapshot.hasData
                                  ? GoogleTextExtractService()
                                      .extractCnpj(snapshot.data!)!
                                  : 'null'),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
              const SizedBox(height: 24),
              Center(
                child: FutureBuilder(
                    future: GoogleTextExtractService()
                        .extractText(cameraViewModel.capturedImageFile),
                    builder: (context, snapshot) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text('Valor: '),
                            Center(
                              child: Text(snapshot.hasData
                                  ? GoogleTextExtractService()
                                      .extractHighestValue(snapshot.data!)!
                                  : 'null'),
                            ),
                          ],
                        ),
                      );
                    }),
              ),
            ]),
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
