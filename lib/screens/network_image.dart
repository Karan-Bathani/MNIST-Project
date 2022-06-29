import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

import '../box.dart';
import '../classifier.dart';
import '../models/pred.dart';
import '../utilities/constants.dart';

class NetworkImage extends StatefulWidget {
  const NetworkImage({Key? key}) : super(key: key);

  @override
  State<NetworkImage> createState() => _NetworkImageState();
}

class _NetworkImageState extends State<NetworkImage> {
  // final picker = ImagePicker();
  Classifier classifier = Classifier();
  XFile? image;
  int predDigit = -1;

  Pred p = Pred();

  final TextEditingController _controller = TextEditingController();

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
          final ByteData imageData =
              await NetworkAssetBundle(Uri.parse(_controller.text)).load("");
          final Uint8List bytes = imageData.buffer.asUint8List();
          predDigit = await classifier.classifyImage(bytes);
          p = Pred()
            ..link = _controller.text
            ..dateTime = DateTime.now()
            ..image = bytes
            ..number = predDigit;
          Boxes.getPredictions().add(p);
          setState(() {});
        },
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.center,
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              Column(
                children: [
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
                    decoration:
                        // predDigit == -1
                        _controller.text.isEmpty
                            ? BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.black, width: borderSize),
                              )
                            : BoxDecoration(
                                color: Colors.white,
                                border: Border.all(
                                    color: Colors.black, width: borderSize),
                                image: DecorationImage(
                                  fit: BoxFit.fill,
                                  image: Image.network(
                                    _controller.text,
                                    errorBuilder: (BuildContext context,
                                        Object exception,
                                        StackTrace? stackTrace) {
                                      return const Text('😢');
                                    },
                                  ).image,
                                  // FileImage(
                                  //   File(image!.path),
                                  // ),
                                ),
                              ),
                  ),
                ],
              ),
              const SizedBox(
                height: 25,
              ),
              const Text("Current Prediction:",
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold)),
              const SizedBox(
                height: 20,
              ),
              Text(
                predDigit == -1 ? "" : "$predDigit",
                style:
                    const TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'URL',
                    hintText: 'URL of Image',
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  _buildButton(
                      "https://conx.readthedocs.io/en/latest/_images/MNIST_44_0.png",
                      "0"),
                  _buildButton("", "1"),
                  _buildButton(
                      "https://miro.medium.com/max/1216/1*7Q9-lT0vyEYjZ6uZ6S_XNA.png",
                      "2"),
                  _buildButton(
                      "https://miro.medium.com/max/451/0*kKxxK1YXSyWMEBtS.PNG",
                      "3"),
                  _buildButton(
                      "https://user-images.githubusercontent.com/379372/31909713-d9046856-b7ef-11e7-98fe-8a1e133c0010.png",
                      "4"),
                ],
              ),
              // const SizedBox(
              //   height: 10,
              // ),
              ButtonBar(
                alignment: MainAxisAlignment.center,
                children: [
                  _buildButton(
                      "https://conx.readthedocs.io/en/latest/_images/MNIST_6_0.png",
                      "5"),
                  _buildButton("https://i.stack.imgur.com/BvH4E.png", "6"),
                  _buildButton(
                      "https://machinelearningmastery.com/wp-content/uploads/2019/02/sample_image.png",
                      "7"),
                  _buildButton("https://i.stack.imgur.com/qg0H2.png", "8"),
                  _buildButton(
                      "https://lrpserver.hhi.fraunhofer.de/api/handwriting-classification/Images/3483/Image?scaleFactor=7",
                      "9"),
                ],
              ),
              const SizedBox(
                height: 80,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton(String link, String number) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 1),
      child: MaterialButton(
        enableFeedback: true,
        color: Colors.blue.shade900,
        height: 50,
        onPressed: () {
          _controller.text = link;
        },
        child: Text(
          number,
          style: const TextStyle(
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
