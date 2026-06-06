class JournalEntry {
  final String id;
  final DateTime timestamp;
  final String content;
  final String? prompt;
  final bool isVoice;
  final String? audioPath;
  final String? moodTag;
  final List<String> tags;

  const JournalEntry({
    required this.id,
    required this.timestamp,
    required this.content,
    this.prompt,
    this.isVoice = false,
    this.audioPath,
    this.moodTag,
    this.tags = const [],
  });

  static const List<String> prompts = [
    'What made you smile today?',
    'What are you grateful for right now?',
    'What challenge did you overcome this week?',
    'What is one thing you want to let go of?',
    'Describe a moment when you felt truly at peace.',
    'What would you tell your past self from a year ago?',
    'What energizes you and what drains you?',
    'What is one small step you can take toward your goal today?',
    'How did you show kindness to yourself today?',
    'What is something you are proud of that nobody knows about?',
    'What boundaries do you need to set to protect your energy?',
    'What does your ideal day look like?',
    'What worries you most, and what can you control about it?',
    'Name three things that bring you joy.',
    'What does success look like for you?',
  ];

  static String get randomPrompt {
    final now = DateTime.now();
    return prompts[now.day % prompts.length];
  }
}

class CommunityPost {
  final String id;
  final String authorId;
  final String authorInitials;
  final String community;
  final String content;
  final DateTime timestamp;
  final int likes;
  final int comments;
  final List<String> reactions;
  final bool isPinned;

  const CommunityPost({
    required this.id,
    required this.authorId,
    required this.authorInitials,
    required this.community,
    required this.content,
    required this.timestamp,
    this.likes = 0,
    this.comments = 0,
    this.reactions = const [],
    this.isPinned = false,
  });

  static List<CommunityPost> get mockPosts => [
    CommunityPost(
      id: '1', authorId: 'u1', authorInitials: 'YA',
      community: 'Developers',
      content: 'After 3 months of burnout, I finally took a mental health day. It felt strange but so necessary. Reminder: your worth is not your productivity. 💚',
      timestamp: DateTime.now().subtract(const Duration(hours: 2)),
      likes: 47, comments: 12,
    ),
    CommunityPost(
      id: '2', authorId: 'u2', authorInitials: 'SM',
      community: 'Students',
      content: '21-day gratitude challenge completed! 🙏 I started noticing so many small beautiful things in my day that I used to miss entirely. This changed my perspective.',
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
      likes: 89, comments: 23,
      isPinned: true,
    ),
    CommunityPost(
      id: '3', authorId: 'u3', authorInitials: 'BT',
      community: 'Entrepreneurs',
      content: 'Week 2 of the sleep challenge. Going to bed at 10 PM felt impossible before. Now my mind is clearer, my decisions sharper. Sleep is not lazy — it\'s an investment.',
      timestamp: DateTime.now().subtract(const Duration(hours: 8)),
      likes: 34, comments: 8,
    ),
    CommunityPost(
      id: '4', authorId: 'u4', authorInitials: 'FG',
      community: 'Healthcare',
      content: 'As a nurse working night shifts, mental health self-care feels impossible. But even 5 minutes of breathing in the break room makes a difference. We matter too.',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      likes: 156, comments: 41,
    ),
    CommunityPost(
      id: '5', authorId: 'u5', authorInitials: 'NA',
      community: 'Parents',
      content: 'Today I explained to my 8-year-old why I was doing breathing exercises. She joined me. Teaching our children emotional regulation might be the best gift we give.',
      timestamp: DateTime.now().subtract(const Duration(days: 1, hours: 3)),
      likes: 201, comments: 67,
    ),
  ];
}

class Challenge {
  final String id;
  final String title;
  final String description;
  final int durationDays;
  final String category;
  final int xpReward;
  final List<String> dailyTasks;
  int currentDay;
  bool isEnrolled;
  bool isCompleted;

  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.durationDays,
    required this.category,
    required this.xpReward,
    required this.dailyTasks,
    this.currentDay = 0,
    this.isEnrolled = false,
    this.isCompleted = false,
  });

  double get progress => durationDays > 0 ? currentDay / durationDays : 0;

  static List<Challenge> get allChallenges => [
    Challenge(
      id: 'stress_7',
      title: '7-Day Stress Less Challenge',
      description: 'Break the stress cycle in just one week with daily practices.',
      durationDays: 7,
      category: 'Mind',
      xpReward: 500,
      dailyTasks: ['5-min meditation', 'Breathing exercise', 'Gratitude journal', 'Digital detox hour', 'Nature walk', 'Positive affirmations', 'Rest day reflection'],
    ),
    Challenge(
      id: 'detox_21',
      title: '21-Day Digital Detox',
      description: 'Reclaim your attention and reconnect with what matters.',
      durationDays: 21,
      category: 'Digital',
      xpReward: 1500,
      dailyTasks: List.generate(21, (i) => 'Day ${i+1} digital wellness task'),
    ),
    Challenge(
      id: 'sleep_30',
      title: '30-Day Better Sleep Challenge',
      description: 'Transform your sleep quality and wake up recharged.',
      durationDays: 30,
      category: 'Sleep',
      xpReward: 2000,
      dailyTasks: List.generate(30, (i) => 'Day ${i+1} sleep optimization task'),
    ),
    Challenge(
      id: 'gratitude_21',
      title: '21-Day Gratitude Challenge',
      description: 'Rewire your brain for positivity and appreciation.',
      durationDays: 21,
      category: 'Mind',
      xpReward: 1200,
      dailyTasks: List.generate(21, (i) => 'Day ${i+1} gratitude journal'),
    ),
  ];
}

