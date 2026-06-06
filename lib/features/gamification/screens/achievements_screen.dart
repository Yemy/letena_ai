import 'package:flutter/material.dart' hide Badge;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../models/badge_model.dart';
import '../../../providers/user_provider.dart';

class AchievementsScreen extends ConsumerWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final allBadges = AllBadges.badges;
    final unlockedBadges = allBadges.where((b) => user.badges.contains(b.id)).toList();
    final lockedBadges = allBadges.where((b) => !user.badges.contains(b.id)).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Achievements'),
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats row
            Row(
              children: [
                _StatCard(label: 'Badges Earned', value: '${unlockedBadges.length}', icon: '🏅', color: AppColors.xpGold),
                const SizedBox(width: 12),
                _StatCard(label: 'Total XP', value: '${user.totalXp}', icon: '⚡', color: AppColors.secondary),
                const SizedBox(width: 12),
                _StatCard(label: 'Level', value: '${user.level}', icon: '🌟', color: AppColors.primary),
              ],
            ).animate().fadeIn(),

            const SizedBox(height: AppSpacing.sectionSpacing),

            // Streak card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFF4A847)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Text('🔥', style: TextStyle(fontSize: 48)),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${user.currentStreak} Day Streak',
                        style: const TextStyle(fontFamily: 'Outfit', fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      Text(
                        'Longest: ${user.longestStreak} days',
                        style: const TextStyle(fontFamily: 'Nunito', fontSize: 13, color: Color(0xCCFFFFFF)),
                      ),
                    ],
                  ),
                ],
              ),
            ).animate(delay: 100.ms).fadeIn(),

            const SizedBox(height: AppSpacing.sectionSpacing),

            // Unlocked badges
            if (unlockedBadges.isNotEmpty) ...[
              Text(
                'Unlocked (${unlockedBadges.length})',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: isDark ? Colors.white : AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  childAspectRatio: 0.85,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                ),
                itemCount: unlockedBadges.length,
                itemBuilder: (ctx, i) {
                  return _BadgeCard(badge: unlockedBadges[i], isUnlocked: true, isDark: isDark)
                      .animate(delay: Duration(milliseconds: i * 80)).fadeIn().scale(begin: const Offset(0.8, 0.8));
                },
              ),
              const SizedBox(height: AppSpacing.sectionSpacing),
            ],

            // Locked badges
            Text(
              'Locked (${lockedBadges.length})',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.85,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemCount: lockedBadges.length,
              itemBuilder: (ctx, i) {
                return _BadgeCard(badge: lockedBadges[i], isUnlocked: false, isDark: isDark)
                    .animate(delay: Duration(milliseconds: i * 60)).fadeIn();
              },
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String icon;
  final Color color;

  const _StatCard({required this.label, required this.value, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(icon, style: const TextStyle(fontSize: 24)),
            const SizedBox(height: 4),
            Text(value, style: TextStyle(fontFamily: 'Outfit', fontSize: 20, fontWeight: FontWeight.w800, color: color)),
            Text(label, style: const TextStyle(fontFamily: 'Nunito', fontSize: 10, color: AppColors.textMuted), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}

class _BadgeCard extends StatelessWidget {
  final Badge badge;
  final bool isUnlocked;
  final bool isDark;

  const _BadgeCard({required this.badge, required this.isUnlocked, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isUnlocked ? Border.all(color: badge.rarity.color.withOpacity(0.5), width: 2) : null,
        boxShadow: isUnlocked ? [BoxShadow(color: badge.rarity.color.withOpacity(0.2), blurRadius: 8, offset: const Offset(0, 2))] : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          isUnlocked
              ? Text(badge.emoji, style: const TextStyle(fontSize: 32))
              : const Text('🔒', style: TextStyle(fontSize: 28, color: AppColors.textMuted)),
          const SizedBox(height: 6),
          Text(
            badge.title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isUnlocked ? (isDark ? Colors.white : AppColors.textPrimary) : AppColors.textMuted,
            ),
            maxLines: 2,
          ),
          if (isUnlocked) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: badge.rarity.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Text(
                badge.rarity.label,
                style: TextStyle(fontFamily: 'Outfit', fontSize: 9, fontWeight: FontWeight.w700, color: badge.rarity.color),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

