// lib/state/app_state.dart
//
// InheritedWidget that exposes read-only snapshots of global state to the
// widget tree. All mutations happen in MainNavigation (see main_navigation.dart)
// which calls setState and rebuilds this widget, propagating changes downward.
//
// Usage anywhere in the tree:
//   final state = AppState.of(context);
//   state.userProfile.username;

import 'package:flutter/material.dart';
import '../models/post.dart';
import '../models/mood_entry.dart';
import '../models/user_profile.dart';

class AppState extends InheritedWidget {
  final List<Post> posts;
  final List<Post> favoritePosts;
  final UserProfile userProfile;

  /// Keyed by date string formatted as 'yyyy-M-d'.
  final Map<String, MoodEntry> moodEntries;

  const AppState({
    super.key,
    required this.posts,
    required this.favoritePosts,
    required this.userProfile,
    required this.moodEntries,
    required super.child,
  });

  /// Convenience accessor — throws if AppState is not in the tree.
  static AppState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppState>()!;
  }

  @override
  bool updateShouldNotify(AppState oldWidget) => true;
}
