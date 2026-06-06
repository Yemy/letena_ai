import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/mood_model.dart';
import 'package:uuid/uuid.dart';

class MoodNotifier extends StateNotifier<List<MoodEntry>> {
  MoodNotifier() : super(_mockHistory);

  static final _mockHistory = List.generate(14, (i) {
    final moods = [
      MoodType.good, MoodType.happy, MoodType.neutral,
      MoodType.stressed, MoodType.good, MoodType.happy, MoodType.good,
      MoodType.exhausted, MoodType.stressed, MoodType.neutral,
      MoodType.good, MoodType.happy, MoodType.good, MoodType.happy,
    ];
    return MoodEntry(
      id: 'mock_$i',
      timestamp: DateTime.now().subtract(Duration(days: 13 - i)),
      mood: moods[i],
      sleepHours: 6 + (i % 3),
      waterGlasses: 4 + (i % 5),
      exercised: i % 3 == 0,
      screenTimeHours: 3 + (i % 4),
      stressLevel: 3 + (i % 5),
      energyLevel: 5 + (i % 4),
      socialInteraction: i % 2 == 0,
    );
  });

  MoodEntry? get todaysMood {
    final today = DateTime.now();
    try {
      return state.lastWhere(
        (e) => e.timestamp.day == today.day && e.timestamp.month == today.month,
      );
    } catch (_) {
      return null;
    }
  }

  double get averageWellnessScore {
    if (state.isEmpty) return 0;
    final last7 = state.length > 7 ? state.sublist(state.length - 7) : state;
    return last7.fold(0.0, (sum, e) => sum + e.wellnessScore) / last7.length;
  }

  double get currentBurnoutRisk {
    if (state.isEmpty) return 0;
    final recent = state.last;
    return recent.burnoutRisk;
  }

  String get burnoutRiskLabel {
    final risk = currentBurnoutRisk;
    if (risk < 30) return 'Low';
    if (risk < 60) return 'Medium';
    return 'High';
  }

  void logMood(MoodEntry entry) {
    state = [...state, entry];
  }

  MoodEntry buildEntry({
    required MoodType mood,
    int sleepHours = 7,
    int waterGlasses = 4,
    bool exercised = false,
    int screenTimeHours = 4,
    int stressLevel = 5,
    int energyLevel = 5,
    bool socialInteraction = false,
    String? note,
  }) {
    return MoodEntry(
      id: const Uuid().v4(),
      timestamp: DateTime.now(),
      mood: mood,
      sleepHours: sleepHours,
      waterGlasses: waterGlasses,
      exercised: exercised,
      screenTimeHours: screenTimeHours,
      stressLevel: stressLevel,
      energyLevel: energyLevel,
      socialInteraction: socialInteraction,
      note: note,
    );
  }
}

final moodProvider = StateNotifierProvider<MoodNotifier, List<MoodEntry>>((ref) {
  return MoodNotifier();
});

final todaysMoodProvider = Provider<MoodEntry?>((ref) {
  final notifier = ref.watch(moodProvider.notifier);
  return notifier.todaysMood;
});

final wellnessScoreProvider = Provider<double>((ref) {
  final notifier = ref.watch(moodProvider.notifier);
  ref.watch(moodProvider); // subscribe to changes
  return notifier.averageWellnessScore;
});

final burnoutRiskProvider = Provider<double>((ref) {
  final notifier = ref.watch(moodProvider.notifier);
  ref.watch(moodProvider);
  return notifier.currentBurnoutRisk;
});

