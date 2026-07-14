import 'package:hive/hive.dart';

part 'sticker_model.g.dart';

@HiveType(typeId: 2)
class StickerModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String description;

  @HiveField(3)
  final bool isUnlocked;

  @HiveField(4)
  final DateTime? unlockedAt;

  @HiveField(5, defaultValue: '')
  final String buffDescription;

  @HiveField(6, defaultValue: false)
  final bool isEquipped;

  StickerModel({
    required this.id,
    required this.title,
    required this.description,
    this.isUnlocked = false,
    this.unlockedAt,
    this.buffDescription = '',
    this.isEquipped = false,
  });

  StickerModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isUnlocked,
    DateTime? unlockedAt,
    String? buffDescription,
    bool? isEquipped,
  }) {
    return StickerModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      unlockedAt: unlockedAt ?? this.unlockedAt,
      buffDescription: buffDescription ?? this.buffDescription,
      isEquipped: isEquipped ?? this.isEquipped,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'buffDescription': buffDescription,
      'isEquipped': isEquipped,
    };
  }
}
