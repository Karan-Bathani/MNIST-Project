import 'dart:typed_data';
import 'package:hive/hive.dart';

part 'pred.g.dart';

@HiveType(typeId: 0)
class Pred extends HiveObject {
  @HiveField(0)
  late String link;

  @HiveField(1)
  late DateTime dateTime;

  @HiveField(2)
  late Uint8List image;

  @HiveField(3)
  late int number;
}
