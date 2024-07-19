class Mood {
  final int id;
  final int improvementItemId;
  final String mood;
  final DateTime timestamp;

  Mood({
    required this.id,
    required this.improvementItemId,
    required this.mood,
    required this.timestamp,
  });

  factory Mood.fromMap(Map<String, dynamic> map) {
    return Mood(
      id: map['id'],
      improvementItemId: map['improvement_item_id'],
      mood: map['mood'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'improvement_item_id': improvementItemId,
      'mood': mood,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
