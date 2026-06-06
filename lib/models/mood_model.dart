import 'package:flutter/material.dart';

enum MoodType { happy, good, neutral, stressed, exhausted }

extension MoodTypeX on MoodType {
  String get emoji {
    switch (this) {
      case MoodType.happy: return '😊';
      case MoodType.good: return '🙂';
      case MoodType.neutral: return '😐';
      case MoodType.stressed: return '😔';
      case MoodType.exhausted: return '😫';
    }
  }

  String get label {
    switch (this) {
      case MoodType.happy: return 'Happy';
      case MoodType.good: return 'Good';
      case MoodType.neutral: return 'Neutral';
      case MoodType.stressed: return 'Stressed';
      case MoodType.exhausted: return 'Exhausted';
    }
  }

  Color get color {
    switch (this) {
      case MoodType.happy: return const Color(0xFFFAD02C);
      case MoodType.good: return const Color(0xFF4ECBA8);
      case MoodType.neutral: return const Color(0xFF95A5A6);
      case MoodType.stressed: return const Color(0xFFE67E22);
      case MoodType.exhausted: return const Color(0xFFE74C3C);
    }
  }

  int get score {
    switch (this) {
      case MoodType.happy: return 100;
      case MoodType.good: return 80;
      case MoodType.neutral: return 60;
      case MoodType.stressed: return 35;
      case MoodType.exhausted: return 15;
    }
  }
}

class MoodEntry {
  final String id;
  final DateTime timestamp;
  final MoodType mood;
  final int sleepHours;
  final int waterGlasses;
  final bool exercised;
  final int screenTimeHours;
  final int stressLevel; // 1-10
  final int energyLevel; // 1-10
  final bool socialInteraction;
  final String? note;

  const MoodEntry({
    required this.id,
    required this.timestamp,
    required this.mood,
    this.sleepHours = 7,
    this.waterGlasses = 4,
    this.exercised = false,
    this.screenTimeHours = 4,
    this.stressLevel = 5,
    this.energyLevel = 5,
    this.socialInteraction = false,
    this.note,
  });

  double get wellnessScore {
    double score = mood.score.toDouble();
    score += (sleepHours.clamp(0, 8) / 8) * 20;
    score += (waterGlasses.clamp(0, 8) / 8) * 10;
    if (exercised) score += 15;
    score -= (screenTimeHours.clamp(0, 12) / 12) * 10;
    score += ((10 - stressLevel) / 10) * 15;
    score += (energyLevel / 10) * 10;
    if (socialInteraction) score += 5;
    return (score / 175 * 100).clamp(0, 100);
  }

  double get burnoutRisk {
    double risk = 0;
    if (mood == MoodType.stressed) risk += 30;
    if (mood == MoodType.exhausted) risk += 50;
    if (stressLevel >= 7) risk += 20;
    if (energyLevel <= 3) risk += 20;
    if (sleepHours < 6) risk += 15;
    if (screenTimeHours > 8) risk += 10;
    if (!socialInteraction) risk += 5;
    return risk.clamp(0, 100);
  }

  MoodEntry copyWith({
    String? id,
    DateTime? timestamp,
    MoodType? mood,
    int? sleepHours,
    int? waterGlasses,
    bool? exercised,
    int? screenTimeHours,
    int? stressLevel,
    int? energyLevel,
    bool? socialInteraction,
    String? note,
  }) {
    return MoodEntry(
      id: id ?? this.id,
      timestamp: timestamp ?? this.timestamp,
      mood: mood ?? this.mood,
      sleepHours: sleepHours ?? this.sleepHours,
      waterGlasses: waterGlasses ?? this.waterGlasses,
      exercised: exercised ?? this.exercised,
      screenTimeHours: screenTimeHours ?? this.screenTimeHours,
      stressLevel: stressLevel ?? this.stressLevel,
      energyLevel: energyLevel ?? this.energyLevel,
      socialInteraction: socialInteraction ?? this.socialInteraction,
      note: note ?? this.note,
    );
  }
}

