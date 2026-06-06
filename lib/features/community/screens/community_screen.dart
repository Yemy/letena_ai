import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_spacing.dart';
import '../../../models/content_models.dart';
import '../../../providers/content_providers.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  const CommunityScreen({super.key});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen> {
  final _communities = ['All', 'Developers', 'Students', 'Entrepreneurs', 'Healthcare', 'Parents', 'Teachers'];
  String _selected = 'All';

  @override
  Widget build(BuildContext context) {
    final posts = ref.watch(communityProvider);
    final filteredPosts = _selected == 'All' ? posts : posts.where((p) => p.community == _selected).toList();
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
      appBar: AppBar(
        title: const Text('Community'),
        backgroundColor: isDark ? AppColors.bgDark : AppColors.bgLight,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit_rounded),
            color: AppColors.primary,
            onPressed: () => _showPostComposer(context),
          ),
        ],
      ),
      body: Column(
        children: [
          // Community filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: _communities.map((c) {
                final isSelected = _selected == c;
                return GestureDetector(
                  onTap: () => setState(() => _selected = c),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: isSelected ? AppColors.primaryGradient : null,
                      color: isSelected ? null : (isDark ? AppColors.cardDark : Colors.white),
                      borderRadius: BorderRadius.circular(100),
                      border: isSelected ? null : Border.all(color: AppColors.primary.withOpacity(0.2)),
                    ),
                    child: Text(
                      c,
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : AppColors.textSecondary,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Posts
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: filteredPosts.length,
              itemBuilder: (ctx, i) {
                return _PostCard(post: filteredPosts[i], isDark: isDark)
                    .animate(key: ValueKey('${filteredPosts[i].id}_$i'))
                    .fadeIn(duration: 400.ms, delay: Duration(milliseconds: i * 80))
                    .slideY(begin: 0.1);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showPostComposer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _PostComposer(),
    );
  }
}

class _PostCard extends StatefulWidget {
  final CommunityPost post;
  final bool isDark;

  const _PostCard({required this.post, required this.isDark});

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  bool _liked = false;
  int _likes = 0;

  @override
  void initState() {
    super.initState();
    _likes = widget.post.likes;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: widget.isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: widget.post.isPinned ? Border.all(color: AppColors.secondary.withOpacity(0.5), width: 1.5) : null,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(gradient: AppColors.primaryGradient, shape: BoxShape.circle),
                child: Center(
                  child: Text(
                    widget.post.authorInitials,
                    style: const TextStyle(fontFamily: 'Outfit', fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Anonymous ${widget.post.community}',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: widget.isDark ? Colors.white : AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      _timeAgo(widget.post.timestamp),
                      style: const TextStyle(fontFamily: 'Nunito', fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
              ),
              if (widget.post.isPinned)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(color: AppColors.secondary.withOpacity(0.2), borderRadius: BorderRadius.circular(100)),
                  child: const Text('📌 Pinned', style: TextStyle(fontFamily: 'Outfit', fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.secondary)),
                ),
            ],
          ),

          const SizedBox(height: 12),

          // Content
          Text(
            widget.post.content,
            style: TextStyle(
              fontFamily: 'Nunito',
              fontSize: 14,
              color: widget.isDark ? Colors.white.withOpacity(0.9) : AppColors.textPrimary,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 14),

          // Actions
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() {
                  _liked = !_liked;
                  _likes += _liked ? 1 : -1;
                }),
                child: Row(
                  children: [
                    Icon(
                      _liked ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                      size: 20,
                      color: _liked ? AppColors.error : AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '$_likes',
                      style: TextStyle(
                        fontFamily: 'Outfit',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _liked ? AppColors.error : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              const Icon(Icons.chat_bubble_outline_rounded, size: 18, color: AppColors.textMuted),
              const SizedBox(width: 4),
              Text(
                '${widget.post.comments}',
                style: const TextStyle(fontFamily: 'Outfit', fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.textMuted),
              ),
              const Spacer(),
              const Text('💚', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 4),
              const Text('🌱', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 4),
              const Text('💪', style: TextStyle(fontSize: 16)),
            ],
          ),
        ],
      ),
    );
  }

  String _timeAgo(DateTime dt) {
    final diff = DateTime.now().difference(dt);
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    return '${diff.inMinutes}m ago';
  }
}

class _PostComposer extends StatefulWidget {
  const _PostComposer();

  @override
  State<_PostComposer> createState() => _PostComposerState();
}

class _PostComposerState extends State<_PostComposer> {
  final _controller = TextEditingController();
  String _selectedGroup = 'General';

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        left: 24, right: 24, top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade300, borderRadius: BorderRadius.circular(100))),
          ),
          const SizedBox(height: 20),
          const Text('Share with the Community 🌍', style: TextStyle(fontFamily: 'Outfit', fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          const Text('Your post is anonymous. Be kind and supportive.', style: TextStyle(fontFamily: 'Nunito', fontSize: 13, color: AppColors.textMuted)),
          const SizedBox(height: 16),
          TextField(
            controller: _controller,
            maxLines: 5,
            maxLength: 280,
            decoration: const InputDecoration(
              hintText: 'Share your experience, encouragement, or question...',
              border: InputBorder.none,
            ),
            autofocus: true,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('✅ Post shared! Your voice matters 💚'),
                      backgroundColor: AppColors.success,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(120, 44),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                ),
                child: const Text('Post'),
              ),
              const SizedBox(width: 12),
              OutlinedButton(
                onPressed: () => context.pop(),
                style: OutlinedButton.styleFrom(minimumSize: const Size(80, 44), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100))),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

