import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../providers/user_provider.dart';
import '../../../providers/content_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProfileProvider);
    final isDark = ref.watch(isDarkModeProvider);
    final lang = ref.watch(languageProvider);

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        children: [
          // Appearance
          _SectionHeader('Appearance'),
          _SettingsTile(
            icon: Icons.dark_mode_rounded,
            label: 'Dark Mode',
            trailing: Switch(
              value: isDark,
              onChanged: (v) {
                ref.read(isDarkModeProvider.notifier).state = v;
                ref.read(userProfileProvider.notifier).toggleDarkMode();
              },
              activeColor: AppColors.primary,
            ),
            isDark: isDark,
          ),

          const SizedBox(height: AppSpacing.lg),

          // Language
          _SectionHeader('Language'),
          _SettingsTile(
            icon: Icons.language_rounded,
            label: 'App Language',
            trailing: DropdownButton<String>(
              value: lang,
              underline: const SizedBox(),
              items: const [
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'am', child: Text('አማርኛ')),
                DropdownMenuItem(value: 'ti', child: Text('ትግርኛ')),
              ],
              onChanged: (v) {
                if (v != null) {
                  ref.read(languageProvider.notifier).state = v;
                  ref.read(userProfileProvider.notifier).setLanguage(v);
                }
              },
            ),
            isDark: isDark,
          ),

          const SizedBox(height: AppSpacing.lg),

          // Notifications
          _SectionHeader('Notifications'),
          _SettingsTile(
            icon: Icons.notifications_rounded,
            label: 'Daily Reminders',
            trailing: Switch(
              value: user.notificationsEnabled,
              onChanged: (v) {},
              activeColor: AppColors.primary,
            ),
            isDark: isDark,
          ),
          _SettingsTile(
            icon: Icons.access_time_rounded,
            label: 'Check-In Reminder',
            subtitle: '8:00 AM daily',
            isDark: isDark,
          ),
          _SettingsTile(
            icon: Icons.bedtime_rounded,
            label: 'Bedtime Reminder',
            subtitle: '9:30 PM daily',
            isDark: isDark,
          ),

          const SizedBox(height: AppSpacing.lg),

          // Wellness Goals
          _SectionHeader('Wellness Goals'),
          _SettingsTile(
            icon: Icons.local_drink_rounded,
            label: 'Daily Water Goal',
            subtitle: '8 glasses',
            isDark: isDark,
          ),
          _SettingsTile(
            icon: Icons.bedtime_rounded,
            label: 'Sleep Goal',
            subtitle: '8 hours',
            isDark: isDark,
          ),
          _SettingsTile(
            icon: Icons.directions_run_rounded,
            label: 'Exercise Goal',
            subtitle: '30 minutes daily',
            isDark: isDark,
          ),

          const SizedBox(height: AppSpacing.lg),

          // Account
          _SectionHeader('Account'),
          _SettingsTile(
            icon: Icons.person_rounded,
            label: 'Edit Profile',
            isDark: isDark,
          ),
          _SettingsTile(
            icon: Icons.shield_rounded,
            label: 'Privacy Policy',
            isDark: isDark,
          ),
          _SettingsTile(
            icon: Icons.help_rounded,
            label: 'Help & Support',
            isDark: isDark,
          ),

          const SizedBox(height: AppSpacing.lg),

          // Reset
          Center(
            child: TextButton.icon(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    title: const Text('Reset Onboarding?'),
                    content: const Text('This will take you back to the welcome screen.'),
                    actions: [
                      TextButton(onPressed: () => ctx.pop(), child: const Text('Cancel')),
                      ElevatedButton(
                        onPressed: () {
                          ctx.pop();
                          context.go('/splash');
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
                        child: const Text('Reset'),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.refresh_rounded, color: AppColors.error),
              label: const Text('Reset Onboarding', style: TextStyle(fontFamily: 'Outfit', color: AppColors.error, fontWeight: FontWeight.w600)),
            ),
          ),

          const SizedBox(height: 8),

          Center(
            child: Text(
              'SERENE AI v1.0.0\nMade with 💚 for Africa',
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, color: AppColors.textMuted),
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontFamily: 'Outfit',
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.textMuted,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? subtitle;
  final Widget? trailing;
  final bool isDark;

  const _SettingsTile({
    required this.icon,
    required this.label,
    this.subtitle,
    this.trailing,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        leading: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(color: AppColors.primary.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
          child: Icon(icon, color: AppColors.primary, size: 18),
        ),
        title: Text(label, style: TextStyle(fontFamily: 'Outfit', fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary)),
        subtitle: subtitle != null
            ? Text(subtitle!, style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, color: AppColors.textMuted))
            : null,
        trailing: trailing ?? const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
      ),
    );
  }
}

