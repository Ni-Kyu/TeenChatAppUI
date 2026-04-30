// lib/screens/profile_screen.dart
//
// "You" page showing the current user's profile, their posts, and favourites.

import 'package:flutter/material.dart';
import '../theme/frutiger_aero_theme.dart';
import '../models/post.dart';
import '../models/user_profile.dart';
import '../state/app_state.dart';
import '../widgets/logout_text.dart';

class ProfileScreen extends StatefulWidget {
  final UserProfile userProfile;
  final Function(String, String) onUpdateProfile;
  final List<Post> favoritePosts;

  const ProfileScreen({
    super.key,
    required this.userProfile,
    required this.onUpdateProfile,
    required this.favoritePosts,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userPosts = AppState.of(context).posts.where((p) => p.isUserPost).toList();

    return Column(
      children: [
        _buildProfileHeader(),
        _buildTabBar(),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildPostsTab(userPosts),
              _buildFavoritesTab(),
            ],
          ),
        ),
      ],
    );
  }

  // ── Profile header ─────────────────────────────────────────────────────────

  Widget _buildProfileHeader() {
    final username = widget.userProfile.username;
    final letter = username.isNotEmpty ? username[0].toUpperCase() : 'U';

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          Stack(
            children: [
              // Avatar
              Container(
                width: 80, height: 80,
                decoration: BoxDecoration(
                  gradient: FrutigerAeroTheme.accentGradient,
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Center(
                  child: Text(letter, style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.bold)),
                ),
              ),
              // Edit button
              Positioned(
                bottom: 0, right: 0,
                child: GestureDetector(
                  onTap: _showEditDialog,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(color: FrutigerAeroTheme.oceanBlue, borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.edit, color: Colors.white, size: 16),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(username, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: FrutigerAeroTheme.textDark)),
          const SizedBox(height: 8),
          Text(widget.userProfile.bio,
            style: const TextStyle(fontSize: 14, color: FrutigerAeroTheme.textMid),
            textAlign: TextAlign.center),
          const SizedBox(height: 16),
          const LogOutText(),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: FrutigerAeroTheme.midBlue.withValues(alpha: 0.1), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: FrutigerAeroTheme.oceanBlue,
        unselectedLabelColor: FrutigerAeroTheme.textLight,
        indicatorColor: FrutigerAeroTheme.oceanBlue,
        tabs: const [Tab(text: 'Posts'), Tab(text: 'Favorites')],
      ),
    );
  }

  // ── Posts tab ──────────────────────────────────────────────────────────────

  Widget _buildPostsTab(List<Post> posts) {
    if (posts.isEmpty) {
      return _emptyState(icon: Icons.post_add, title: 'No posts yet', subtitle: 'Create a post to see it here!');
    }
    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
      itemCount: posts.length,
      itemBuilder: (_, i) => _buildPostItem(posts[i]),
    );
  }

  // ── Favourites tab ─────────────────────────────────────────────────────────

  Widget _buildFavoritesTab() {
    if (widget.favoritePosts.isEmpty) {
      return _emptyState(icon: Icons.star_border, title: 'No favorites yet', subtitle: 'Star posts to add them here!');
    }
    return ListView.builder(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 120),
      itemCount: widget.favoritePosts.length,
      itemBuilder: (_, i) => _buildPostItem(widget.favoritePosts[i]),
    );
  }

  Widget _buildPostItem(Post post) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: FrutigerAeroTheme.cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(post.title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: FrutigerAeroTheme.textDark)),
          const SizedBox(height: 8),
          Text(post.content,
            style: const TextStyle(fontSize: 13, color: FrutigerAeroTheme.textMid),
            maxLines: 2, overflow: TextOverflow.ellipsis),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.favorite, size: 16, color: FrutigerAeroTheme.danger),
              const SizedBox(width: 4),
              Text('${post.likes}', style: const TextStyle(fontSize: 12, color: FrutigerAeroTheme.textLight)),
              const SizedBox(width: 16),
              Icon(Icons.star, size: 16, color: FrutigerAeroTheme.warning),
              const SizedBox(width: 4),
              Text('${post.favorites}', style: const TextStyle(fontSize: 12, color: FrutigerAeroTheme.textLight)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Edit profile dialog ────────────────────────────────────────────────────

  void _showEditDialog() {
    final usernameController = TextEditingController(text: widget.userProfile.username);
    final bioController      = TextEditingController(text: widget.userProfile.bio);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.edit, color: FrutigerAeroTheme.oceanBlue),
            SizedBox(width: 12),
            Text('Edit Profile'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _editField(controller: usernameController, label: 'Username'),
            const SizedBox(height: 16),
            _editField(controller: bioController, label: 'Bio', maxLines: 2),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              widget.onUpdateProfile(
                usernameController.text.trim(),
                bioController.text.trim(),
              );
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: FrutigerAeroTheme.oceanBlue),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  // ── Helpers ────────────────────────────────────────────────────────────────

  Widget _emptyState({required IconData icon, required String title, required String subtitle}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 120),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 64, color: FrutigerAeroTheme.skyBlue.withValues(alpha: 0.5)),
            const SizedBox(height: 16),
            Text(title, style: const TextStyle(fontSize: 16, color: FrutigerAeroTheme.textLight)),
            const SizedBox(height: 8),
            Text(subtitle, style: const TextStyle(fontSize: 14, color: FrutigerAeroTheme.textLight)),
          ],
        ),
      ),
    );
  }

  Widget _editField({required TextEditingController controller, required String label, int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: FrutigerAeroTheme.textLight),
        filled: true,
        fillColor: FrutigerAeroTheme.gradientLight,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      ),
    );
  }
}
