import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Primary palette — deep teal
  static const Color primary = Color(0xFF1A6B6B);
  static const Color primaryLight = Color(0xFF2A9B9B);
  static const Color primaryDark = Color(0xFF0D4A4A);

  // Secondary — warm amber
  static const Color secondary = Color(0xFFF4A847);
  static const Color secondaryLight = Color(0xFFFFC57A);
  static const Color secondaryDark = Color(0xFFD4881A);

  // Accent — soft mint
  static const Color accent = Color(0xFFB2E8D8);
  static const Color accentDeep = Color(0xFF4ECBA8);

  // Backgrounds
  static const Color bgLight = Color(0xFFF6FBF9);
  static const Color bgDark = Color(0xFF0F1923);
  static const Color surfaceLight = Color(0xFFFFFFFF);
  static const Color surfaceDark = Color(0xFF1A2632);
  static const Color cardDark = Color(0xFF1E2F3E);
  static const Color cardLight = Color(0xFFFFFFFF);

  // Wellness Pillar Colors
  static const Color mind = Color(0xFF9B59B6);      // Purple
  static const Color body = Color(0xFF27AE60);      // Green
  static const Color nutrition = Color(0xFFF39C12); // Orange
  static const Color sleep = Color(0xFF2980B9);     // Blue
  static const Color digital = Color(0xFFE74C3C);   // Red

  // Mood Colors
  static const Color moodHappy = Color(0xFFFAD02C);
  static const Color moodGood = Color(0xFF4ECBA8);
  static const Color moodNeutral = Color(0xFF95A5A6);
  static const Color moodStressed = Color(0xFFE67E22);
  static const Color moodExhausted = Color(0xFFE74C3C);

  // Gamification
  static const Color xpGold = Color(0xFFFFD700);
  static const Color streak = Color(0xFFFF6B35);
  static const Color bronze = Color(0xFFCD7F32);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color gold = Color(0xFFFFD700);
  static const Color platinum = Color(0xFF4ECBA8);
  static const Color diamond = Color(0xFF7EC8E3);

  // Status
  static const Color success = Color(0xFF27AE60);
  static const Color warning = Color(0xFFF39C12);
  static const Color error = Color(0xFFE74C3C);
  static const Color info = Color(0xFF2980B9);

  // Burnout risk
  static const Color riskLow = Color(0xFF27AE60);
  static const Color riskMedium = Color(0xFFF39C12);
  static const Color riskHigh = Color(0xFFE74C3C);

  // Text
  static const Color textPrimary = Color(0xFF1C2B3A);
  static const Color textSecondary = Color(0xFF5A7184);
  static const Color textMuted = Color(0xFF9BADB8);
  static const Color textOnDark = Color(0xFFE8F4F2);
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1A6B6B), Color(0xFF2A9B9B)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0D4A4A), Color(0xFF1A6B6B), Color(0xFF2A9B9B)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient amberGradient = LinearGradient(
    colors: [Color(0xFFD4881A), Color(0xFFF4A847)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient mindGradient = LinearGradient(
    colors: [Color(0xFF6C3483), Color(0xFF9B59B6)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient bodyGradient = LinearGradient(
    colors: [Color(0xFF1E8449), Color(0xFF27AE60)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient nutritionGradient = LinearGradient(
    colors: [Color(0xFFCA6F1E), Color(0xFFF39C12)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient sleepGradient = LinearGradient(
    colors: [Color(0xFF1A5276), Color(0xFF2980B9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient digitalGradient = LinearGradient(
    colors: [Color(0xFFC0392B), Color(0xFFE74C3C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}

