import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class WellnessHubScreen extends StatelessWidget {
  WellnessHubScreen({super.key});

  final _pillars = [
    (
      'Mind',
      '🧠',
      'Meditation, breathing & journaling',
      AppColors.mindGradient,
      '/wellness/mind',
    ),
    (
      'Body',
      '💪',
      'Exercise, stretching & movement',
      AppColors.bodyGradient,
      '/wellness/body',
    ),
    (
      'Nutrition',
      '🥗',
      'Water, meals & healthy eating',
      AppColors.nutritionGradient,
      '/wellness/nutrition',
    ),
    (
      'Sleep',
      '😴',
      'Routines, quality & restoration',
      AppColors.sleepGradient,
      '/wellness/sleep',
    ),
    (
      'Digital',
      '📵',
      'Screen time, focus & detox',
      AppColors.digitalGradient,
      '/wellness/digital',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Wellness Hub'),
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events_rounded),
            color: AppColors.secondary,
            onPressed: () => context.push('/challenges'),
            tooltip: 'Challenges',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Five Pillars of Wellness',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
            ).animate().fadeIn(),

            const SizedBox(height: 6),

            Text(
              'Balance across all five pillars creates lasting wellbeing.',
              style: TextStyle(
                fontFamily: 'Nunito',
                fontSize: 14,
                color: isDark ? Colors.white60 : AppColors.textMuted,
              ),
            ).animate(delay: 100.ms).fadeIn(),

            const SizedBox(height: 24),

            // Large Mind card
            _PillarCard(
              pillar: _pillars[0],
              isLarge: true,
              index: 0,
            ),

            const SizedBox(height: 12),

            // 2-column grid for rest
            Row(
              children: [
                Expanded(child: _PillarCard(pillar: _pillars[1], index: 1)),
                const SizedBox(width: 12),
                Expanded(child: _PillarCard(pillar: _pillars[2], index: 2)),
              ],
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(child: _PillarCard(pillar: _pillars[3], index: 3)),
                const SizedBox(width: 12),
                Expanded(child: _PillarCard(pillar: _pillars[4], index: 4)),
              ],
            ),

            const SizedBox(height: AppSpacing.sectionSpacing),

            // Challenges Banner
            GestureDetector(
              onTap: () => context.push('/challenges'),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: AppColors.amberGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    const Text('🏆', style: TextStyle(fontSize: 36)),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Active Challenges',
                            style: TextStyle(fontFamily: 'Outfit', fontSize: 17, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                          Text(
                            'Join 7, 21, or 30-day wellness challenges',
                            style: TextStyle(fontFamily: 'Nunito', fontSize: 13, color: Color(0xCCFFFFFF)),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_rounded, color: Colors.white),
                  ],
                ),
              ),
            ).animate(delay: 300.ms).fadeIn().slideY(begin: 0.2),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _PillarCard extends StatelessWidget {
  final (String, String, String, LinearGradient, String) pillar;
  final bool isLarge;
  final int index;

  const _PillarCard({required this.pillar, this.isLarge = false, required this.index});

  @override
  Widget build(BuildContext context) {
    final (name, emoji, desc, gradient, route) = pillar;

    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        height: isLarge ? 140 : 130,
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: (gradient.colors.first).withOpacity(0.3),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(emoji, style: TextStyle(fontSize: isLarge ? 36 : 28)),
                const Icon(Icons.arrow_forward_ios_rounded, color: Colors.white60, size: 14),
              ],
            ),
            const Spacer(),
            Text(
              name,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: isLarge ? 20 : 16,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              desc,
              style: const TextStyle(
                fontFamily: 'Nunito',
                fontSize: 11,
                color: Color(0xCCFFFFFF),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    ).animate(delay: Duration(milliseconds: index * 100)).fadeIn(duration: 400.ms).slideY(begin: 0.2, end: 0);
  }
}

