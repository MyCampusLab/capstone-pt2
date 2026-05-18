import 'package:hive/hive.dart';

part 'sticker_model.g.dart';

@HiveType(typeId: 2)
class StickerModel extends HiveObject {

  StickerModel({
    required this.id,
    required this.title,
    required this.description,
    this.isUnlocked = false,
    this.unlockedAt,
    double? progress = 0.0,
    double? target = 1.0,
  }) : _progress = progress, _target = target;

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

  @HiveField(5)
  final double? _progress;
  double get progress => _progress ?? 0.0;

  @HiveField(6)
  final double? _target;
  double get target => _target ?? 1.0;

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isUnlocked': isUnlocked,
      'unlockedAt': unlockedAt?.toIso8601String(),
      'progress': progress,
      'target': target,
    };
  }
}
