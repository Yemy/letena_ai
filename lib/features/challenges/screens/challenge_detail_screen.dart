import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../models/content_models.dart';
import '../../../providers/content_providers.dart';

class ChallengeDetailScreen extends ConsumerWidget {
  final String id;
  const ChallengeDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final challenges = ref.watch(challengesProvider);
    final challenge = challenges.firstWhere((c) => c.id == id, orElse: () => Challenge.allChallenges.first);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        title: Text(challenge.title),
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${challenge.durationDays}-Day Challenge', style: const TextStyle(fontFamily: 'Outfit', fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white)),
                const SizedBox(height: 8),
                Text(challenge.description, style: const TextStyle(fontFamily: 'Nunito', fontSize: 14, color: Color(0xCCFFFFFF), height: 1.5)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(100)),
                  child: Text('+${challenge.xpReward} XP on completion', style: const TextStyle(fontFamily: 'Outfit', fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text('Daily Tasks', style: TextStyle(fontFamily: 'Outfit', fontSize: 17, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.textPrimary)),
          const SizedBox(height: 12),
          ...challenge.dailyTasks.asMap().entries.map((entry) {
            final i = entry.key;
            final isDone = challenge.isEnrolled && i < challenge.currentDay;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: isDone ? Border.all(color: AppColors.success.withOpacity(0.4)) : null,
              ),
              child: Row(
                children: [
                  Container(
                    width: 28, height: 28,
                    decoration: BoxDecoration(
                      color: isDone ? AppColors.success : AppColors.primary.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: isDone
                          ? const Icon(Icons.check, size: 14, color: Colors.white)
                          : Text('${i + 1}', style: const TextStyle(fontFamily: 'Outfit', fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.primary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: Text('Day ${i + 1}: ${entry.value}', style: TextStyle(fontFamily: 'Nunito', fontSize: 14, color: isDark ? Colors.white : AppColors.textPrimary, decoration: isDone ? TextDecoration.lineThrough : null))),
                ],
              ),
            );
          }),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

