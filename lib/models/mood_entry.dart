// lib/models/mood_entry.dart
//
// Represents one mood log entry for a specific date.
// toJson / fromJson stubs are ready for backend wiring.

class MoodEntry {
  final String id;

  /// Human-readable mood label: 'Sad' | 'Down' | 'Okay' | 'Good' | 'Great'
  final String mood;

  /// Optional free-text note the user wrote alongside their mood.
  final String? note;

  final DateTime date;

  const MoodEntry({
    required this.id,
    required this.mood,
    this.note,
    required this.date,
  });

  // ── Serialization stubs ───────────────────────────────────────────────────
  // TODO: replace with real API deserialization when backend is ready.

  factory MoodEntry.fromJson(Map<String, dynamic> json) => MoodEntry(
    id: json['id'] as String,
    mood: json['mood'] as String,
    note: json['note'] as String?,
    date: DateTime.parse(json['date'] as String),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'mood': mood,
    'note': note,
    'date': date.toIso8601String(),
  };
}
