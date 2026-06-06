import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/mood_provider.dart';
import '../../../providers/quest_provider.dart';
import '../../../models/quest_model.dart';
import '../../../models/mood_model.dart';
import '../../../providers/language_provider.dart';
import '../../../core/localization/app_localizations.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  String _greeting(AppLocalizations l10n) {
    final hour = DateTime.now().hour;
    if (hour < 12) return l10n.goodMorning;
    if (hour < 17) return l10n.goodAfternoon;
    return l10n.goodEvening;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = ref.watch(localizationsProvider);
    final user = ref.watch(userProfileProvider);
    final quests = ref.watch(questProvider);
    final todaysMood = ref.watch(todaysMoodProvider);
    final wellnessScore = ref.watch(wellnessScoreProvider);
    final burnoutRisk = ref.watch(burnoutRiskProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.heroGradient),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.screenPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${_greeting(l10n)}, ${user.name} 👋',
                                    style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 14,
                                      color: Colors.white70,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${l10n.youreA} ${user.identity}',
                                    style: const TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            // Streak chip
                            GestureDetector(
                              onTap: () => context.push('/achievements'),
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(100),
                                  border: Border.all(color: Colors.white.withOpacity(0.3)),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text('🔥', style: TextStyle(fontSize: 18)),
                                    const SizedBox(width: 6),
                                    Text(
                                      '${user.currentStreak}',
                                      style: const TextStyle(
                                        fontFamily: 'Outfit',
                                        fontSize: 18,
                                        fontWeight: FontWeight.w800,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            const SizedBox(width: 8),

                            // Notification + SOS
                            GestureDetector(
                              onTap: () => context.push('/emergency'),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.favorite_rounded, color: Colors.white, size: 20),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Level + XP bar
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.secondary,
                                borderRadius: BorderRadius.circular(100),
                              ),
                              child: Text(
                                'Lv ${user.level} • ${user.levelTitle}',
                                style: const TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: LinearProgressIndicator(
                                      value: user.levelProgress,
                                      backgroundColor: Colors.white.withOpacity(0.2),
                                      valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
                                      minHeight: 6,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${user.xpInCurrentLevel} / ${user.xpForNextLevel} XP',
                                    style: const TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 11,
                                      color: Colors.white60,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SERO Widget
                  _SeroWidget(stage: user.seroEvolutionStage, l10n: l10n)
                      .animate()
                      .fadeIn(duration: 500.ms),

                  const SizedBox(height: AppSpacing.sectionSpacing),

                  // Mood Check-In Card
                  if (todaysMood == null) ...[
                    _MoodCheckInPrompt()
                        .animate()
                        .fadeIn(duration: 500.ms, delay: 100.ms)
                        .slideY(begin: 0.2),
                    const SizedBox(height: AppSpacing.sectionSpacing),
                  ],

                  // Wellness Score Cards
                  _WellnessScoreRow(
                    wellnessScore: wellnessScore,
                    burnoutRisk: burnoutRisk,
                    moodEntry: todaysMood,
                  ).animate().fadeIn(duration: 500.ms, delay: 150.ms),

                  const SizedBox(height: AppSpacing.sectionSpacing),

                  // Daily Quests
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.dailyQuests,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: isDark ? Colors.white : AppColors.textPrimary,
                            ),
                      ),
                      Text(
                        '${quests.completedCount}/${quests.quests.length} ${l10n.doneWord}',
                        style: const TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  ...quests.quests.asMap().entries.map((entry) {
                    return _QuestCard(quest: entry.value, index: entry.key);
                  }),

                  const SizedBox(height: AppSpacing.sectionSpacing),

                  // Quick Actions
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.white : AppColors.textPrimary,
                        ),
                  ),

                  const SizedBox(height: 12),

                  _QuickActionsGrid(),

                  const SizedBox(height: AppSpacing.sectionSpacing),

                  // Inspirational Quote
                  _InspirationCard()
                      .animate(delay: 400.ms)
                      .fadeIn(duration: 500.ms),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// --- SERO Widget ---
class _SeroWidget extends StatefulWidget {
  final int stage;
  final AppLocalizations l10n;
  const _SeroWidget({required this.stage, required this.l10n});

  @override
  State<_SeroWidget> createState() => _SeroWidgetState();
}

class _SeroWidgetState extends State<_SeroWidget> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _bounce;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
    _bounce = Tween<double>(begin: 0, end: -8).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _seroEmoji {
    switch (widget.stage) {
      case 0: return '🌱';
      case 1: return '🌿';
      case 2: return '🌳';
      case 3: return '✨';
      case 4: return '🌟';
      default: return '🌱';
    }
  }

  String get _seroMessage {
    switch (widget.stage) {
      case 0: return 'I\'m growing with you! 🌱\nKeep building those habits!';
      case 1: return 'Look at us thriving! 🌿\nYou\'re doing amazing!';
      case 2: return 'We\'re both blossoming! 🌳\nYour consistency is inspiring!';
      case 3: return 'You\'re radiating wellness! ✨\nI\'m so proud of your journey!';
      case 4: return 'We are SERENE MASTERS! 🌟\nYou\'ve transformed your life!';
      default: return 'Let\'s build wellness together! 💚';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0D4A4A), Color(0xFF1A6B6B)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          AnimatedBuilder(
            animation: _bounce,
            builder: (ctx, child) {
              return Transform.translate(
                offset: Offset(0, _bounce.value),
                child: child,
              );
            },
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(_seroEmoji, style: const TextStyle(fontSize: 40)),
              ),
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.l10n.letenaSays,
                  style: const TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white60,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  _seroMessage,
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 14,
                    color: Colors.white,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.secondary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Text(
                    'Stage ${widget.stage + 1} of 5',
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: AppColors.secondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Mood Check-In Prompt ---
class _MoodCheckInPrompt extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.push('/mood'),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: AppColors.amberGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.secondary.withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            const Text('😊', style: TextStyle(fontSize: 36)),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ref.watch(localizationsProvider).howAreYouFeeling,
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    ref.watch(localizationsProvider).quickCheckIn,
                    style: const TextStyle(
                      fontFamily: 'Nunito',
                      fontSize: 13,
                      color: Color(0xCCFFFFFF),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_forward_rounded, color: Colors.white, size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Wellness Score Row ---
class _WellnessScoreRow extends StatelessWidget {
  final double wellnessScore;
  final double burnoutRisk;
  final MoodEntry? moodEntry;

  const _WellnessScoreRow({
    required this.wellnessScore,
    required this.burnoutRisk,
    this.moodEntry,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ScoreCard(
            label: 'Wellness Score',
            value: wellnessScore.toInt(),
            icon: Icons.favorite_rounded,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _ScoreCard(
            label: 'Burnout Risk',
            value: burnoutRisk.toInt(),
            icon: Icons.local_fire_department_rounded,
            color: burnoutRisk < 30
                ? AppColors.success
                : burnoutRisk < 60
                    ? AppColors.warning
                    : AppColors.error,
            isRisk: true,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: () => context.push('/wellness-dashboard'),
            child: _ScoreCard(
              label: 'View Trends',
              value: null,
              icon: Icons.trending_up_rounded,
              color: AppColors.primaryLight,
              isLink: true,
            ),
          ),
        ),
      ],
    );
  }
}

class _ScoreCard extends StatelessWidget {
  final String label;
  final int? value;
  final IconData icon;
  final Color color;
  final bool isRisk;
  final bool isLink;

  const _ScoreCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.isRisk = false,
    this.isLink = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 22),
          const SizedBox(height: 8),
          if (value != null)
            Text(
              '${isRisk ? '' : ''}$value${isRisk ? '' : ''}',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            )
          else
            Icon(Icons.arrow_forward_rounded, color: color, size: 22),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 11,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

// --- Quest Card ---
class _QuestCard extends ConsumerWidget {
  final Quest quest;
  final int index;

  const _QuestCard({required this.quest, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: quest.isCompleted
          ? null
          : () => ref.read(questProvider.notifier).completeQuest(quest.id),
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: quest.isCompleted ? null : quest.type.gradient,
                color: quest.isCompleted ? AppColors.success.withOpacity(0.1) : null,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                quest.isCompleted ? Icons.check_rounded : quest.type.icon,
                color: quest.isCompleted ? AppColors.success : Colors.white,
                size: 22,
              ),
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    quest.title,
                    style: TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                      decoration: quest.isCompleted ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  const SizedBox(height: 4),
                  LinearProgressIndicator(
                    value: quest.progress,
                    backgroundColor: isDark ? Colors.white10 : const Color(0xFFEEF5F2),
                    valueColor: AlwaysStoppedAnimation(
                      quest.isCompleted ? AppColors.success : AppColors.primary,
                    ),
                    minHeight: 4,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: quest.isCompleted
                    ? AppColors.success.withOpacity(0.1)
                    : AppColors.xpGold.withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                quest.isCompleted ? '✓ Done' : '+${quest.xpReward} XP',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: quest.isCompleted ? AppColors.success : AppColors.xpGold,
                ),
              ),
            ),
          ],
        ),
      ),
    )
        .animate(delay: Duration(milliseconds: index * 80))
        .fadeIn(duration: 400.ms)
        .slideX(begin: 0.1);
  }
}

