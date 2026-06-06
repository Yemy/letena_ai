import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../providers/mood_provider.dart';
import '../../../models/mood_model.dart';

class WellnessDashboardScreen extends ConsumerWidget {
  const WellnessDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final moods = ref.watch(moodProvider);
    final wellnessScore = ref.watch(wellnessScoreProvider);
    final burnoutRisk = ref.watch(burnoutRiskProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final last7 = moods.length > 7 ? moods.sublist(moods.length - 7) : moods;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Wellness Dashboard'),
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Score Cards Row
            Row(
              children: [
                Expanded(
                  child: _BigScoreCard(
                    label: 'Wellness Score',
                    value: wellnessScore.toInt(),
                    max: 100,
                    color: AppColors.success,
                    emoji: '💚',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _BigScoreCard(
                    label: 'Burnout Risk',
                    value: burnoutRisk.toInt(),
                    max: 100,
                    color: burnoutRisk < 30
                        ? AppColors.success
                        : burnoutRisk < 60 ? AppColors.warning : AppColors.error,
                    emoji: burnoutRisk < 30 ? '🛡️' : burnoutRisk < 60 ? '⚠️' : '🔴',
                    isRisk: true,
                  ),
                ),
              ],
            ).animate().fadeIn(),

            const SizedBox(height: AppSpacing.sectionSpacing),

            // Burnout Alert
            if (burnoutRisk >= 60)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.error.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const Text('🚨', style: TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'High Burnout Risk Detected',
                            style: TextStyle(
                              fontFamily: 'Outfit',
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: AppColors.error,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Your recent patterns suggest you may be heading toward burnout. Please consider rest, and talk to someone you trust.',
                            style: TextStyle(
                              fontFamily: 'Nunito',
                              fontSize: 13,
                              color: isDark ? Colors.white70 : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate().fadeIn().shake(),

            const SizedBox(height: AppSpacing.sectionSpacing),

            // Mood Chart (7-day)
            Text(
              '7-Day Mood Trend',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 12),

            Container(
              height: 180,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: LineChart(
                LineChartData(
                  gridData: const FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                          final idx = value.toInt();
                          if (idx >= 0 && idx < days.length) {
                            return Text(
                              days[idx],
                              style: TextStyle(
                                fontFamily: 'Outfit',
                                fontSize: 11,
                                color: isDark ? Colors.white60 : AppColors.textMuted,
                              ),
                            );
                          }
                          return const Text('');
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: last7.asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(), e.value.wellnessScore);
                      }).toList(),
                      isCurved: true,
                      color: AppColors.primary,
                      barWidth: 3,
                      dotData: FlDotData(
                        getDotPainter: (spot, percent, barData, index) {
                          return FlDotCirclePainter(
                            radius: 4,
                            color: AppColors.primary,
                            strokeWidth: 2,
                            strokeColor: Colors.white,
                          );
                        },
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [AppColors.primary.withOpacity(0.3), AppColors.primary.withOpacity(0)],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  minY: 0,
                  maxY: 100,
                ),
              ),
            ).animate(delay: 100.ms).fadeIn(),

            const SizedBox(height: AppSpacing.sectionSpacing),

            // Mood history
            Text(
              'Recent Check-Ins',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
            ),
            const SizedBox(height: 12),

            ...moods.reversed.take(7).map((entry) => _MoodHistoryItem(entry: entry, isDark: isDark)),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

class _BigScoreCard extends StatelessWidget {
  final String label;
  final int value;
  final int max;
  final Color color;
  final String emoji;
  final bool isRisk;

  const _BigScoreCard({
    required this.label,
    required this.value,
    required this.max,
    required this.color,
    required this.emoji,
    this.isRisk = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 10, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(emoji, style: const TextStyle(fontSize: 28)),
          const SizedBox(height: 8),
          Text(
            '$value',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 40,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'Nunito',
              fontSize: 12,
              color: AppColors.textMuted,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: value / max,
            backgroundColor: color.withOpacity(0.1),
            valueColor: AlwaysStoppedAnimation(color),
            minHeight: 6,
            borderRadius: BorderRadius.circular(100),
          ),
        ],
      ),
    );
  }
}

class _MoodHistoryItem extends StatelessWidget {
  final MoodEntry entry;
  final bool isDark;

  const _MoodHistoryItem({required this.entry, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Text(entry.mood.emoji, style: const TextStyle(fontSize: 24)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.mood.label,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                Text(
                  '${entry.timestamp.day}/${entry.timestamp.month} • Wellness: ${entry.wellnessScore.toInt()}%',
                  style: const TextStyle(
                    fontFamily: 'Nunito',
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: entry.mood.color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              '${entry.wellnessScore.toInt()}%',
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: entry.mood.color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

