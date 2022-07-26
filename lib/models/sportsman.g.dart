// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sportsman.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SportsmanAdapter extends TypeAdapter<Sportsman> {
  @override
  final int typeId = 0;

  @override
  Sportsman read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sportsman(
      id: fields[0] as int,
      email: fields[1] as String,
      password: fields[2] as String,
      phone: fields[3] as String,
      firstName: fields[4] as String,
      gender: fields[5] as bool,
      iconNum: fields[6] as int,
      dateOfBirth: fields[7] as DateTime,
      subscriptions: (fields[8] as List).cast<Subscription>(),
    );
  }

  @override
  void write(BinaryWriter writer, Sportsman obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.email)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.phone)
      ..writeByte(4)
      ..write(obj.firstName)
      ..writeByte(5)
      ..write(obj.gender)
      ..writeByte(6)
      ..write(obj.iconNum)
      ..writeByte(7)
      ..write(obj.dateOfBirth)
      ..writeByte(8)
      ..write(obj.subscriptions);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SportsmanAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
