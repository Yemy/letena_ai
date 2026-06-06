import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../providers/user_provider.dart';

class LeaguesScreen extends ConsumerWidget {
  const LeaguesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final leagues = [
      ('Diamond', '💎', AppColors.diamond, 5000, '12 users', true),
      ('Platinum', '🏆', AppColors.platinum, 2000, '38 users', false),
      ('Gold', '🥇', AppColors.gold, 1000, '124 users', false),
      ('Silver', '🥈', AppColors.silver, 400, '310 users', false),
      ('Bronze', '🥉', AppColors.bronze, 0, '1,240 users', false),
    ];

    final mockLeaderboard = [
      ('Yohannes T.', 1240, 'you'),
      ('Sara M.', 2310, 'leader'),
      ('Bereket A.', 1890, null),
      ('Tigist K.', 1560, null),
      ('Abebe G.', 1340, null),
      ('Hana W.', 1180, null),
      ('Dawit L.', 1050, null),
      ('Selam B.', 980, null),
    ];

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Leagues'),
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current league banner
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFD4881A), Color(0xFFF4A847)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Text(
                    leagues.firstWhere((l) => l.$1 == user.leagueTitle, orElse: () => leagues.last).$2,
                    style: const TextStyle(fontSize: 52),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${user.leagueTitle} League',
                          style: const TextStyle(fontFamily: 'Outfit', fontSize: 22, fontWeight: FontWeight.w800, color: Colors.white),
                        ),
                        Text(
                          'Week resets in 4 days',
                          style: const TextStyle(fontFamily: 'Nunito', fontSize: 13, color: Color(0xCCFFFFFF)),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Text(
                            '${user.totalXp} XP this week',
                            style: const TextStyle(fontFamily: 'Outfit', fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),

            const SizedBox(height: AppSpacing.sectionSpacing),

            // League tiers
            Text(
              'League Tiers',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            Row(
              children: leagues.map((l) {
                final isCurrentLeague = l.$1 == user.leagueTitle;
                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isCurrentLeague ? l.$3.withOpacity(0.15) : (isDark ? AppColors.cardDark : Colors.white),
                      borderRadius: BorderRadius.circular(12),
                      border: isCurrentLeague ? Border.all(color: l.$3, width: 2) : null,
                    ),
                    child: Column(
                      children: [
                        Text(l.$2, style: const TextStyle(fontSize: 22)),
                        const SizedBox(height: 4),
                        Text(l.$1, style: TextStyle(fontFamily: 'Outfit', fontSize: 10, fontWeight: FontWeight.w700, color: l.$3)),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ).animate(delay: 100.ms).fadeIn(),

            const SizedBox(height: AppSpacing.sectionSpacing),

            // Leaderboard
            Text(
              '🏆 This Week\'s Leaderboard',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 17,
                fontWeight: FontWeight.w700,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),

            ...mockLeaderboard.asMap().entries.map((entry) {
              final i = entry.key;
              final (name, xp, tag) = entry.value;
              final isYou = tag == 'you';

              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: isYou
                      ? AppColors.primary.withOpacity(0.1)
                      : isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: isYou ? Border.all(color: AppColors.primary.withOpacity(0.4), width: 1.5) : null,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 28,
                      child: Text(
                        i == 0 ? '🥇' : i == 1 ? '🥈' : i == 2 ? '🥉' : '${i + 1}',
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: i < 3 ? 20 : 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textMuted,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: isYou ? AppColors.primaryGradient : const LinearGradient(colors: [Color(0xFFB0BEC5), Color(0xFF90A4AE)]),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          name.substring(0, 1),
                          style: const TextStyle(fontFamily: 'Outfit', fontSize: 16, fontWeight: FontWeight.w700, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                name,
                                style: TextStyle(
                                  fontFamily: 'Outfit',
                                  fontSize: 14,
                                  fontWeight: isYou ? FontWeight.w700 : FontWeight.w600,
                                  color: isYou ? AppColors.primary : (isDark ? Colors.white : AppColors.textPrimary),
                                ),
                              ),
                              if (isYou) ...[
                                const SizedBox(width: 6),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary,
                                    borderRadius: BorderRadius.circular(100),
                                  ),
                                  child: const Text('You', style: TextStyle(fontFamily: 'Outfit', fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white)),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '$xp XP',
                      style: const TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: AppColors.xpGold,
                      ),
                    ),
                  ],
                ),
              ).animate(delay: Duration(milliseconds: i * 80)).fadeIn().slideX(begin: 0.1);
            }),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

