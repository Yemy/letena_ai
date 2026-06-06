import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class MindScreen extends StatelessWidget {
  const MindScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _WellnessPillarScreen(
      title: 'Mind',
      emoji: '🧠',
      gradient: AppColors.mindGradient,
      description: 'Cultivate mental clarity, peace, and emotional resilience through mindfulness.',
      sections: [
        _WellnessSection(
          title: 'Meditations',
          items: [
            _WellnessItem('5-Min Calm', '😌', '5 min', 'Gentle breathing to settle your thoughts'),
            _WellnessItem('Body Scan', '🌊', '10 min', 'Release tension from head to toe'),
            _WellnessItem('Gratitude Meditation', '🙏', '8 min', 'Anchor yourself in appreciation'),
            _WellnessItem('Focus & Flow', '🎯', '12 min', 'Sharpen your concentration and clarity'),
            _WellnessItem('Deep Sleep Preparation', '🌙', '15 min', 'Transition your mind to restful sleep'),
          ],
        ),
        _WellnessSection(
          title: 'Breathing Exercises',
          items: [
            _WellnessItem('4-7-8 Breathing', '💨', '5 min', 'Inhale 4, hold 7, exhale 8 — instant calm'),
            _WellnessItem('Box Breathing', '📦', '5 min', 'Navy SEAL technique for stress control'),
            _WellnessItem('Diaphragmatic Breathing', '🫁', '8 min', 'Activate your body\'s relaxation response'),
            _WellnessItem('Alternate Nostril', '🌬️', '7 min', 'Balance your nervous system'),
          ],
        ),
        _WellnessSection(
          title: 'Journaling Prompts',
          items: [
            _WellnessItem('Daily Gratitude', '✍️', '5 min', 'Three things you\'re grateful for today'),
            _WellnessItem('Morning Intentions', '☀️', '5 min', 'Set purpose for your day'),
            _WellnessItem('Evening Reflection', '🌅', '8 min', 'Process the day with compassion'),
            _WellnessItem('Stress Release', '💭', '10 min', 'Write away your worries'),
          ],
        ),
      ],
    );
  }
}

class BodyScreen extends StatelessWidget {
  const BodyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _WellnessPillarScreen(
      title: 'Body',
      emoji: '💪',
      gradient: AppColors.bodyGradient,
      description: 'Move your body, release tension, and build physical resilience.',
      sections: [
        _WellnessSection(
          title: 'Exercise',
          items: [
            _WellnessItem('Morning Walk', '🚶', '20 min', 'A mindful walk to start your day right'),
            _WellnessItem('Full Body Stretch', '🤸', '10 min', 'Release tension from daily stress'),
            _WellnessItem('Desk Worker Relief', '💼', '8 min', 'Exercises for those who sit all day'),
            _WellnessItem('5-Minute Energy Boost', '⚡', '5 min', 'Quick movement to re-energize'),
            _WellnessItem('Evening Wind-Down', '🌙', '12 min', 'Gentle movement before bed'),
          ],
        ),
        _WellnessSection(
          title: 'Stretching',
          items: [
            _WellnessItem('Neck & Shoulder Release', '🦴', '6 min', 'Common stress tension areas'),
            _WellnessItem('Hip Flexor Opener', '🧘', '8 min', 'For those who sit a lot'),
            _WellnessItem('Spine Decompression', '🌿', '5 min', 'Relieve back tension'),
          ],
        ),
      ],
    );
  }
}

