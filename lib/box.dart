import 'package:hive/hive.dart';
import 'package:mnist_visionbox/models/pred.dart';

class Boxes {
  static Box<Pred> getPredictions() => Hive.box<Pred>('predictions');
}
