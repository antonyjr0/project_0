// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'GameModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GameModelAdapter extends TypeAdapter<GameModel> {
  @override
  final int typeId = 0;

  @override
  GameModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GameModel()
      .._id = fields[0] as int
      .._name = fields[1] as String
      .._released = fields[2] as String
      .._announced = fields[3] as bool
      .._backgroundImage = fields[4] as String
      .._rating = fields[5] as double
      .._ratings = (fields[6] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList()
      .._ratingsCount = fields[7] as int
      .._added = fields[8] as int
      .._addedByStatus = (fields[9] as Map).cast<String, int>()
      .._metacritic = fields[10] as int
      .._playtime = fields[11] as int
      .._suggestionsCount = fields[12] as int
      .._updated = fields[13] as String
      .._reviewsCount = fields[14] as int
      .._platforms = (fields[15] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList()
      .._parentPlatforms = (fields[16] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList()
      .._genres = (fields[17] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList()
      .._stores = (fields[18] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList()
      .._tags = (fields[19] as List)
          .map((dynamic e) => (e as Map).cast<String, dynamic>())
          .toList()
      .._saved = fields[20] as bool;
  }

  @override
  void write(BinaryWriter writer, GameModel obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj._id)
      ..writeByte(1)
      ..write(obj._name)
      ..writeByte(2)
      ..write(obj._released)
      ..writeByte(3)
      ..write(obj._announced)
      ..writeByte(4)
      ..write(obj._backgroundImage)
      ..writeByte(5)
      ..write(obj._rating)
      ..writeByte(6)
      ..write(obj._ratings)
      ..writeByte(7)
      ..write(obj._ratingsCount)
      ..writeByte(8)
      ..write(obj._added)
      ..writeByte(9)
      ..write(obj._addedByStatus)
      ..writeByte(10)
      ..write(obj._metacritic)
      ..writeByte(11)
      ..write(obj._playtime)
      ..writeByte(12)
      ..write(obj._suggestionsCount)
      ..writeByte(13)
      ..write(obj._updated)
      ..writeByte(14)
      ..write(obj._reviewsCount)
      ..writeByte(15)
      ..write(obj._platforms)
      ..writeByte(16)
      ..write(obj._parentPlatforms)
      ..writeByte(17)
      ..write(obj._genres)
      ..writeByte(18)
      ..write(obj._stores)
      ..writeByte(19)
      ..write(obj._tags)
      ..writeByte(20)
      ..write(obj._saved);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GameModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
