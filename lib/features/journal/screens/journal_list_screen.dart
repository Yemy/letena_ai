import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:uuid/uuid.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../models/content_models.dart';
import '../../../providers/content_providers.dart';
import '../../../providers/user_provider.dart';

class JournalListScreen extends ConsumerWidget {
  const JournalListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final journals = ref.watch(journalProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        title: const Text('My Journal'),
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/journal/new'),
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add_rounded, color: Colors.white),
        label: const Text('New Entry', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w600, color: Colors.white)),
      ),
      body: journals.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('📝', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  Text('Start Your First Entry', style: TextStyle(fontFamily: 'Outfit', fontSize: 20, fontWeight: FontWeight.w700, color: isDark ? Colors.white : AppColors.textPrimary)),
                  const SizedBox(height: 8),
                  const Text('Journaling reduces stress and builds self-awareness.', textAlign: TextAlign.center, style: TextStyle(fontFamily: 'Nunito', fontSize: 14, color: AppColors.textMuted)),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.screenPadding),
              itemCount: journals.length,
              itemBuilder: (ctx, i) {
                final entry = journals[i];
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          if (entry.isVoice) const Icon(Icons.mic_rounded, size: 16, color: AppColors.primary),
                          if (entry.isVoice) const SizedBox(width: 6),
                          Text(
                            '${entry.timestamp.day}/${entry.timestamp.month}/${entry.timestamp.year}',
                            style: const TextStyle(fontFamily: 'Outfit', fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                          ),
                          const Spacer(),
                          if (entry.moodTag != null)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(color: AppColors.accent.withOpacity(0.3), borderRadius: BorderRadius.circular(100)),
                              child: Text(entry.moodTag!, style: const TextStyle(fontFamily: 'Outfit', fontSize: 10, fontWeight: FontWeight.w600, color: AppColors.primaryDark)),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      if (entry.prompt != null)
                        Text('💭 ${entry.prompt!}', style: const TextStyle(fontFamily: 'Outfit', fontSize: 12, fontStyle: FontStyle.italic, color: AppColors.textMuted)),
                      const SizedBox(height: 4),
                      Text(
                        entry.content,
                        style: TextStyle(fontFamily: 'Nunito', fontSize: 14, color: isDark ? Colors.white.withOpacity(0.85) : AppColors.textPrimary, height: 1.5),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ).animate(delay: Duration(milliseconds: i * 80)).fadeIn().slideY(begin: 0.1);
              },
            ),
    );
  }
}

class JournalEntryScreen extends ConsumerStatefulWidget {
  const JournalEntryScreen({super.key});

  @override
  ConsumerState<JournalEntryScreen> createState() => _JournalEntryScreenState();
}

class _JournalEntryScreenState extends ConsumerState<JournalEntryScreen> {
  final _controller = TextEditingController();
  final String _prompt = JournalEntry.randomPrompt;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (_controller.text.trim().isEmpty) return;

    final entry = JournalEntry(
      id: const Uuid().v4(),
      timestamp: DateTime.now(),
      content: _controller.text.trim(),
      prompt: _prompt,
    );

    ref.read(journalProvider.notifier).addEntry(entry);
    ref.read(userProfileProvider.notifier).addXp(25);

    context.pop();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('✍️ Entry saved! +25 XP 🌟'),
        backgroundColor: AppColors.primary,
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
        title: const Text('New Entry'),
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
        actions: [
          TextButton(
            onPressed: _save,
            child: const Text('Save', style: TextStyle(fontFamily: 'Outfit', fontWeight: FontWeight.w700)),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.screenPadding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Prompt Card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Text('💭', style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      _prompt,
                      style: const TextStyle(fontFamily: 'Nunito', fontSize: 14, fontStyle: FontStyle.italic, color: Colors.white, height: 1.4),
                    ),
                  ),
                ],
              ),
            ).animate().fadeIn(),

            const SizedBox(height: 20),

            // Text field
            Expanded(
              child: TextField(
                controller: _controller,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: 'Start writing... there are no wrong answers.',
                  hintStyle: const TextStyle(fontFamily: 'Nunito', color: AppColors.textMuted, fontSize: 15),
                  filled: true,
                  fillColor: isDark ? AppColors.cardDark : Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
                  contentPadding: const EdgeInsets.all(16),
                ),
                style: TextStyle(fontFamily: 'Nunito', fontSize: 15, color: isDark ? Colors.white : AppColors.textPrimary, height: 1.6),
                autofocus: true,
              ),
            ).animate(delay: 100.ms).fadeIn(),

            const SizedBox(height: 16),

            // Voice journal button
            OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.mic_rounded),
              label: const Text('Record Voice Journal'),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

