// lib/models/peer_profile.dart
//
// Represents another user's public profile shown in the Find Friends screen.
// toJson / fromJson stubs are ready for backend wiring.

class PeerProfile {
  final String id;
  final String username;
  final String bio;

  const PeerProfile({
    required this.id,
    required this.username,
    required this.bio,
  });

  // ── Serialization stubs ───────────────────────────────────────────────────
  // TODO: replace with real API deserialization when backend is ready.

  factory PeerProfile.fromJson(Map<String, dynamic> json) => PeerProfile(
    id: json['id'] as String,
    username: json['username'] as String,
    bio: json['bio'] as String,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'username': username,
    'bio': bio,
  };
}
