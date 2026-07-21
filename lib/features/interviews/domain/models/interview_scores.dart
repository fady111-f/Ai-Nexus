/// Scores breakdown for an interview session.
///
/// Each score is an integer from 0 to 100, representing the user's
/// performance in a specific skill area. Invalid external values are
/// clamped to the valid range.
class InterviewScores {
  const InterviewScores({
    required int technicalAccuracy,
    required int communication,
    required int confidence,
    required int conciseness,
    required int adaptability,
  })  : technicalAccuracy = technicalAccuracy < 0
            ? 0
            : technicalAccuracy > 100
                ? 100
                : technicalAccuracy,
        communication = communication < 0
            ? 0
            : communication > 100
                ? 100
                : communication,
        confidence = confidence < 0
            ? 0
            : confidence > 100
                ? 100
                : confidence,
        conciseness = conciseness < 0
            ? 0
            : conciseness > 100
                ? 100
                : conciseness,
        adaptability = adaptability < 0
            ? 0
            : adaptability > 100
                ? 100
                : adaptability;

  final int technicalAccuracy;
  final int communication;
  final int confidence;
  final int conciseness;
  final int adaptability;

  /// All five scores as a list for iteration / averaging.
  List<int> get asList => [
        technicalAccuracy,
        communication,
        confidence,
        conciseness,
        adaptability,
      ];

  Map<String, dynamic> toJson() => {
        'technicalAccuracy': technicalAccuracy,
        'communication': communication,
        'confidence': confidence,
        'conciseness': conciseness,
        'adaptability': adaptability,
      };

  factory InterviewScores.fromJson(Map<String, dynamic> json) {
    return InterviewScores(
      technicalAccuracy: _safeInt(json['technicalAccuracy']),
      communication: _safeInt(json['communication']),
      confidence: _safeInt(json['confidence']),
      conciseness: _safeInt(json['conciseness']),
      adaptability: _safeInt(json['adaptability']),
    );
  }

  static int _safeInt(Object? value) {
    if (value is int) return value;
    if (value is double) return value.round();
    return 0;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InterviewScores &&
          technicalAccuracy == other.technicalAccuracy &&
          communication == other.communication &&
          confidence == other.confidence &&
          conciseness == other.conciseness &&
          adaptability == other.adaptability;

  @override
  int get hashCode => Object.hash(
        technicalAccuracy,
        communication,
        confidence,
        conciseness,
        adaptability,
      );
}
