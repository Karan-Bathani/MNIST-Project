import 'package:flutter/material.dart';
import 'package:mnist_visionbox/box.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mnist_visionbox/utilities/constants.dart';

import '../models/pred.dart';
import 'full_screen_image_widget.dart';

class RetriveScreen extends StatefulWidget {
  const RetriveScreen({Key? key}) : super(key: key);

  @override
  State<RetriveScreen> createState() => _RetriveScreenState();
}

class _RetriveScreenState extends State<RetriveScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,
      body: ValueListenableBuilder<Box<Pred>>(
          valueListenable: Boxes.getPredictions().listenable(),
          builder: (context, box, _) {
            final preds = box.values.toList().cast<Pred>();
            if (preds.isEmpty) {
              return Scaffold(
                appBar: AppBar(
                  title: const Text("MNIST Project"),
                ),
                body: const Center(
                  child: Text(
                    "No Entry yet!",
                    style: TextStyle(fontSize: 24),
                  ),
                ),
              );
            } else {
              return Scaffold(
                  appBar: AppBar(
                    title: const Text("MNIST Project"),
                    actions: [
                      Align(
                        alignment: Alignment.center,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(children: [
                            const TextSpan(
                              text: "TOTAL:      ",
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(
                              text: "\n${preds.length}",
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ]),
                        ),
                      ),
                    ],
                  ),
                  body: _buildGrid(preds));
            }
          }),
    );
  }

  Widget _buildGrid(List<Pred> predictions) {
    return GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: predictions.length,
        itemBuilder: (context, index) {
          return _buildItem(context, predictions[index], index, predictions);
        });
  }

  Widget _buildItem(
      BuildContext context, Pred pred, int index, List<Pred> preds) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MyFullScreenImageWidget(index, preds),
            ));
      },
      child: GridTile(
        header: Align(
          alignment: Alignment.topRight,
          child: IconButton(
            onPressed: () {
              pred.delete();
            },
            icon: Icon(
              Icons.delete,
              color: Colors.redAccent.shade700,
            ),
          ),
        ),
        footer: Container(
          decoration: BoxDecoration(
            color: pred.link.contains("http")
                ? Colors.amber.withAlpha(140)
                : Colors.black45,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Time: ${pred.dateTime.formatDate()}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "#${pred.number}",
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                ),
              ),
            ],
          ),
        ),
        child: Image.memory(pred.image, fit: BoxFit.contain),
      ),
    );
    // return Container(
    //   // decoration: BoxDecoration(
    //   //     image: DecorationImage(image: Image.memory(pred.image).image)),
    //   height: 100,
    //   child: Column(
    //     children: [
    //       GridTile(
    //         child: Image.memory(pred.image, fit: BoxFit.contain),
    //       ),
    //       Text("Prediction: #${pred.number}"),
    //       Text("Time: ${pred.dateTime.formatDate(pattern: "hh : MM")}"),
    //     ],
    //   ),
    // );
  }
}