class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  @override
  State<NutritionScreen> createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  int _waterGlasses = 3;
  final int _waterGoal = 8;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return _WellnessPillarScreen(
      title: 'Nutrition',
      emoji: '🥗',
      gradient: AppColors.nutritionGradient,
      description: 'Fuel your body and mind with hydration and wholesome nutrition.',
      headerWidget: _WaterTrackerWidget(
        current: _waterGlasses,
        goal: _waterGoal,
        isDark: isDark,
        onAdd: () => setState(() => _waterGlasses = (_waterGlasses + 1).clamp(0, 12)),
      ),
      sections: [
        _WellnessSection(
          title: 'Nutrition Tips',
          items: [
            _WellnessItem('Brain Foods', '🧠', '3 min read', 'Eat for mental clarity and focus'),
            _WellnessItem('Stress-Reducing Foods', '😌', '4 min read', 'Foods that naturally lower cortisol'),
            _WellnessItem('Energy-Boosting Meals', '⚡', '5 min read', 'Sustain energy without crashes'),
            _WellnessItem('Sleep-Promoting Nutrition', '😴', '3 min read', 'What to eat before bed'),
          ],
        ),
        _WellnessSection(
          title: 'Healthy Eating Habits',
          items: [
            _WellnessItem('Mindful Eating', '🍽️', '5 min', 'Eat with awareness, not distraction'),
            _WellnessItem('Meal Planning Basics', '📋', '8 min', 'Simple, nutritious African meals'),
            _WellnessItem('Reduce Sugar Gradually', '🍬', '4 min', 'Break the cycle compassionately'),
          ],
        ),
      ],
    );
  }
}

class _WaterTrackerWidget extends StatelessWidget {
  final int current;
  final int goal;
  final bool isDark;
  final VoidCallback onAdd;

  const _WaterTrackerWidget({
    required this.current,
    required this.goal,
    required this.isDark,
    required this.onAdd,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.primaryLight.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('💧 Water Tracker', style: TextStyle(fontFamily: 'Outfit', fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$current / $goal glasses',
                style: TextStyle(fontFamily: 'Outfit', fontSize: 22, fontWeight: FontWeight.w800, color: AppColors.primaryLight),
              ),
              ElevatedButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add'),
                style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: List.generate(goal, (i) {
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  height: 24,
                  decoration: BoxDecoration(
                    color: i < current ? AppColors.primaryLight : AppColors.primaryLight.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: i < current ? const Center(child: Text('💧', style: TextStyle(fontSize: 12))) : null,
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          if (current >= goal)
            const Text('🎉 Daily goal reached! +10 XP', style: TextStyle(fontFamily: 'Outfit', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.success)),
        ],
      ),
    );
  }
}

class SleepScreen extends StatelessWidget {
  const SleepScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _WellnessPillarScreen(
      title: 'Sleep',
      emoji: '😴',
      gradient: AppColors.sleepGradient,
      description: 'Restore your mind and body with quality sleep and healthy routines.',
      sections: [
        _WellnessSection(
          title: 'Sleep Routines',
          items: [
            _WellnessItem('Wind-Down Ritual', '🌙', '20 min', 'A calming bedtime routine that works'),
            _WellnessItem('Power Nap Guide', '⏰', '20-30 min', 'The science of the perfect nap'),
            _WellnessItem('Morning Routine', '☀️', '15 min', 'Start the day with intention'),
          ],
        ),
        _WellnessSection(
          title: 'Sleep Education',
          items: [
            _WellnessItem('Sleep Hygiene Basics', '📚', '5 min read', 'Simple habits for better sleep'),
            _WellnessItem('Understanding Sleep Cycles', '🔄', '6 min read', 'Optimize your sleep stages'),
            _WellnessItem('Stress & Sleep Connection', '🧠', '4 min read', 'Why stress ruins sleep and how to fix it'),
          ],
        ),
        _WellnessSection(
          title: 'Audio for Sleep',
          items: [
            _WellnessItem('Rain Sounds', '🌧️', '∞', 'Soothing natural rain ambience'),
            _WellnessItem('Guided Sleep Meditation', '🌊', '20 min', 'Drift off with Letena\'s voice'),
            _WellnessItem('White Noise', '〰️', '∞', 'Mask distracting sounds'),
          ],
        ),
      ],
    );
  }
}

class DigitalScreen extends StatelessWidget {
  const DigitalScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return _WellnessPillarScreen(
      title: 'Digital Wellbeing',
      emoji: '📵',
      gradient: AppColors.digitalGradient,
      description: 'Reclaim your attention, protect your focus, and thrive offline.',
      sections: [
        _WellnessSection(
          title: 'Focus Sessions',
          items: [
            _WellnessItem('Pomodoro (25 min)', '🍅', '25 min', 'Work focused, rest intentionally'),
            _WellnessItem('Deep Work Block', '🎯', '90 min', 'For your most important tasks'),
            _WellnessItem('Digital Sunset', '🌅', '1 hr', 'No screens 1 hour before bed'),
          ],
        ),
        _WellnessSection(
          title: 'Digital Detox',
          items: [
            _WellnessItem('Phone-Free Morning', '🌄', '60 min', 'Start your day without screens'),
            _WellnessItem('Social Media Fast', '📵', '24 hrs', 'One day of true presence'),
            _WellnessItem('Weekend Detox', '🏕️', '48 hrs', 'Reconnect with the physical world'),
          ],
        ),
        _WellnessSection(
          title: 'Screen Time Awareness',
          items: [
            _WellnessItem('Set App Limits', '⏱️', '5 min', 'Take back control of your time'),
            _WellnessItem('Notification Audit', '🔕', '10 min', 'Stop the distraction cycle'),
            _WellnessItem('Blue Light & Sleep', '💡', '3 min read', 'How screens disrupt your sleep'),
          ],
        ),
      ],
    );
  }
}

