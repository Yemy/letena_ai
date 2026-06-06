import 'package:uuid/uuid.dart';

class UserProfile {
  final String id;
  final String name;
  final String identity;
  final String language;
  final int totalXp;
  final int currentStreak;
  final int longestStreak;
  final int level;
  final List<String> badges;
  final DateTime createdAt;
  final DateTime lastActiveAt;
  final bool isDarkMode;
  final bool notificationsEnabled;
  final int seroEvolutionStage; // 0-4

  const UserProfile({
    required this.id,
    required this.name,
    this.identity = 'Wellness Explorer',
    this.language = 'en',
    this.totalXp = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.level = 1,
    this.badges = const [],
    required this.createdAt,
    required this.lastActiveAt,
    this.isDarkMode = false,
    this.notificationsEnabled = true,
    this.seroEvolutionStage = 0,
  });

  static UserProfile get empty => UserProfile(
        id: const Uuid().v4(),
        name: 'Friend',
        createdAt: DateTime.now(),
        lastActiveAt: DateTime.now(),
      );

  static UserProfile get demo => UserProfile(
        id: 'demo-user',
        name: 'Yohannes',
        identity: 'Focused Professional',
        language: 'en',
        totalXp: 1240,
        currentStreak: 7,
        longestStreak: 14,
        level: 8,
        badges: ['streak_7', 'mood_check_30', 'meditation_first', 'community_first'],
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        lastActiveAt: DateTime.now(),
        seroEvolutionStage: 2,
      );

  int get xpForNextLevel => (level * 200);
  int get xpInCurrentLevel => totalXp % xpForNextLevel;
  double get levelProgress => xpInCurrentLevel / xpForNextLevel;

  String get levelTitle {
    if (level >= 100) return 'Serene Master';
    if (level >= 75) return 'Serenity Sage';
    if (level >= 50) return 'Wellness Champion';
    if (level >= 40) return 'Mindful Master';
    if (level >= 30) return 'Wellness Warrior';
    if (level >= 20) return 'Resilience Builder';
    if (level >= 15) return 'Habit Builder';
    if (level >= 10) return 'Balanced Human';
    if (level >= 5) return 'Mind Explorer';
    return 'Wellness Beginner';
  }

  String get leagueTitle {
    if (totalXp >= 5000) return 'Diamond';
    if (totalXp >= 2000) return 'Platinum';
    if (totalXp >= 1000) return 'Gold';
    if (totalXp >= 400) return 'Silver';
    return 'Bronze';
  }

  UserProfile copyWith({
    String? name,
    String? identity,
    String? language,
    int? totalXp,
    int? currentStreak,
    int? longestStreak,
    int? level,
    List<String>? badges,
    DateTime? lastActiveAt,
    bool? isDarkMode,
    bool? notificationsEnabled,
    int? seroEvolutionStage,
  }) {
    return UserProfile(
      id: id,
      name: name ?? this.name,
      identity: identity ?? this.identity,
      language: language ?? this.language,
      totalXp: totalXp ?? this.totalXp,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      level: level ?? this.level,
      badges: badges ?? this.badges,
      createdAt: createdAt,
      lastActiveAt: lastActiveAt ?? this.lastActiveAt,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      seroEvolutionStage: seroEvolutionStage ?? this.seroEvolutionStage,
    );
  }
}

