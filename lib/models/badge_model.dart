import 'package:flutter/material.dart';

class Badge {
  final String id;
  final String title;
  final String description;
  final String emoji;
  final int xpReward;
  final bool isUnlocked;
  final DateTime? unlockedAt;
  final BadgeRarity rarity;

  const Badge({
    required this.id,
    required this.title,
    required this.description,
    required this.emoji,
    required this.xpReward,
    this.isUnlocked = false,
    this.unlockedAt,
    this.rarity = BadgeRarity.common,
  });
}

enum BadgeRarity { common, rare, epic, legendary }

extension BadgeRarityX on BadgeRarity {
  Color get color {
    switch (this) {
      case BadgeRarity.common: return const Color(0xFF95A5A6);
      case BadgeRarity.rare: return const Color(0xFF2980B9);
      case BadgeRarity.epic: return const Color(0xFF9B59B6);
      case BadgeRarity.legendary: return const Color(0xFFFFD700);
    }
  }

  String get label {
    switch (this) {
      case BadgeRarity.common: return 'Common';
      case BadgeRarity.rare: return 'Rare';
      case BadgeRarity.epic: return 'Epic';
      case BadgeRarity.legendary: return 'Legendary';
    }
  }
}

class AllBadges {
  static const List<Badge> badges = [
    Badge(id: 'first_mood', title: 'First Check-In', description: 'Completed your first mood check-in.', emoji: '🌟', xpReward: 50, rarity: BadgeRarity.common),
    Badge(id: 'streak_3', title: '3-Day Warrior', description: 'Maintained a 3-day streak.', emoji: '🔥', xpReward: 75, rarity: BadgeRarity.common),
    Badge(id: 'streak_7', title: 'Week Champion', description: 'A full week of consistency!', emoji: '💪', xpReward: 150, rarity: BadgeRarity.rare),
    Badge(id: 'streak_30', title: 'Consistency King', description: '30 days of unbreakable habits.', emoji: '👑', xpReward: 500, rarity: BadgeRarity.legendary),
    Badge(id: 'meditation_first', title: 'Inner Peace Seeker', description: 'Completed your first meditation.', emoji: '🧘', xpReward: 60, rarity: BadgeRarity.common),
    Badge(id: 'meditation_10', title: 'Mindfulness Explorer', description: 'Meditated 10 times.', emoji: '🌸', xpReward: 200, rarity: BadgeRarity.rare),
    Badge(id: 'mood_check_30', title: 'Awareness Master', description: 'Checked your mood 30 days in a row.', emoji: '🎯', xpReward: 300, rarity: BadgeRarity.epic),
    Badge(id: 'water_week', title: 'Hydration Hero', description: 'Met your water goal 7 days straight.', emoji: '💧', xpReward: 150, rarity: BadgeRarity.rare),
    Badge(id: 'sleep_hero', title: 'Sleep Hero', description: 'Got 8+ hours of sleep for 7 days.', emoji: '😴', xpReward: 200, rarity: BadgeRarity.rare),
    Badge(id: 'stress_slayer', title: 'Stress Slayer', description: 'Reduced your stress score by 50%.', emoji: '⚡', xpReward: 250, rarity: BadgeRarity.epic),
    Badge(id: 'gratitude_master', title: 'Gratitude Master', description: 'Wrote 21 gratitude journal entries.', emoji: '🙏', xpReward: 300, rarity: BadgeRarity.epic),
    Badge(id: 'community_first', title: 'Community Builder', description: 'Made your first community post.', emoji: '🌍', xpReward: 80, rarity: BadgeRarity.common),
    Badge(id: 'detox_champion', title: 'Digital Detox Champion', description: 'Completed a 7-day digital detox.', emoji: '📵', xpReward: 350, rarity: BadgeRarity.epic),
    Badge(id: 'exercise_7', title: 'Body Builder', description: 'Exercised 7 days in a row.', emoji: '🏃', xpReward: 200, rarity: BadgeRarity.rare),
    Badge(id: 'low_burnout', title: 'Burnout Buster', description: 'Kept your burnout risk below 20% for a week.', emoji: '🛡️', xpReward: 400, rarity: BadgeRarity.legendary),
  ];
}

