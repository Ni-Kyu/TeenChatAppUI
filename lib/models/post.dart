// lib/models/post.dart
//
// Represents a community feed post. Posts are immutable by design:
// use copyWith to produce an updated copy (follows Flutter's reactive pattern
// and will map cleanly to API PATCH calls when a backend is added).
//
// isUserPost == true means the post belongs to the currently logged-in user.
// The feed card uses this flag to resolve the display name live from
// UserProfile so username changes are reflected everywhere without re-saving.

import 'comment.dart';

class Post {
  final String id;
  final String title;
  final String content;

  /// Pseudonym shown for non-user posts. Null means "Anonymous".
  final String? anonymousName;

  final DateTime timestamp;
  final int likes;
  final int favorites;
  final List<String> tags;
  final List<Comment> comments;

  /// True when the post was created by the current local user.
  final bool isUserPost;

  /// Whether the local user has liked this post.
  final bool isLikedByMe;

  /// Whether the local user has starred/favorited this post.
  final bool isFavoritedByMe;

  const Post({
    required this.id,
    required this.title,
    required this.content,
    this.anonymousName,
    required this.timestamp,
    this.likes = 0,
    this.favorites = 0,
    this.tags = const [],
    this.comments = const [],
    this.isUserPost = false,
    this.isLikedByMe = false,
    this.isFavoritedByMe = false,
  });

  /// Returns a new Post with the provided fields overridden.
  Post copyWith({
    int? likes,
    int? favorites,
    List<Comment>? comments,
    bool? isLikedByMe,
    bool? isFavoritedByMe,
  }) {
    return Post(
      id: id,
      title: title,
      content: content,
      anonymousName: anonymousName,
      timestamp: timestamp,
      likes: likes ?? this.likes,
      favorites: favorites ?? this.favorites,
      tags: tags,
      comments: comments ?? this.comments,
      isUserPost: isUserPost,
      isLikedByMe: isLikedByMe ?? this.isLikedByMe,
      isFavoritedByMe: isFavoritedByMe ?? this.isFavoritedByMe,
    );
  }

  // ── Serialization stubs ───────────────────────────────────────────────────
  // TODO: replace with real API deserialization when backend is ready.

  factory Post.fromJson(Map<String, dynamic> json) => Post(
    id: json['id'] as String,
    title: json['title'] as String,
    content: json['content'] as String,
    anonymousName: json['anonymousName'] as String?,
    timestamp: DateTime.parse(json['timestamp'] as String),
    likes: (json['likes'] as num).toInt(),
    favorites: (json['favorites'] as num).toInt(),
    tags: List<String>.from(json['tags'] as List),
    comments: (json['comments'] as List)
        .map((c) => Comment.fromJson(c as Map<String, dynamic>))
        .toList(),
    isUserPost: json['isUserPost'] as bool? ?? false,
    isLikedByMe: json['isLikedByMe'] as bool? ?? false,
    isFavoritedByMe: json['isFavoritedByMe'] as bool? ?? false,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'content': content,
    'anonymousName': anonymousName,
    'timestamp': timestamp.toIso8601String(),
    'likes': likes,
    'favorites': favorites,
    'tags': tags,
    'comments': comments.map((c) => c.toJson()).toList(),
    'isUserPost': isUserPost,
    'isLikedByMe': isLikedByMe,
    'isFavoritedByMe': isFavoritedByMe,
  };
}
