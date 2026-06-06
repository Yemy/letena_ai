import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../models/mood_model.dart';
import '../../../providers/mood_provider.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/quest_provider.dart';
import 'package:uuid/uuid.dart';

class MoodCheckInScreen extends ConsumerStatefulWidget {
  const MoodCheckInScreen({super.key});

  @override
  ConsumerState<MoodCheckInScreen> createState() => _MoodCheckInScreenState();
}

class _MoodCheckInScreenState extends ConsumerState<MoodCheckInScreen> {
  MoodType? _selectedMood;
  int _sleepHours = 7;
  int _waterGlasses = 4;
  bool _exercised = false;
  int _screenTimeHours = 4;
  int _stressLevel = 5;
  int _energyLevel = 6;
  bool _socialInteraction = false;
  int _page = 0;

  final _moods = [
    MoodType.happy,
    MoodType.good,
    MoodType.neutral,
    MoodType.stressed,
    MoodType.exhausted,
  ];

  void _submit() {
    if (_selectedMood == null) return;

    final entry = MoodEntry(
      id: const Uuid().v4(),
      timestamp: DateTime.now(),
      mood: _selectedMood!,
      sleepHours: _sleepHours,
      waterGlasses: _waterGlasses,
      exercised: _exercised,
      screenTimeHours: _screenTimeHours,
      stressLevel: _stressLevel,
      energyLevel: _energyLevel,
      socialInteraction: _socialInteraction,
    );

    ref.read(moodProvider.notifier).logMood(entry);
    ref.read(userProfileProvider.notifier).addXp(20);

    context.pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Text('✅ Mood logged! +20 XP earned 🌟'),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Daily Check-In'),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => context.pop(),
        ),
        actions: [
          if (_page == 0 && _selectedMood != null)
            TextButton(
              onPressed: () => setState(() => _page = 1),
              child: const Text('Next →', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w700)),
            ),
          if (_page == 1)
            TextButton(
              onPressed: _submit,
              child: const Text('Done ✓', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w700, color: AppColors.success)),
            ),
        ],
      ),
      body: _page == 0 ? _buildMoodPage(isDark) : _buildTrackersPage(isDark),
    );
  }

  Widget _buildMoodPage(bool isDark) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        children: [
          // Progress indicator
          Row(
            children: [
              _StepDot(active: true, done: false),
              Expanded(child: Container(height: 2, color: isDark ? Colors.white10 : Colors.grey.shade200)),
              _StepDot(active: false, done: false),
            ],
          ),
          const SizedBox(height: 32),

          Text(
            'How are you feeling\nright now?',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textPrimary,
              height: 1.2,
            ),
          ).animate().fadeIn().slideY(begin: 0.3),

          const SizedBox(height: 8),

          Text(
            'Be honest — this is your safe space.',
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              color: isDark ? Colors.white60 : AppColors.textMuted,
            ),
          ).animate(delay: 100.ms).fadeIn(),

          const SizedBox(height: 48),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _moods.map((mood) {
              final isSelected = _selectedMood == mood;
              return GestureDetector(
                onTap: () => setState(() => _selectedMood = mood),
                child: AnimatedScale(
                  duration: const Duration(milliseconds: 200),
                  scale: isSelected ? 1.2 : 1.0,
                  child: Column(
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isSelected ? mood.color.withOpacity(0.15) : Colors.transparent,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected ? mood.color : Colors.transparent,
                            width: 2,
                          ),
                        ),
                        child: Text(
                          mood.emoji,
                          style: const TextStyle(fontSize: 36),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        mood.label,
                        style: TextStyle(
                          fontFamily: 'Outfit',
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                          color: isSelected ? mood.color : AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ).animate(delay: 200.ms).fadeIn(),

          if (_selectedMood != null) ...[
            const SizedBox(height: 40),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _selectedMood!.color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _selectedMood!.color.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Text(_selectedMood!.emoji, style: const TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _getMoodResponse(_selectedMood!),
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14,
                        color: isDark ? Color(0xCCFFFFFF) : AppColors.textPrimary,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn().slideY(begin: 0.2),
          ],

          const Spacer(),

          if (_selectedMood != null)
            ElevatedButton(
              onPressed: () => setState(() => _page = 1),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 52),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Continue to Health Trackers →'),
            ).animate().fadeIn().slideY(begin: 0.2),
        ],
      ),
    );
  }

  Widget _buildTrackersPage(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              _StepDot(active: true, done: true),
              Expanded(child: Container(height: 2, color: AppColors.primary)),
              _StepDot(active: true, done: false),
            ],
          ),

          const SizedBox(height: 28),

          Text(
            'Track Your Wellness',
            style: TextStyle(
              fontFamily: 'Outfit',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: isDark ? Colors.white : AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'How did your body and mind do today?',
            style: TextStyle(fontFamily: 'Nunito', fontSize: 14, color: isDark ? Colors.white60 : AppColors.textMuted),
          ),

          const SizedBox(height: 24),

          _SliderTracker(
            emoji: '😴',
            label: 'Sleep',
            value: _sleepHours.toDouble(),
            min: 0, max: 12, divisions: 12,
            suffix: 'hrs',
            color: AppColors.sleep,
            onChanged: (v) => setState(() => _sleepHours = v.toInt()),
          ),

          _SliderTracker(
            emoji: '💧',
            label: 'Water intake',
            value: _waterGlasses.toDouble(),
            min: 0, max: 12, divisions: 12,
            suffix: 'glasses',
            color: AppColors.primaryLight,
            onChanged: (v) => setState(() => _waterGlasses = v.toInt()),
          ),

          _SliderTracker(
            emoji: '📱',
            label: 'Screen time',
            value: _screenTimeHours.toDouble(),
            min: 0, max: 16, divisions: 16,
            suffix: 'hrs',
            color: AppColors.error,
            onChanged: (v) => setState(() => _screenTimeHours = v.toInt()),
          ),

          _SliderTracker(
            emoji: '⚡',
            label: 'Stress level',
            value: _stressLevel.toDouble(),
            min: 1, max: 10, divisions: 9,
            suffix: '/10',
            color: _stressLevel >= 7 ? AppColors.error : _stressLevel >= 4 ? AppColors.warning : AppColors.success,
            onChanged: (v) => setState(() => _stressLevel = v.toInt()),
          ),

          _SliderTracker(
            emoji: '🔋',
            label: 'Energy level',
            value: _energyLevel.toDouble(),
            min: 1, max: 10, divisions: 9,
            suffix: '/10',
            color: AppColors.secondary,
            onChanged: (v) => setState(() => _energyLevel = v.toInt()),
          ),

          const SizedBox(height: 8),

          // Toggle rows
          _ToggleRow(
            emoji: '🏃',
            label: 'Did you exercise today?',
            value: _exercised,
            onChanged: (v) => setState(() => _exercised = v),
            color: AppColors.body,
          ),

          _ToggleRow(
            emoji: '🤝',
            label: 'Did you socialize today?',
            value: _socialInteraction,
            onChanged: (v) => setState(() => _socialInteraction = v),
            color: AppColors.primaryLight,
          ),

          const SizedBox(height: 32),

          ElevatedButton(
            onPressed: _submit,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 52),
              backgroundColor: AppColors.success,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Save Check-In', style: TextStyle(fontFamily: 'Outfit', fontSize: 16, fontWeight: FontWeight.w700)),
                SizedBox(width: 8),
                Text('✓ +20 XP', style: TextStyle(fontFamily: 'Outfit', fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white70)),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _getMoodResponse(MoodType mood) {
    switch (mood) {
      case MoodType.happy: return 'Amazing! That positive energy is infectious! 🌟 Let\'s make the most of this great day.';
      case MoodType.good: return 'That\'s a solid foundation to build on today! 💚 Small wins add up.';
      case MoodType.neutral: return 'That\'s totally okay. Neutral days are part of the journey. 🌿 Let\'s see what we can do to add a little spark.';
      case MoodType.stressed: return 'I see you, and I\'m here. 💙 Stress is hard, but you\'re not alone. Let\'s work through this together.';
      case MoodType.exhausted: return 'Thank you for showing up anyway — that takes courage. 💜 Rest is healing. You\'re doing better than you think.';
    }
  }
}

class _StepDot extends StatelessWidget {
  final bool active;
  final bool done;
  const _StepDot({required this.active, required this.done});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20, height: 20,
      decoration: BoxDecoration(
        color: done ? AppColors.success : active ? AppColors.primary : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: done ? const Icon(Icons.check, size: 12, color: Colors.white) : null,
    );
  }
}

class _SliderTracker extends StatelessWidget {
  final String emoji;
  final String label;
  final double value;
  final double min;
  final double max;
  final int divisions;
  final String suffix;
  final Color color;
  final ValueChanged<double> onChanged;

  const _SliderTracker({
    required this.emoji,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.divisions,
    required this.suffix,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontFamily: 'Outfit',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                '${value.toInt()}$suffix',
                style: TextStyle(
                  fontFamily: 'Outfit',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: color,
              thumbColor: color,
              overlayColor: color.withOpacity(0.15),
              trackHeight: 4,
            ),
            child: Slider(
              value: value,
              min: min,
              max: max,
              divisions: divisions,
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}

class _ToggleRow extends StatelessWidget {
  final String emoji;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Color color;

  const _ToggleRow({
    required this.emoji,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 22)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'Outfit',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isDark ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: color,
          ),
        ],
      ),
    );
  }
}

