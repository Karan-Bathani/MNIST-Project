// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pred.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PredAdapter extends TypeAdapter<Pred> {
  @override
  final int typeId = 0;

  @override
  Pred read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Pred()
      ..link = fields[0] as String
      ..dateTime = fields[1] as DateTime
      ..image = fields[2] as Uint8List
      ..number = fields[3] as int;
  }

  @override
  void write(BinaryWriter writer, Pred obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.link)
      ..writeByte(1)
      ..write(obj.dateTime)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.number);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PredAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
