import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

enum QuestType { mind, body, nutrition, sleep, digital }
enum QuestStatus { notStarted, inProgress, completed }

extension QuestTypeX on QuestType {
  String get label {
    switch (this) {
      case QuestType.mind: return 'Mind Quest';
      case QuestType.body: return 'Body Quest';
      case QuestType.nutrition: return 'Nutrition Quest';
      case QuestType.sleep: return 'Sleep Quest';
      case QuestType.digital: return 'Digital Quest';
    }
  }

  IconData get icon {
    switch (this) {
      case QuestType.mind: return Icons.psychology_rounded;
      case QuestType.body: return Icons.directions_run_rounded;
      case QuestType.nutrition: return Icons.local_drink_rounded;
      case QuestType.sleep: return Icons.bedtime_rounded;
      case QuestType.digital: return Icons.phone_android_rounded;
    }
  }

  LinearGradient get gradient {
    switch (this) {
      case QuestType.mind: return AppColors.mindGradient;
      case QuestType.body: return AppColors.bodyGradient;
      case QuestType.nutrition: return AppColors.nutritionGradient;
      case QuestType.sleep: return AppColors.sleepGradient;
      case QuestType.digital: return AppColors.digitalGradient;
    }
  }
}

class Quest {
  final String id;
  final String title;
  final String description;
  final QuestType type;
  final int xpReward;
  final int targetCount;
  int currentCount;
  QuestStatus status;

  Quest({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    required this.xpReward,
    this.targetCount = 1,
    this.currentCount = 0,
    this.status = QuestStatus.notStarted,
  });

  double get progress => (currentCount / targetCount).clamp(0.0, 1.0);
  bool get isCompleted => status == QuestStatus.completed;
}

class DailyQuests {
  final List<Quest> quests;
  final DateTime date;

  const DailyQuests({required this.quests, required this.date});

  int get completedCount => quests.where((q) => q.isCompleted).length;
  int get totalXpEarned => quests.where((q) => q.isCompleted).fold(0, (sum, q) => sum + q.xpReward);

  static DailyQuests generate(DateTime date) {
    return DailyQuests(
      date: date,
      quests: [
        Quest(
          id: 'mind_1',
          title: '5-Minute Breathing',
          description: 'Complete a breathing exercise to calm your mind.',
          type: QuestType.mind,
          xpReward: 30,
        ),
        Quest(
          id: 'body_1',
          title: '20-Minute Walk',
          description: 'Take a mindful walk outside today.',
          type: QuestType.body,
          xpReward: 40,
        ),
        Quest(
          id: 'nutrition_1',
          title: 'Drink 8 Glasses',
          description: 'Stay hydrated throughout the day.',
          type: QuestType.nutrition,
          xpReward: 25,
          targetCount: 8,
        ),
        Quest(
          id: 'sleep_1',
          title: 'Sleep by 10 PM',
          description: 'Set a consistent bedtime for better sleep quality.',
          type: QuestType.sleep,
          xpReward: 35,
        ),
        Quest(
          id: 'digital_1',
          title: 'No Phone After 9 PM',
          description: 'Give your mind a screen-free hour before bed.',
          type: QuestType.digital,
          xpReward: 30,
        ),
      ],
    );
  }
}

