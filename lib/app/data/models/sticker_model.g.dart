// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sticker_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StickerModelAdapter extends TypeAdapter<StickerModel> {
  @override
  final int typeId = 2;

  @override
  StickerModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return StickerModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      isUnlocked: fields[3] as bool,
      unlockedAt: fields[4] as DateTime?,
      buffDescription: fields[5] == null ? '' : fields[5] as String,
      isEquipped: fields[6] == null ? false : fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, StickerModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.isUnlocked)
      ..writeByte(4)
      ..write(obj.unlockedAt)
      ..writeByte(5)
      ..write(obj.buffDescription)
      ..writeByte(6)
      ..write(obj.isEquipped);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StickerModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
