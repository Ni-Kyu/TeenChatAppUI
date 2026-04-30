// lib/screens/feed_screen.dart
//
// Displays all community posts with like/favorite/comment actions.
// Post display name is resolved live from UserProfile when isUserPost == true,
// so username changes are instantly reflected on all posts without re-saving.

import 'package:flutter/material.dart';
import '../theme/frutiger_aero_theme.dart';
import '../models/post.dart';
import '../models/user_profile.dart';
import '../widgets/bounce_button.dart';

class FeedScreen extends StatefulWidget {
  final List<Post> posts;
  final UserProfile userProfile;
  final Function(Post) onLike;
  final Function(Post) onFavorite;
  final Function(Post, String) onComment;

  const FeedScreen({
    super.key,
    required this.posts,
    required this.userProfile,
    required this.onLike,
    required this.onFavorite,
    required this.onComment,
  });

  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Title bar
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Feed', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: FrutigerAeroTheme.textDark)),
                const SizedBox(height: 4),
                Text('See what others are sharing', style: TextStyle(fontSize: 14, color: FrutigerAeroTheme.textLight)),
              ],
            ),
          ),
        ),

        // Community rules banner
        SliverToBoxAdapter(
          child: Container(
            margin: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 16),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                FrutigerAeroTheme.skyBlue.withValues(alpha: 0.2),
                FrutigerAeroTheme.oceanBlue.withValues(alpha: 0.1),
              ]),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: FrutigerAeroTheme.skyBlue.withValues(alpha: 0.5)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.rule, color: FrutigerAeroTheme.oceanBlue),
                    SizedBox(width: 8),
                    Text('Community Rules', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: FrutigerAeroTheme.textDark)),
                  ],
                ),
                const SizedBox(height: 12),
                _rule('• Be kind and supportive'),
                _rule("• Don't say hurtful things or harass people"),
                _rule('• Respect privacy and anonymity'),
                _rule('• No spam or self-promotion'),
              ],
            ),
          ),
        ),

        // Posts list
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) => _buildPostCard(widget.posts[index]),
              childCount: widget.posts.length,
            ),
          ),
        ),
        const SliverPadding(padding: EdgeInsets.only(bottom: 120)),
      ],
    );
  }

  Widget _rule(String text) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Text(text, style: TextStyle(fontSize: 13, color: FrutigerAeroTheme.textMid)),
  );

  // ── Post card ──────────────────────────────────────────────────────────────

  Widget _buildPostCard(Post post) {
    // Resolve the author name live: user's own posts always show the
    // current username so renames propagate without touching stored data.
    final displayName = post.isUserPost
        ? widget.userProfile.username
        : (post.anonymousName ?? 'Anonymous');
    final avatarLetter = displayName.isNotEmpty ? displayName[0].toUpperCase() : 'A';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: FrutigerAeroTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author row
          Row(
            children: [
              _avatarBubble(avatarLetter, size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(displayName, style: const TextStyle(fontWeight: FontWeight.bold, color: FrutigerAeroTheme.textDark)),
                    Text(_formatTime(post.timestamp), style: TextStyle(fontSize: 12, color: FrutigerAeroTheme.textLight)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Content
          Text(post.title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: FrutigerAeroTheme.textDark)),
          const SizedBox(height: 8),
          Text(post.content, style: const TextStyle(fontSize: 14, color: FrutigerAeroTheme.textMid, height: 1.5)),
          const SizedBox(height: 12),

          // Tags
          if (post.tags.isNotEmpty)
            Wrap(
              spacing: 8,
              children: post.tags.map((tag) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: FrutigerAeroTheme.skyBlue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text('#$tag', style: const TextStyle(fontSize: 12, color: FrutigerAeroTheme.oceanBlue)),
              )).toList(),
            ),
          const SizedBox(height: 12),

          // Action bar
          Row(
            children: [
              BounceButton(
                onTap: () => widget.onLike(post),
                child: Row(
                  children: [
                    Icon(post.isLikedByMe ? Icons.favorite : Icons.favorite_border,
                      size: 20,
                      color: post.isLikedByMe ? FrutigerAeroTheme.danger : FrutigerAeroTheme.textMid),
                    const SizedBox(width: 4),
                    Text('${post.likes}', style: TextStyle(fontSize: 13, color: FrutigerAeroTheme.textMid)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              BounceButton(
                onTap: () => widget.onFavorite(post),
                child: Row(
                  children: [
                    Icon(post.isFavoritedByMe ? Icons.star : Icons.star_border,
                      size: 20,
                      color: post.isFavoritedByMe ? FrutigerAeroTheme.warning : FrutigerAeroTheme.textMid),
                    const SizedBox(width: 4),
                    Text('${post.favorites}', style: TextStyle(fontSize: 13, color: FrutigerAeroTheme.textMid)),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              GestureDetector(
                onTap: () => _showCommentDialog(post),
                child: Row(
                  children: [
                    Icon(Icons.chat_bubble_outline, size: 20, color: FrutigerAeroTheme.textMid),
                    const SizedBox(width: 4),
                    Text('${post.comments.length}', style: TextStyle(fontSize: 13, color: FrutigerAeroTheme.textMid)),
                  ],
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: _showShareDialog,
                child: Row(
                  children: [
                    Icon(Icons.share, size: 20, color: FrutigerAeroTheme.textMid),
                    const SizedBox(width: 4),
                    const Text('Share', style: TextStyle(fontSize: 13, color: FrutigerAeroTheme.textMid)),
                  ],
                ),
              ),
            ],
          ),

          // Comments
          if (post.comments.isNotEmpty) ...[
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),
            ...post.comments.map(_buildComment),
          ],
        ],
      ),
    );
  }

  Widget _buildComment(comment) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _avatarBubble(
            comment.authorName.isNotEmpty ? comment.authorName[0].toUpperCase() : 'A',
            size: 28,
            fontSize: 12,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(comment.authorName, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: FrutigerAeroTheme.textDark)),
                Text(comment.content, style: TextStyle(fontSize: 13, color: FrutigerAeroTheme.textMid)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Dialogs ────────────────────────────────────────────────────────────────

  void _showCommentDialog(Post post) {
    final commentController = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Add Comment', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: FrutigerAeroTheme.textDark)),
              const SizedBox(height: 16),
              Row(
                children: [
                  _avatarBubble(
                    widget.userProfile.username.isNotEmpty ? widget.userProfile.username[0].toUpperCase() : 'U',
                    size: 40,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: commentController,
                      decoration: InputDecoration(
                        hintText: 'Comment...',
                        hintStyle: TextStyle(color: FrutigerAeroTheme.textLight),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: FrutigerAeroTheme.skyBlue.withValues(alpha: 0.5)),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: Container(
                  decoration: BoxDecoration(gradient: FrutigerAeroTheme.buttonGradient, borderRadius: BorderRadius.circular(12)),
                  child: ElevatedButton(
                    onPressed: () {
                      if (commentController.text.trim().isNotEmpty) {
                        widget.onComment(post, commentController.text.trim());
                        Navigator.pop(ctx);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Post Comment', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showShareDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: FrutigerAeroTheme.oceanBlue),
            SizedBox(width: 12),
            Text('Share'),
          ],
        ),
        content: const Text("Whoops! You can't share these posts as this is just the demo!"),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(backgroundColor: FrutigerAeroTheme.oceanBlue),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _avatarBubble(String letter, {required double size, double fontSize = 16}) {
    return Container(
      width: size, height: size,
      decoration: BoxDecoration(
        gradient: FrutigerAeroTheme.accentGradient,
        borderRadius: BorderRadius.circular(size / 2),
      ),
      child: Center(child: Text(letter, style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: fontSize))),
    );
  }

  String _formatTime(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24)   return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
