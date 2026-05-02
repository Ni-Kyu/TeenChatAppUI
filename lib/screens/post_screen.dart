// lib/screens/post_screen.dart
//
// Lets the user compose and publish a new post to the community feed.
// The username is read live from UserProfile at submit time so it always
// matches the current profile name.

import 'package:flutter/material.dart';
import '../theme/frutiger_aero_theme.dart';
import '../models/post.dart';
import '../models/user_profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PostScreen extends StatefulWidget {
  final Function(Post) onSubmit;
  final UserProfile userProfile;

  const PostScreen({
    super.key,
    required this.onSubmit,
    required this.userProfile,
  });

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<String> _selectedTags = [];

  // TODO: fetch available tags from the backend when ready.
  static const List<String> _availableTags = [
    'mental-health',
    'stress',
    'school',
    'friends',
    'family',
    'positivity',
    'support',
    'anxiety',
    'self-care',
    'motivation',
    'food',
    'thoughts',
    'weekend',
    'study',
    'tips',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 120),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Create Post',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: FrutigerAeroTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Share your thoughts with the community',
            style: TextStyle(fontSize: 14, color: FrutigerAeroTheme.textLight),
          ),
          const SizedBox(height: 24),

          // Title input
          _fieldCard(
            label: 'Title',
            child: TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: "What's your question or topic?",
                hintStyle: TextStyle(color: FrutigerAeroTheme.textLight),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(
                fontSize: 16,
                color: FrutigerAeroTheme.textDark,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Description input
          _fieldCard(
            label: 'Description',
            child: TextField(
              controller: _contentController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Share more details...',
                hintStyle: TextStyle(color: FrutigerAeroTheme.textLight),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              style: const TextStyle(
                fontSize: 16,
                color: FrutigerAeroTheme.textDark,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Tag picker
          _fieldCard(
            label: 'Add Tags',
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _availableTags.map(_buildTagChip).toList(),
            ),
          ),
          const SizedBox(height: 24),

          // Submit button
          SizedBox(
            width: double.infinity,
            child: Container(
              decoration: BoxDecoration(
                gradient: FrutigerAeroTheme.buttonGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: FrutigerAeroTheme.oceanBlue.withValues(alpha: 0.4),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: _submitPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'Post',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  /// Wraps a labelled input inside a glass-style card container.
  Widget _fieldCard({required String label, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: FrutigerAeroTheme.glassDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: FrutigerAeroTheme.textDark,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }

  Widget _buildTagChip(String tag) {
    final isSelected = _selectedTags.contains(tag);
    return GestureDetector(
      onTap: () => setState(() {
        isSelected ? _selectedTags.remove(tag) : _selectedTags.add(tag);
      }),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? FrutigerAeroTheme.buttonGradient : null,
          color: isSelected
              ? null
              : FrutigerAeroTheme.skyBlue.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : FrutigerAeroTheme.skyBlue.withValues(alpha: 0.5),
          ),
        ),
        child: Text(
          '#$tag',
          style: TextStyle(
            fontSize: 13,
            color: isSelected ? Colors.white : FrutigerAeroTheme.oceanBlue,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _submitPost() {
    if (_titleController.text.trim().isEmpty ||
        _contentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in both title and description'),
          backgroundColor: FrutigerAeroTheme.warning,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    // Use the live username so the post always matches the current profile.
    final post = Post(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      anonymousName: widget.userProfile.username,
      timestamp: DateTime.now(),
      tags: List.from(_selectedTags),
      isUserPost: true,
    );

    widget.onSubmit(post);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 12),
            const Text('Posted to feed!'),
          ],
        ),
        backgroundColor: FrutigerAeroTheme.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    _titleController.clear();
    _contentController.clear();
    setState(() => _selectedTags.clear());
  }
}