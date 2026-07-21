import 'package:mockmate/features/interviews/domain/models/interview_question.dart';
import 'package:mockmate/features/interviews/domain/models/interview_recording.dart';
import 'package:mockmate/features/interviews/domain/models/interview_scores.dart';
import 'package:mockmate/features/interviews/domain/models/interview_timeline_event.dart';

/// Supported interview types with stable serialization.
enum InterviewType { behavioral, technical, mixed, caseStudy }

const _interviewTypeToString = <InterviewType, String>{
  InterviewType.behavioral: 'behavioral',
  InterviewType.technical: 'technical',
  InterviewType.mixed: 'mixed',
  InterviewType.caseStudy: 'case_study',
};

final _stringToInterviewType = <String, InterviewType>{
  for (final entry in _interviewTypeToString.entries) entry.value: entry.key,
};

extension InterviewTypeLabel on InterviewType {
  String get label => switch (this) {
        InterviewType.behavioral => 'Behavioral',
        InterviewType.technical => 'Technical',
        InterviewType.mixed => 'Mixed',
        InterviewType.caseStudy => 'Case Study',
      };
}

/// The current schema version for local session storage.
const int currentSessionSchemaVersion = 1;

/// A completed interview session.
///
/// This is the primary domain model for all Progress and Replay features.
class InterviewSession {
  const InterviewSession({
    required this.id,
    required this.jobTitle,
    required this.startedAt,
    required this.duration,
    required this.interviewType,
    required this.difficulty,
    required this.language,
    required this.createdAt,
    this.companyName,
    this.overallScore,
    this.scores,
    this.questions = const [],
    this.timelineEvents = const [],
    this.recording,
    this.isDemo = false,
    this.schemaVersion = currentSessionSchemaVersion,
  });

  final String id;
  final String jobTitle;
  final String? companyName;
  final DateTime startedAt;
  final Duration duration;
  final InterviewType interviewType;
  final String difficulty;
  final String language;
  final int? overallScore;
  final InterviewScores? scores;
  final List<InterviewQuestion> questions;
  final List<InterviewTimelineEvent> timelineEvents;
  final InterviewRecording? recording;
  final DateTime createdAt;
  final bool isDemo;
  final int schemaVersion;

  InterviewSession copyWith({
    List<InterviewQuestion>? questions,
  }) =>
      InterviewSession(
        id: id,
        jobTitle: jobTitle,
        companyName: companyName,
        startedAt: startedAt,
        duration: duration,
        interviewType: interviewType,
        difficulty: difficulty,
        language: language,
        overallScore: overallScore,
        scores: scores,
        questions: questions ?? this.questions,
        timelineEvents: timelineEvents,
        recording: recording,
        createdAt: createdAt,
        isDemo: isDemo,
        schemaVersion: schemaVersion,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'jobTitle': jobTitle,
        'companyName': companyName,
        'startedAt': startedAt.toIso8601String(),
        'durationMs': duration.inMilliseconds,
        'interviewType':
            _interviewTypeToString[interviewType] ?? 'mixed',
        'difficulty': difficulty,
        'language': language,
        'overallScore': overallScore,
        'scores': scores?.toJson(),
        'questions': questions.map((q) => q.toJson()).toList(),
        'timelineEvents':
            timelineEvents.map((e) => e.toJson()).toList(),
        'recording': recording?.toJson(),
        'createdAt': createdAt.toIso8601String(),
        'isDemo': isDemo,
        'schemaVersion': schemaVersion,
      };

  factory InterviewSession.fromJson(Map<String, dynamic> json) {
    return InterviewSession(
      id: json['id'] as String? ?? '',
      jobTitle: json['jobTitle'] as String? ?? 'Unknown Role',
      companyName: json['companyName'] as String?,
      startedAt: DateTime.tryParse(json['startedAt'] as String? ?? '') ??
          DateTime.now(),
      duration:
          Duration(milliseconds: json['durationMs'] as int? ?? 0),
      interviewType:
          _stringToInterviewType[json['interviewType'] as String?] ??
              InterviewType.mixed,
      difficulty: json['difficulty'] as String? ?? 'Realistic',
      language: json['language'] as String? ?? 'English',
      overallScore: json['overallScore'] as int?,
      scores: json['scores'] != null &&
              json['scores'] is Map<String, dynamic>
          ? InterviewScores.fromJson(
              json['scores'] as Map<String, dynamic>)
          : null,
      questions: (json['questions'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map(InterviewQuestion.fromJson)
              .toList() ??
          const [],
      timelineEvents: (json['timelineEvents'] as List<dynamic>?)
              ?.whereType<Map<String, dynamic>>()
              .map(InterviewTimelineEvent.fromJson)
              .toList() ??
          const [],
      recording: json['recording'] != null &&
              json['recording'] is Map<String, dynamic>
          ? InterviewRecording.fromJson(
              json['recording'] as Map<String, dynamic>)
          : null,
      createdAt:
          DateTime.tryParse(json['createdAt'] as String? ?? '') ??
              DateTime.now(),
      isDemo: json['isDemo'] as bool? ?? false,
      schemaVersion: json['schemaVersion'] as int? ??
          currentSessionSchemaVersion,
    );
  }
}
