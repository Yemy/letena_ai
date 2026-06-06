import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_profile_model.dart';

class UserProfileNotifier extends StateNotifier<UserProfile> {
  UserProfileNotifier() : super(UserProfile.demo);

  void updateName(String name) {
    state = state.copyWith(name: name);
  }

  void setIdentity(String identity) {
    state = state.copyWith(identity: identity);
  }

  void setLanguage(String language) {
    state = state.copyWith(language: language);
  }

  void toggleDarkMode() {
    state = state.copyWith(isDarkMode: !state.isDarkMode);
  }

  void addXp(int amount) {
    final newXp = state.totalXp + amount;
    final newLevel = _calculateLevel(newXp);
    final newStage = _calculateSeroStage(newLevel);
    state = state.copyWith(
      totalXp: newXp,
      level: newLevel,
      seroEvolutionStage: newStage,
      lastActiveAt: DateTime.now(),
    );
  }

  void updateStreak(int streak) {
    final longest = streak > state.longestStreak ? streak : state.longestStreak;
    state = state.copyWith(currentStreak: streak, longestStreak: longest);
  }

  void unlockBadge(String badgeId) {
    if (!state.badges.contains(badgeId)) {
      final newBadges = [...state.badges, badgeId];
      state = state.copyWith(badges: newBadges);
    }
  }

  int _calculateLevel(int xp) {
    int level = 1;
    int required = 200;
    int accumulated = 0;
    while (accumulated + required <= xp && level < 100) {
      accumulated += required;
      level++;
      required = level * 200;
    }
    return level;
  }

  int _calculateSeroStage(int level) {
    if (level >= 50) return 4;
    if (level >= 30) return 3;
    if (level >= 15) return 2;
    if (level >= 5) return 1;
    return 0;
  }
}

final userProfileProvider = StateNotifierProvider<UserProfileNotifier, UserProfile>((ref) {
  return UserProfileNotifier();
});

