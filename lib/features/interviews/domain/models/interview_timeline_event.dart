/// Types of notable moments during an interview.
///
/// Serialized using an explicit string map for storage stability.
enum TimelineEventType {
  strongAnswer,
  rambling,
  technicalGap,
  interruption,
  contradiction,
  recovery,
  generalFeedback,
}

/// Stable serialization map — never use `enum.name` for durable storage.
const _typeToString = <TimelineEventType, String>{
  TimelineEventType.strongAnswer: 'strong_answer',
  TimelineEventType.rambling: 'rambling',
  TimelineEventType.technicalGap: 'technical_gap',
  TimelineEventType.interruption: 'interruption',
  TimelineEventType.contradiction: 'contradiction',
  TimelineEventType.recovery: 'recovery',
  TimelineEventType.generalFeedback: 'general_feedback',
};

final _stringToType = <String, TimelineEventType>{
  for (final entry in _typeToString.entries) entry.value: entry.key,
};

/// Display labels for timeline event types.
extension TimelineEventTypeLabel on TimelineEventType {
  String get label => switch (this) {
        TimelineEventType.strongAnswer => 'Strong Answer',
        TimelineEventType.rambling => 'Rambling',
        TimelineEventType.technicalGap => 'Technical Gap',
        TimelineEventType.interruption => 'Interruption',
        TimelineEventType.contradiction => 'Contradiction',
        TimelineEventType.recovery => 'Recovery',
        TimelineEventType.generalFeedback => 'General Feedback',
      };

  /// Semantic icon name for accessibility — actual icons resolved in UI.
  String get semanticIcon => switch (this) {
        TimelineEventType.strongAnswer => 'check_circle',
        TimelineEventType.rambling => 'warning',
        TimelineEventType.technicalGap => 'error',
        TimelineEventType.interruption => 'pause_circle',
        TimelineEventType.contradiction => 'swap_horiz',
        TimelineEventType.recovery => 'trending_up',
        TimelineEventType.generalFeedback => 'info',
      };
}

/// A key moment during an interview session.
class InterviewTimelineEvent {
  const InterviewTimelineEvent({
    required this.id,
    required this.timestamp,
    required this.type,
    required this.title,
    required this.description,
    this.relatedQuestionId,
  });

  final String id;
  final Duration timestamp;
  final TimelineEventType type;
  final String title;
  final String description;
  final String? relatedQuestionId;

  Map<String, dynamic> toJson() => {
        'id': id,
        'timestampMs': timestamp.inMilliseconds,
        'type': _typeToString[type] ?? 'general_feedback',
        'title': title,
        'description': description,
        'relatedQuestionId': relatedQuestionId,
      };

  factory InterviewTimelineEvent.fromJson(Map<String, dynamic> json) {
    return InterviewTimelineEvent(
      id: json['id'] as String? ?? '',
      timestamp:
          Duration(milliseconds: json['timestampMs'] as int? ?? 0),
      type: _stringToType[json['type'] as String?] ??
          TimelineEventType.generalFeedback,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      relatedQuestionId: json['relatedQuestionId'] as String?,
    );
  }
}
