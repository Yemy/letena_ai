import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/mood_provider.dart';
import '../../../models/badge_model.dart';
import '../../../providers/language_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final wellnessScore = ref.watch(wellnessScoreProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unlockedBadges = AllBadges.badges.where((b) => user.badges.contains(b.id)).toList();

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 240,
            pinned: true,
            backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: const BoxDecoration(gradient: AppColors.heroGradient),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            // Avatar
                            Container(
                              width: 72,
                              height: 72,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white.withOpacity(0.4), width: 2),
                              ),
                              child: Center(
                                child: Text(
                                  user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                                  style: const TextStyle(fontFamily: 'Outfit', fontSize: 30, fontWeight: FontWeight.w800, color: Colors.white),
                                ),
                              ),
                            ).animate().scale(duration: 500.ms),

                            const SizedBox(width: 16),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user.name,
                                  style: const TextStyle(fontFamily: 'Outfit', fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(100)),
                                  child: Text(user.identity, style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, color: Color(0xCCFFFFFF))),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 16),

                        // Level bar
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(100)),
                              child: Text('Lv ${user.level} • ${user.levelTitle}', style: const TextStyle(fontFamily: 'Outfit', fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: LinearProgressIndicator(
                                  value: user.levelProgress,
                                  backgroundColor: Colors.white.withOpacity(0.2),
                                  valueColor: const AlwaysStoppedAnimation(AppColors.secondary),
                                  minHeight: 6,
                                ),
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
            actions: [
              IconButton(
                icon: const Icon(Icons.settings_rounded, color: Colors.white),
                onPressed: () => context.push('/settings'),
              ),
            ],
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats row
                  Row(
                    children: [
                      _StatTile(emoji: '🔥', label: 'Streak', value: '${user.currentStreak}d'),
                      _StatTile(emoji: '⚡', label: 'Total XP', value: '${user.totalXp}'),
                      _StatTile(emoji: '💎', label: 'League', value: user.leagueTitle),
                      _StatTile(emoji: '💚', label: 'Wellness', value: '${wellnessScore.toInt()}%'),
                    ],
                  ).animate().fadeIn(),

                  const SizedBox(height: AppSpacing.sectionSpacing),

                  // SERO Evolution
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0D4A4A), Color(0xFF1A6B6B)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Text(
                          _seroEmoji(user.seroEvolutionStage),
                          style: const TextStyle(fontSize: 52),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Letena — Your Companion', style: TextStyle(fontFamily: 'Outfit', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70)),
                              Text('Stage ${user.seroEvolutionStage + 1} of 5', style: const TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.w800, color: Colors.white)),
                              Text('Keep earning XP to evolve Letena!', style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, color: Colors.white70)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ).animate(delay: 100.ms).fadeIn(),

                  const SizedBox(height: AppSpacing.sectionSpacing),

                  // Badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Badges', style: TextStyle(fontFamily: 'Outfit', fontSize: 17, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.textPrimary)),
                      TextButton(
                        onPressed: () => context.push('/achievements'),
                        child: const Text('See all →'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),

                  if (unlockedBadges.isEmpty)
                    const Text('Complete daily quests and check-ins to earn badges!', style: TextStyle(fontFamily: 'Nunito', fontSize: 14, color: AppColors.textMuted))
                  else
                    SizedBox(
                      height: 80,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: unlockedBadges.take(8).length,
                        itemBuilder: (ctx, i) {
                          final badge = unlockedBadges[i];
                          return Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: isDark ? AppColors.cardDark : Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: badge.rarity.color.withOpacity(0.4), width: 2),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(badge.emoji, style: const TextStyle(fontSize: 28)),
                                Text(badge.title, style: const TextStyle(fontFamily: 'Outfit', fontSize: 8, color: AppColors.textMuted), textAlign: TextAlign.center, maxLines: 1),
                              ],
                            ),
                          ).animate(delay: Duration(milliseconds: i * 60)).fadeIn().scale(begin: const Offset(0.8, 0.8));
                        },
                      ),
                    ),

                  const SizedBox(height: AppSpacing.sectionSpacing),

                  // Quick links
                  _ProfileLink(icon: Icons.emoji_events_rounded, label: 'View Leagues', onTap: () => context.push('/leagues')),
                  _ProfileLink(icon: Icons.flag_rounded, label: 'My Challenges', onTap: () => context.push('/challenges')),
                  _ProfileLink(icon: Icons.menu_book_rounded, label: 'Journal History', onTap: () => context.push('/journal')),
                  _ProfileLink(icon: Icons.favorite_rounded, label: 'Emergency & SOS', color: AppColors.error, onTap: () => context.push('/emergency')),
                  
                  // Language Selector
                  ListTile(
                    onTap: () {
                      showModalBottomSheet(
                        context: context,
                        backgroundColor: isDark ? AppColors.bgDark : Colors.white,
                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                        builder: (ctx) => SafeArea(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: AppLanguage.values.map((lang) {
                              return ListTile(
                                title: Text(lang.displayName, style: TextStyle(fontFamily: 'Outfit', color: isDark ? Colors.white : AppColors.textPrimary)),
                                trailing: ref.watch(languageProvider) == lang ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
                                onTap: () {
                                  ref.read(languageProvider.notifier).setLanguage(lang);
                                  Navigator.pop(ctx);
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                    contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                    leading: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
                      child: const Icon(Icons.language_rounded, color: AppColors.primary, size: 20),
                    ),
                    title: Text('App Language', style: TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary)),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(ref.watch(languageProvider).displayName, style: const TextStyle(fontFamily: 'Nunito', color: AppColors.primary, fontWeight: FontWeight.bold)),
                        const SizedBox(width: 8),
                        const Icon(Icons.keyboard_arrow_down_rounded, size: 18, color: AppColors.textMuted),
                      ],
                    ),
                  ),

                  _ProfileLink(icon: Icons.settings_rounded, label: 'Settings', onTap: () => context.push('/settings')),

                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _seroEmoji(int stage) {
    switch (stage) {
      case 0: return '🌱';
      case 1: return '🌿';
      case 2: return '🌳';
      case 3: return '✨';
      case 4: return '🌟';
      default: return '🌱';
    }
  }
}

class _StatTile extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;

  const _StatTile({required this.emoji, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isDark ? AppColors.cardDark : Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(emoji, style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontFamily: 'Outfit', fontSize: 14, fontWeight: FontWeight.w800, color: AppColors.primary)),
            Text(label, style: const TextStyle(fontFamily: 'Nunito', fontSize: 9, color: AppColors.textMuted)),
          ],
        ),
      ),
    );
  }
}

class _ProfileLink extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  const _ProfileLink({required this.icon, required this.label, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (color ?? AppColors.primary).withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(icon, color: color ?? AppColors.primary, size: 20),
      ),
      title: Text(label, style: TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w600, color: color ?? (isDark ? Colors.white : AppColors.textPrimary))),
      trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
    );
  }
}

