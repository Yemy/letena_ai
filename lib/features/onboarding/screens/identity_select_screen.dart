import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../providers/user_provider.dart';
import '../../../models/app_strings.dart';

class IdentitySelectScreen extends ConsumerStatefulWidget {
  const IdentitySelectScreen({super.key});

  @override
  ConsumerState<IdentitySelectScreen> createState() => _IdentitySelectScreenState();
}

class _IdentitySelectScreenState extends ConsumerState<IdentitySelectScreen> {
  String? _selected;

  final _identities = [
    ('Mindful Student', '📚', 'Build focus and manage academic stress'),
    ('Focused Professional', '💼', 'Prevent burnout and maintain work-life balance'),
    ('Balanced Entrepreneur', '🚀', 'Build resilience through business challenges'),
    ('Healthy Parent', '👨‍👩‍👧', 'Model wellness for your family'),
    ('Resilient Leader', '🌟', 'Lead with clarity and emotional intelligence'),
    ('Creative Soul', '🎨', 'Nurture your creativity and inner peace'),
    ('Wellness Explorer', '🌿', 'Discover what wellness means for you'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D4A4A), Color(0xFF1A6B6B)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
                child: Column(
                  children: [
                    const Text(
                      'Who Are You Becoming?',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ).animate().fadeIn(duration: 500.ms).slideY(begin: 0.3),

                    const SizedBox(height: 8),

                    Text(
                      'Choose the identity that resonates most with you right now.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'Nunito',
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.75),
                      ),
                    ).animate(delay: 200.ms).fadeIn(),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _identities.length,
                  itemBuilder: (ctx, i) {
                    final (name, emoji, desc) = _identities[i];
                    final isSelected = _selected == name;

                    return GestureDetector(
                      onTap: () => setState(() => _selected = name),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Colors.white
                              : Colors.white.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: isSelected ? AppColors.accentDeep : Colors.white.withOpacity(0.2),
                            width: isSelected ? 2 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Text(emoji, style: const TextStyle(fontSize: 28)),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    name,
                                    style: TextStyle(
                                      fontFamily: 'Outfit',
                                      fontSize: 16,
                                      fontWeight: FontWeight.w700,
                                      color: isSelected ? AppColors.primary : Colors.white,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    desc,
                                    style: TextStyle(
                                      fontFamily: 'Nunito',
                                      fontSize: 12,
                                      color: isSelected
                                          ? AppColors.textSecondary
                                          : Colors.white.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if (isSelected)
                              const Icon(Icons.check_circle_rounded, color: AppColors.accentDeep),
                          ],
                        ),
                      ),
                    ).animate(delay: Duration(milliseconds: 100 + i * 80)).fadeIn().slideX(begin: 0.2);
                  },
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(24),
                child: ElevatedButton(
                  onPressed: _selected == null
                      ? null
                      : () {
                          ref.read(userProfileProvider.notifier).setIdentity(_selected!);
                          context.go('/home');
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _selected != null ? AppColors.secondary : Colors.white24,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 54),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(
                    _selected != null ? 'I am a $_selected' : 'Select your identity',
                    style: const TextStyle(
                      fontFamily: 'Outfit',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