// --- Quick Actions Grid ---
class _QuickActionsGrid extends StatelessWidget {
  final _actions = [
    (Icons.self_improvement_rounded, 'Meditate', '/wellness/mind', AppColors.mindGradient),
    (Icons.menu_book_rounded, 'Journal', '/journal', AppColors.primaryGradient),
    (Icons.emoji_events_rounded, 'Challenges', '/challenges', AppColors.amberGradient),
    (Icons.people_rounded, 'Community', '/community', AppColors.bodyGradient),
  ];

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.85,
      ),
      itemCount: _actions.length,
      itemBuilder: (ctx, i) {
        final (icon, label, route, gradient) = _actions[i];
        return GestureDetector(
          onTap: () => context.push(route),
          child: Column(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  gradient: gradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: (gradient.colors.first).withOpacity(0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(icon, color: Colors.white, size: 26),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
        ).animate(delay: Duration(milliseconds: i * 60)).fadeIn().scale(begin: const Offset(0.8, 0.8));
      },
    );
  }
}

// --- Inspiration Card ---
class _InspirationCard extends StatelessWidget {
  final _quotes = [
    ('"Every day is a chance to be healthier than yesterday."', '— Serene Wisdom'),
    ('"You don\'t need to be perfect. You just need to keep going."', '— Letena'),
    ('"Small habits, done consistently, create extraordinary lives."', '— Atomic Habits'),
    ('"Rest is not laziness. It is an act of wisdom."', '— Serene Wisdom'),
    ('"Your mental health is a priority. You matter."', '— Letena'),
  ];

  @override
  Widget build(BuildContext context) {
    final quote = _quotes[DateTime.now().day % _quotes.length];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withOpacity(0.4), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💬', style: TextStyle(fontSize: 28)),
          const SizedBox(height: 10),
          Text(
            quote.$1,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: isDark ? Colors.white : AppColors.textPrimary,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            quote.$2,
            style: const TextStyle(
              fontFamily: 'Outfit',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

