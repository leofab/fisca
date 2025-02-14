import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:app/screens/yolo_extracted/yolo_extracted_view_model.dart';
import 'package:app/service/yolo_tflite_service.dart';

class YoloExtractedView extends StatelessWidget {
  const YoloExtractedView({super.key});
  @override
  Widget build(BuildContext context) {
    final yoloExtractedViewModel = Provider.of<YoloExtractedViewModel>(context);
    final Size size = MediaQuery.sizeOf(context);
    /*
    final Image image = Image.file(yoloExtractedViewModel.capturedImageFile);
    final factorX = size.width / image.width!;
    final imgRatio = image.width! / image.height!;
    final newWidth = image.width! * (size.width / image.width!);
    final newHeight = (image.width! * (size.width / image.width!)) / (image.width! / image.height!);
    final factorY = ((image.width! * (size.width / image.width!)) / (image.width! / image.height!)) / image.height!;
    final pady = (size.height - ((image.width! * (size.width / image.width!)) / (image.width! / image.height!))) / 2;
    */
    final colorPick = const Color.fromARGB(255, 50, 233, 30);
    return Scaffold(
      appBar: AppBar(
        title: Text('Yolo Extracted View'),
      ),
      body: FutureBuilder(
        future: YoloTfliteService()
            .runModel(yoloExtractedViewModel.capturedImageBytes),
        builder: (context, snapshot) => Stack(fit: StackFit.expand, children: [
          Image.file(yoloExtractedViewModel.capturedImageFile),
          if (snapshot.hasData && snapshot.data != null)
            for (var item in snapshot.data!) ...[
              Positioned(
                left: item["box"][0] * (size.width / item["imgWidth"]),
                top: item["box"][1] *
                        (((item["imgWidth"] * (size.width / item["imgWidth"])) /
                                (item["imgWidth"] / item["imgHeight"])) /
                            item["imgHeight"]) +
                    ((size.height -
                            ((item["imgWidth"] *
                                    (size.width / item["imgWidth"])) /
                                (item["imgWidth"] / item["imgHeight"]))) /
                        2.75), // last double on the top needs to be a number that would fit any screen
                width: (item["box"][2] - item["box"][0]) *
                    (size.width / item["imgWidth"]),
                height: (item["box"][3] - item["box"][1]) *
                    (((item["imgWidth"] * (size.width / item["imgWidth"])) /
                            (item["imgWidth"] / item["imgHeight"])) /
                        item["imgHeight"]),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(10.0)),
                    border: Border.all(color: Colors.pink, width: 2.0),
                  ),
                  child: Text(
                    "${item["tag"]} ${(item["box"][4] * 100).toStringAsFixed(0)}%",
                    style: TextStyle(
                      background: Paint()..color = colorPick,
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ]
        ]),
      ),
    );
  }
}