// --- Shared Pillar Screen Template ---
class _WellnessPillarScreen extends StatelessWidget {
  final String title;
  final String emoji;
  final LinearGradient gradient;
  final String description;
  final List<_WellnessSection> sections;
  final Widget? headerWidget;

  const _WellnessPillarScreen({
    required this.title,
    required this.emoji,
    required this.gradient,
    required this.description,
    required this.sections,
    this.headerWidget,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 160,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                decoration: BoxDecoration(gradient: gradient),
                child: SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(emoji, style: const TextStyle(fontSize: 40)).animate().scale(duration: 600.ms),
                        const SizedBox(height: 8),
                        Text(
                          description,
                          style: const TextStyle(fontFamily: 'Nunito', fontSize: 13, color: Color(0xCCFFFFFF), height: 1.4),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              title: Text(title, style: const TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w700, color: Colors.white)),
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (headerWidget != null) ...[
                    headerWidget!,
                    const SizedBox(height: AppSpacing.sectionSpacing),
                  ],
                  ...sections.asMap().entries.map((entry) {
                    final (i, section) = (entry.key, entry.value);
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          section.title,
                          style: TextStyle(
                            fontFamily: 'Outfit',
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                            color: isDark ? Colors.white : AppColors.textPrimary,
                          ),
                        ).animate(delay: Duration(milliseconds: i * 100)).fadeIn(),
                        const SizedBox(height: 10),
                        ...section.items.asMap().entries.map((itemEntry) {
                          final item = itemEntry.value;
                          return _WellnessItemCard(item: item, gradient: gradient, isDark: isDark)
                              .animate(delay: Duration(milliseconds: i * 100 + itemEntry.key * 60))
                              .fadeIn()
                              .slideX(begin: 0.1);
                        }),
                        const SizedBox(height: AppSpacing.sectionSpacing),
                      ],
                    );
                  }),
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

class _WellnessSection {
  final String title;
  final List<_WellnessItem> items;
  const _WellnessSection({required this.title, required this.items});
}

class _WellnessItem {
  final String title;
  final String emoji;
  final String duration;
  final String description;
  const _WellnessItem(this.title, this.emoji, this.duration, this.description);
}

class _WellnessItemCard extends StatelessWidget {
  final _WellnessItem item;
  final LinearGradient gradient;
  final bool isDark;

  const _WellnessItemCard({required this.item, required this.gradient, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: gradient,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(child: Text(item.emoji, style: const TextStyle(fontSize: 22))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.description,
                  style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, color: AppColors.textMuted),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: gradient.colors.first.withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              item.duration,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: gradient.colors.first,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.play_circle_filled_rounded, color: gradient.colors.last.withOpacity(0.7), size: 28),
        ],
      ),
    );
  }
}

