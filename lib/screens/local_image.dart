import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mnist_visionbox/box.dart';
import 'package:mnist_visionbox/models/pred.dart';

import '../classifier.dart';
import '../utilities/constants.dart';

class LocalImage extends StatefulWidget {
  const LocalImage({Key? key}) : super(key: key);

  @override
  State<LocalImage> createState() => _LocalImageState();
}

class _LocalImageState extends State<LocalImage> {
  final picker = ImagePicker();
  Classifier classifier = Classifier();
  XFile? image;
  int predDigit = -1;
  Pred p = Pred();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text("MNIST Project"),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.black,
        child: const Icon(Icons.camera_alt_outlined),
        onPressed: () async {
          image = await picker.pickImage(
            source: ImageSource.gallery,
            maxHeight: 300,
            maxWidth: 300,
            // imageQuality: 100,
          );
          predDigit = await classifier
              .classifyImage(File(image!.path).readAsBytesSync());
          p = Pred()
            ..link = image!.path
            ..dateTime = DateTime.now()
            ..image = File(image!.path).readAsBytesSync()
            ..number = predDigit;
          Boxes.getPredictions().add(p);
          setState(() {});
        },
      ),
      body: Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            const SizedBox(
              height: 40,
            ),
            const Text(
              "Image will be shown below",
              style: TextStyle(fontSize: 20),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: canvasSize + borderSize * 2,
              height: canvasSize + borderSize * 2,
              decoration: predDigit == -1
                  ?
                  // image == null?
                  BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(color: Colors.black, width: borderSize),
                    )
                  : BoxDecoration(
                      color: Colors.white,
                      border:
                          Border.all(color: Colors.black, width: borderSize),
                      image: DecorationImage(
                        fit: BoxFit.fill,
                        image: FileImage(
                          File(image!.path),
                        ),
                      ),
                    ),
            ),
            const SizedBox(
              height: 45,
            ),
            const Text("Current Prediction:",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
            const SizedBox(
              height: 20,
            ),
            Text(predDigit == -1 ? "" : "$predDigit",
                style:
                    const TextStyle(fontSize: 50, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
