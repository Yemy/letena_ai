import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/quest_model.dart';
import 'user_provider.dart';

class QuestNotifier extends StateNotifier<DailyQuests> {
  final Ref _ref;

  QuestNotifier(this._ref) : super(DailyQuests.generate(DateTime.now()));

  void completeQuest(String questId) {
    final quest = state.quests.firstWhere((q) => q.id == questId, orElse: () => throw Exception('Quest not found'));
    if (quest.isCompleted) return;

    quest.currentCount = quest.targetCount;
    quest.status = QuestStatus.completed;

    // Award XP
    _ref.read(userProfileProvider.notifier).addXp(quest.xpReward);

    // Trigger rebuild
    state = DailyQuests(quests: List.from(state.quests), date: state.date);
  }

  void incrementQuest(String questId) {
    final quest = state.quests.firstWhere((q) => q.id == questId, orElse: () => throw Exception('Quest not found'));
    if (quest.isCompleted) return;

    quest.currentCount = (quest.currentCount + 1).clamp(0, quest.targetCount);
    if (quest.currentCount >= quest.targetCount) {
      quest.status = QuestStatus.completed;
      _ref.read(userProfileProvider.notifier).addXp(quest.xpReward);
    } else {
      quest.status = QuestStatus.inProgress;
    }

    state = DailyQuests(quests: List.from(state.quests), date: state.date);
  }

  void regenerate() {
    state = DailyQuests.generate(DateTime.now());
  }
}

final questProvider = StateNotifierProvider<QuestNotifier, DailyQuests>((ref) {
  return QuestNotifier(ref);
});

final completedQuestsCountProvider = Provider<int>((ref) {
  return ref.watch(questProvider).completedCount;
});

