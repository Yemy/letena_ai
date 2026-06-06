import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/content_models.dart';

// --- Journal Provider ---
class JournalNotifier extends StateNotifier<List<JournalEntry>> {
  JournalNotifier() : super([
    JournalEntry(
      id: 'j1',
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
      content: 'Today was challenging but I found strength I didn\'t know I had. Grateful for this journey.',
      prompt: 'What challenge did you overcome this week?',
      moodTag: 'Good',
      tags: ['strength', 'gratitude'],
    ),
    JournalEntry(
      id: 'j2',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      content: 'Three things I\'m grateful for: my morning coffee, the sunrise, and a kind word from a colleague.',
      prompt: 'Name three things that bring you joy.',
      moodTag: 'Happy',
      tags: ['gratitude', 'joy'],
    ),
  ]);

  void addEntry(JournalEntry entry) {
    state = [entry, ...state];
  }

  void deleteEntry(String id) {
    state = state.where((e) => e.id != id).toList();
  }
}

final journalProvider = StateNotifierProvider<JournalNotifier, List<JournalEntry>>((ref) {
  return JournalNotifier();
});

// --- Community Provider ---
class CommunityNotifier extends StateNotifier<List<CommunityPost>> {
  CommunityNotifier() : super(CommunityPost.mockPosts);

  String _selectedCommunity = 'All';

  String get selectedCommunity => _selectedCommunity;

  List<CommunityPost> get filteredPosts {
    if (_selectedCommunity == 'All') return state;
    return state.where((p) => p.community == _selectedCommunity).toList();
  }

  void selectCommunity(String community) {
    _selectedCommunity = community;
    state = List.from(state); // trigger rebuild
  }
}

final communityProvider = StateNotifierProvider<CommunityNotifier, List<CommunityPost>>((ref) {
  return CommunityNotifier();
});

// --- Challenges Provider ---
class ChallengesNotifier extends StateNotifier<List<Challenge>> {
  ChallengesNotifier() : super(Challenge.allChallenges);

  void enrollChallenge(String id) {
    state = state.map((c) {
      if (c.id == id) {
        c.isEnrolled = true;
        c.currentDay = 1;
      }
      return c;
    }).toList();
  }

  void advanceDay(String id) {
    state = state.map((c) {
      if (c.id == id && c.isEnrolled) {
        c.currentDay = (c.currentDay + 1).clamp(0, c.durationDays);
        if (c.currentDay >= c.durationDays) c.isCompleted = true;
      }
      return c;
    }).toList();
  }
}

final challengesProvider = StateNotifierProvider<ChallengesNotifier, List<Challenge>>((ref) {
  return ChallengesNotifier();
});

// --- Theme Provider ---
final isDarkModeProvider = StateProvider<bool>((ref) => false);

// --- Language Provider ---
final languageProvider = StateProvider<String>((ref) => 'en');

// --- Onboarding Provider ---
final onboardingCompleteProvider = StateProvider<bool>((ref) => false);

