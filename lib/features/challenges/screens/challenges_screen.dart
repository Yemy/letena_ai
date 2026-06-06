import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../models/content_models.dart';
import '../../../providers/content_providers.dart';

class ChallengesScreen extends ConsumerWidget {
  const ChallengesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challenges = ref.watch(challengesProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final enrolled = challenges.where((c) => c.isEnrolled && !c.isCompleted).toList();
    final available = challenges.where((c) => !c.isEnrolled && !c.isCompleted).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Challenges'),
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF0D4A4A), Color(0xFF2A9B9B)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('🏆 Wellness Challenges', style: TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                        SizedBox(height: 4),
                        Text('Commit to a challenge and transform your life. Earn XP, badges, and certificates.', style: TextStyle(fontFamily: 'Nunito', fontSize: 13, color: Color(0xCCFFFFFF), height: 1.4)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text('🎯', style: TextStyle(fontSize: 48)),
                ],
              ),
            ).animate().fadeIn(),

            if (enrolled.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.sectionSpacing),
              Text('Active Challenges', style: TextStyle(fontFamily: 'Outfit', fontSize: 17, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.textPrimary)),
              const SizedBox(height: 12),
              ...enrolled.map((c) => _ChallengeCard(challenge: c, isDark: isDark, isEnrolled: true)),
            ],

            const SizedBox(height: AppSpacing.sectionSpacing),
            Text('Available Challenges', style: TextStyle(fontFamily: 'Outfit', fontSize: 17, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.textPrimary)),
            const SizedBox(height: 12),

            ...available.asMap().entries.map((entry) {
              return _ChallengeCard(challenge: entry.value, isDark: isDark, isEnrolled: false)
                  .animate(delay: Duration(milliseconds: entry.key * 100))
                  .fadeIn()
                  .slideY(begin: 0.1);
            }),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _ChallengeCard extends ConsumerWidget {
  final Challenge challenge;
  final bool isDark;
  final bool isEnrolled;

  const _ChallengeCard({required this.challenge, required this.isDark, required this.isEnrolled});

  String get _categoryEmoji {
    switch (challenge.category) {
      case 'Mind': return '🧠';
      case 'Digital': return '📵';
      case 'Sleep': return '😴';
      default: return '🌟';
    }
  }

  LinearGradient get _gradient {
    switch (challenge.category) {
      case 'Mind': return AppColors.mindGradient;
      case 'Digital': return AppColors.digitalGradient;
      case 'Sleep': return AppColors.sleepGradient;
      default: return AppColors.primaryGradient;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: () => context.push('/challenges/${challenge.id}'),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: isEnrolled ? Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5) : null,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(gradient: _gradient, borderRadius: BorderRadius.circular(14)),
                  child: Center(child: Text(_categoryEmoji, style: const TextStyle(fontSize: 26))),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        challenge.title,
                        style: TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.textPrimary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${challenge.durationDays} days • ${challenge.category}',
                        style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, color: AppColors.textMuted),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.xpGold.withOpacity(0.15), borderRadius: BorderRadius.circular(100)),
                  child: Text('+${challenge.xpReward} XP', style: const TextStyle(fontFamily: 'Outfit', fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.xpGold)),
                ),
              ],
            ),

            const SizedBox(height: 10),

            Text(challenge.description, style: TextStyle(fontFamily: 'Nunito', fontSize: 13, color: isDark ? Colors.white70 : AppColors.textSecondary, height: 1.4)),

            if (isEnrolled) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Day ${challenge.currentDay} of ${challenge.durationDays}', style: const TextStyle(fontFamily: 'Outfit', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                  Text('${(challenge.progress * 100).toInt()}%', style: const TextStyle(fontFamily: 'Outfit', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                ],
              ),
              const SizedBox(height: 6),
              LinearProgressIndicator(
                value: challenge.progress,
                backgroundColor: AppColors.primary.withOpacity(0.1),
                valueColor: const AlwaysStoppedAnimation(AppColors.primary),
                minHeight: 6,
                borderRadius: BorderRadius.circular(100),
              ),
            ],

            if (!isEnrolled) ...[
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  ref.read(challengesProvider.notifier).enrollChallenge(challenge.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('🏆 Enrolled in ${challenge.title}! Let\'s go!'),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 42),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Join Challenge →'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

