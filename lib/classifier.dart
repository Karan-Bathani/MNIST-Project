import 'dart:typed_data';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;

import 'utilities/constants.dart';

class Classifier {
  Classifier();

  classifyImage(Uint8List image) async {
    // var _file = io.File(image.path);
    // _file.readAsBytesSync()
    img.Image? imageTemp = img.decodeImage(image);
    img.Image resizedImg =
        img.copyResize(imageTemp!, height: mnistSize, width: mnistSize);
    var imgBytes = resizedImg.getBytes();
    var imgAsList = imgBytes.buffer.asUint8List();

    return getPred(imgAsList);
  }

  Future<int> getPred(Uint8List imgAsList) async {
    final resultBytes = List.generate(
        mnistSize * mnistSize, (i) => i.toDouble(),
        growable: false);

    int index = 0;
    for (int i = 0; i < imgAsList.lengthInBytes; i += 4) {
      final r = imgAsList[i];
      final g = imgAsList[i + 1];
      final b = imgAsList[i + 2];

      resultBytes[index] = ((r + g + b) / 3.0) / 255.0;
      index++;
    }

    var input = resultBytes.reshape([1, 28, 28, 1]);
    var output = List.generate(10, (i) => i.toDouble(), growable: false)
        .reshape([1, 10]);

    InterpreterOptions interpreterOptions = InterpreterOptions();

    int startTime = DateTime.now().millisecondsSinceEpoch;

    try {
      Interpreter interpreter = await Interpreter.fromAsset("model.tflite",
          options: interpreterOptions);
      interpreter.run(input, output);
    } catch (e) {
      print('Error loading or running model: $e');
    }

    int endTime = DateTime.now().millisecondsSinceEpoch;
    print("Inference took ${endTime - startTime} ms");

    double highestProb = 0;
    int digitPred = 9;

    for (int i = 0; i < output[0].length; i++) {
      if (output[0][i] > highestProb) {
        highestProb = output[0][i];
        digitPred = i;
      }
    }
    return digitPred;
  }
}
