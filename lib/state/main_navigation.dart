// lib/state/main_navigation.dart
//
// Root stateful widget that owns ALL mutable app state.
// It wraps the widget tree in AppState (an InheritedWidget) so any descendant
// can read the current state via AppState.of(context).
//
// State mutation follows a single pattern:
//   1. Method lives here (e.g. _toggleLike)
//   2. It calls setState → Flutter rebuilds AppState → descendants react
//
// When migrating to a backend, each method becomes a service call:
//   _toggleLike  → await PostService.like(post.id)
//   _addPost     → await PostService.create(post)
//   etc.

import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/frutiger_aero_theme.dart';
import '../models/post.dart';
import '../models/comment.dart';
import '../models/mood_entry.dart';
import '../models/user_profile.dart';
import '../state/app_state.dart';
import '../widgets/particle_background.dart';
import '../screens/home_screen.dart';
import '../screens/feed_screen.dart';
import '../screens/post_screen.dart';
import '../screens/find_friends_screen.dart';
import '../screens/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => MainNavigationState();
}

// Public so that child screens can use findAncestorStateOfType<MainNavigationState>()
// to reach methods like saveMoodEntry without needing a callback prop.
class MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  // ── Global state ───────────────────────────────────────────────────────────

  late List<Post> _posts;
  late List<Post> _favoritePosts;
  late UserProfile _userProfile;
  late Map<String, MoodEntry> _moodEntries;

  @override
  void initState() {
    super.initState();
    _initSeedData();
  }

  /// Populates the app with demo content on first launch.
  /// TODO: replace with API fetch (e.g. PostService.getRecentPosts()) when
  /// backend is ready.
  void _initSeedData() {
    _posts = [
      Post(
        id: '1',
        title: 'What did you guys eat for breakfast today?',
        content: 'I had some cereal and fruit. Been trying to start my day with something healthy! What about you guys?',
        anonymousName: 'OceanDreamer',
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        likes: 24, favorites: 5,
        tags: ['food', 'morning'],
        comments: [
          Comment(id: 'c1', authorName: 'StarryKid',     content: 'I had pancakes 🥞',         timestamp: DateTime.now().subtract(const Duration(hours: 1))),
          Comment(id: 'c2', authorName: 'SunshineVibes', content: 'Just grabbed a coffee lol', timestamp: DateTime.now().subtract(const Duration(minutes: 30))),
        ],
      ),
      Post(
        id: '2',
        title: 'How do you deal with school stress?',
        content: "Exams are coming up and I'm feeling really overwhelmed. Any study tips or stress management tricks that work for you guys?",
        anonymousName: 'WorriedStudent',
        timestamp: DateTime.now().subtract(const Duration(hours: 5)),
        likes: 45, favorites: 12,
        tags: ['school', 'stress', 'study'],
        comments: [
          Comment(id: 'c3', authorName: 'CalmOcean', content: 'Try the Pomodoro technique! 25 min study, 5 min break 📚', timestamp: DateTime.now().subtract(const Duration(hours: 4))),
        ],
      ),
      Post(
        id: '3',
        title: 'Random thought: Mondays hit different',
        content: 'Why does it feel like the weekend ended too fast every time? Anyone else feel like Sundays are just pre-Monday anxiety? 😅',
        anonymousName: 'WeekendWarrior',
        timestamp: DateTime.now().subtract(const Duration(hours: 8)),
        likes: 67, favorites: 18,
        tags: ['thoughts', 'weekend'],
        comments: [
          Comment(id: 'c4', authorName: 'ChillVibes', content: 'Sundays be like that fr 💀',                    timestamp: DateTime.now().subtract(const Duration(hours: 7))),
          Comment(id: 'c5', authorName: 'MoonChild',  content: 'Just embrace it and take it one day at a time ✨', timestamp: DateTime.now().subtract(const Duration(hours: 6))),
        ],
      ),
    ];
    _favoritePosts = [];
    _userProfile = UserProfile();
    _moodEntries = {};
  }

  // ── State mutations ────────────────────────────────────────────────────────
  // Each method is the single place where a particular piece of state changes.
  // Replace the body with an API call and keep the setState for optimistic UI.

  void _addPost(Post post) {
    setState(() => _posts.insert(0, post));
  }

  void _toggleLike(Post post) {
    setState(() {
      final i = _posts.indexWhere((p) => p.id == post.id);
      if (i == -1) return;
      final isLiked = _posts[i].isLikedByMe;
      _posts[i] = _posts[i].copyWith(
        likes: _posts[i].likes + (isLiked ? -1 : 1),
        isLikedByMe: !isLiked,
      );
    });
  }

  void _toggleFavorite(Post post) {
    setState(() {
      final i = _posts.indexWhere((p) => p.id == post.id);
      if (i == -1) return;
      final isFave = _posts[i].isFavoritedByMe;
      _posts[i] = _posts[i].copyWith(
        favorites: _posts[i].favorites + (isFave ? -1 : 1),
        isFavoritedByMe: !isFave,
      );
      if (isFave) {
        _favoritePosts.removeWhere((p) => p.id == post.id);
      } else {
        _favoritePosts.add(_posts[i]);
      }
    });
  }

  void _addComment(Post post, String text) {
    setState(() {
      final i = _posts.indexWhere((p) => p.id == post.id);
      if (i == -1) return;
      final comment = Comment(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        authorName: _userProfile.username,
        content: text,
        timestamp: DateTime.now(),
      );
      _posts[i] = _posts[i].copyWith(
        comments: [..._posts[i].comments, comment],
      );
    });
  }

  void _updateUserProfile(String username, String bio) {
    setState(() {
      _userProfile.username = username;
      _userProfile.bio = bio;
    });
  }

  /// Called by HomeScreen via findAncestorStateOfType to save a mood entry.
  void saveMoodEntry(String dateKey, MoodEntry entry) {
    setState(() => _moodEntries[dateKey] = entry);
  }

  // ── Screen routing ─────────────────────────────────────────────────────────

  Widget _buildScreen(int index) {
    switch (index) {
      case 0: return const HomeScreen(key: ValueKey('home'));
      case 1: return FeedScreen(
        key: const ValueKey('feed'),
        posts: _posts,
        userProfile: _userProfile,
        onLike: _toggleLike,
        onFavorite: _toggleFavorite,
        onComment: _addComment,
      );
      case 2: return PostScreen(
        key: const ValueKey('post'),
        onSubmit: _addPost,
        userProfile: _userProfile,
      );
      case 3: return const FindFriendsScreen(key: ValueKey('friends'));
      case 4: return ProfileScreen(
        key: const ValueKey('profile'),
        userProfile: _userProfile,
        onUpdateProfile: _updateUserProfile,
        favoritePosts: _favoritePosts,
      );
      default: return const HomeScreen(key: ValueKey('home'));
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return AppState(
      posts: _posts,
      favoritePosts: _favoritePosts,
      userProfile: _userProfile,
      moodEntries: _moodEntries,
      child: Scaffold(
        extendBody: true,
        body: Container(
          decoration: BoxDecoration(gradient: FrutigerAeroTheme.backgroundGradient),
          child: Stack(
            children: [
              const Positioned.fill(child: ParticleBackground()),
              SafeArea(
                bottom: false,
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: _buildScreen(_currentIndex),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            margin: const EdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.5), width: 1.5),
                    boxShadow: [
                      BoxShadow(color: FrutigerAeroTheme.oceanBlue.withValues(alpha: 0.1), blurRadius: 20),
                    ],
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _navItem(0, Icons.home_rounded,       'Home'),
                      _navItem(1, Icons.forum_rounded,      'Feed'),
                      _navItem(2, Icons.add_circle_rounded, 'Post'),
                      _navItem(3, Icons.people_rounded,     'Find Friends'),
                      _navItem(4, Icons.person_rounded,     'You'),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () => setState(() => _currentIndex = index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isSelected ? FrutigerAeroTheme.buttonGradient : null,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: isSelected ? Colors.white : FrutigerAeroTheme.textMid, size: 24),
            const SizedBox(height: 4),
            Text(label, style: TextStyle(
              color: isSelected ? Colors.white : FrutigerAeroTheme.textMid,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            )),
          ],
        ),
      ),
    );
  }
}
