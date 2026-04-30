// lib/models/user_profile.dart
//
// Holds the local user's editable profile data.
// Username and bio are mutable so UI changes propagate immediately via setState.
// toJson / fromJson stubs are ready for backend wiring.

class UserProfile {
  String username;
  String bio;

  UserProfile({
    this.username = 'TeenUser',
    this.bio = 'Just here to connect and support each other 💙',
  });

  // ── Serialization stubs ───────────────────────────────────────────────────
  // TODO: replace with real API deserialization when backend is ready.

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
    username: json['username'] as String,
    bio: json['bio'] as String,
  );

  Map<String, dynamic> toJson() => {
    'username': username,
    'bio': bio,
  };
}
