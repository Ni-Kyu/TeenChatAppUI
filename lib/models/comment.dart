// lib/models/comment.dart
//
// Represents a single comment on a Post.
// toJson / fromJson stubs are ready for backend wiring.

class Comment {
  final String id;
  final String authorName;
  final String content;
  final DateTime timestamp;

  const Comment({
    required this.id,
    required this.authorName,
    required this.content,
    required this.timestamp,
  });

  // ── Serialization stubs ───────────────────────────────────────────────────
  // TODO: replace with real API deserialization when backend is ready.

  factory Comment.fromJson(Map<String, dynamic> json) => Comment(
    id: json['id'] as String,
    authorName: json['authorName'] as String,
    content: json['content'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'authorName': authorName,
    'content': content,
    'timestamp': timestamp.toIso8601String(),
  };
}
