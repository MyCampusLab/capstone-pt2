import 'dart:convert';

class ProfileModel {
  final String id;
  final String? fullName;
  final String? avatarUrl;
  final int xp;
  final int level;
  final int totalFocusTimeSeconds;
  final int totalViolations;
  final int streakDays;
  final String mascotState;
  final DateTime lastActiveAt;

  ProfileModel({
    required this.id,
    this.fullName,
    this.avatarUrl,
    this.xp = 0,
    this.level = 1,
    this.totalFocusTimeSeconds = 0,
    this.totalViolations = 0,
    this.streakDays = 0,
    this.mascotState = 'happy',
    required this.lastActiveAt,
  });

  factory ProfileModel.fromMap(Map<String, dynamic> map) {
    return ProfileModel(
      id: map['id'] ?? '',
      fullName: map['full_name'],
      avatarUrl: map['avatar_url'],
      xp: map['xp'] ?? 0,
      level: map['level'] ?? 1,
      totalFocusTimeSeconds: map['total_focus_time_seconds'] ?? 0,
      totalViolations: map['total_violations'] ?? 0,
      streakDays: map['streak_days'] ?? 0,
      mascotState: map['mascot_state'] ?? 'happy',
      lastActiveAt: map['last_active_at'] != null 
          ? DateTime.parse(map['last_active_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'xp': xp,
      'level': level,
      'total_focus_time_seconds': totalFocusTimeSeconds,
      'total_violations': totalViolations,
      'streak_days': streakDays,
      'mascot_state': mascotState,
      'last_active_at': lastActiveAt.toIso8601String(),
    };
  }

  String toJson() => json.encode(toMap());

  factory ProfileModel.fromJson(String source) => ProfileModel.fromMap(json.decode(source));

  ProfileModel copyWith({
    String? id,
    String? fullName,
    String? avatarUrl,
    int? xp,
    int? level,
    int? totalFocusTimeSeconds,
    int? totalViolations,
    int? streakDays,
    String? mascotState,
    DateTime? lastActiveAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      xp: xp ?? this.xp,
      level: level ?? this.level,
      totalFocusTimeSeconds: totalFocusTimeSeconds ?? this.totalFocusTimeSeconds,
      totalViolations: totalViolations ?? this.totalViolations,
      streakDays: streakDays ?? this.streakDays,
      mascotState: mascotState ?? this.mascotState,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
    );
  }
}
