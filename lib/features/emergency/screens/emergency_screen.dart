import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';

class EmergencyScreen extends StatelessWidget {
  const EmergencyScreen({super.key});

  final _hotlines = const [
    ('Ethiopia Mental Health Line', '+251 11 516 7733', '🇪🇹', 'Mental health support'),
    ('Sidama Mental Health', '+251 46 220 9900', '🇪🇹', 'Crisis support'),
    ('Africa Mental Health', '+1 800 950 6264', '🌍', 'Pan-African support'),
    ('WHO Africa Support', '+41 22 791 2111', '🏥', 'WHO regional office'),
  ];

  final _resources = const [
    ('Breathing Emergency', '💨', 'Instant 4-7-8 breathing for panic attacks', AppColors.sleepGradient),
    ('Grounding Technique', '🌿', '5-4-3-2-1 sensory grounding method', AppColors.bodyGradient),
    ('Crisis Journaling', '✍️', 'Write out your thoughts safely', AppColors.primaryGradient),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        title: const Text('You Are Not Alone'),
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SOS Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFC0392B), Color(0xFFE74C3C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const Text('🆘', style: TextStyle(fontSize: 52)),
                  const SizedBox(height: 12),
                  const Text(
                    'You Are Not Alone',
                    style: TextStyle(fontFamily: 'Outfit', fontSize: 24, fontWeight: FontWeight.w800, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Whatever you\'re going through right now — it will pass. You matter, and help is available.',
                    style: TextStyle(fontFamily: 'Nunito', fontSize: 14, color: Color(0xCCFFFFFF), height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () async {
                      final uri = Uri.parse('tel:+251115167733');
                      if (await canLaunchUrl(uri)) launchUrl(uri);
                    },
                    icon: const Icon(Icons.phone_rounded, size: 20),
                    label: const Text('Call Emergency Hotline'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.error,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    ),
                  ),
                ],
              ),
            ).animate().scale(duration: 500.ms, curve: Curves.elasticOut),

            const SizedBox(height: AppSpacing.sectionSpacing),

            // Immediate help resources
            Text(
              'Immediate Help',
              style: TextStyle(fontFamily: 'Outfit', fontSize: 17, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            ..._resources.asMap().entries.map((entry) {
              final i = entry.key;
              final (title, emoji, desc, gradient) = entry.value;
              return GestureDetector(
                onTap: () {}, // would open exercise
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(gradient: gradient, borderRadius: BorderRadius.circular(14)),
                        child: Center(child: Text(emoji, style: const TextStyle(fontSize: 22))),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(title, style: TextStyle(fontFamily: 'Outfit', fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary)),
                            Text(desc, style: const TextStyle(fontFamily: 'Nunito', fontSize: 12, color: AppColors.textMuted)),
                          ],
                        ),
                      ),
                      const Icon(Icons.arrow_forward_ios_rounded, size: 14, color: AppColors.textMuted),
                    ],
                  ),
                ),
              ).animate(delay: Duration(milliseconds: i * 100)).fadeIn().slideX(begin: 0.1);
            }),

            const SizedBox(height: AppSpacing.sectionSpacing),

            // Hotlines
            Text(
              'Mental Health Hotlines',
              style: TextStyle(fontFamily: 'Outfit', fontSize: 17, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.textPrimary),
            ),
            const SizedBox(height: 12),

            ..._hotlines.asMap().entries.map((entry) {
              final i = entry.key;
              final (name, number, flag, desc) = entry.value;
              return Container(
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.cardDark : Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primary.withOpacity(0.15)),
                ),
                child: Row(
                  children: [
                    Text(flag, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(name, style: TextStyle(fontFamily: 'Outfit', fontSize: 14, fontWeight: FontWeight.w600, color: isDark ? Colors.white : AppColors.textPrimary)),
                          Text(desc, style: const TextStyle(fontFamily: 'Nunito', fontSize: 11, color: AppColors.textMuted)),
                          Text(number, style: const TextStyle(fontFamily: 'Outfit', fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.primary)),
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: () async {
                        final uri = Uri.parse('tel:$number');
                        if (await canLaunchUrl(uri)) launchUrl(uri);
                      },
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: const BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
                        child: const Icon(Icons.phone_rounded, color: Colors.white, size: 18),
                      ),
                    ),
                  ],
                ),
              ).animate(delay: Duration(milliseconds: 200 + i * 80)).fadeIn();
            }),

            const SizedBox(height: AppSpacing.sectionSpacing),

            // Trusted contacts
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.secondary.withOpacity(0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Text('👥', style: TextStyle(fontSize: 24)),
                      SizedBox(width: 10),
                      Text('Trusted Contacts', style: TextStyle(fontFamily: 'Outfit', fontSize: 15, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Text('Add up to 3 people you trust — they can receive an alert if you press SOS.', style: TextStyle(fontFamily: 'Nunito', fontSize: 13, color: AppColors.textMuted, height: 1.4)),
                  const SizedBox(height: 12),
                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.person_add_rounded, size: 18),
                    label: const Text('Add Trusted Contact'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
}

