import 'package:mockmate/features/interviews/domain/models/interview_session.dart';

/// Holds all derived progress data for display.
class ProgressSummary {
  const ProgressSummary({
    required this.totalInterviews,
    required this.totalPracticeDuration,
    required this.averageScore,
    required this.bestScore,
    required this.latestScore,
    required this.improvement,
    required this.averageTechnical,
    required this.averageCommunication,
    required this.averageConfidence,
    required this.averageConciseness,
    required this.averageAdaptability,
    required this.scoreTrend,
    required this.latestSessions,
    required this.hasBaseline,
    required this.hasTrend,
  });

  final int totalInterviews;
  final Duration totalPracticeDuration;
  final double? averageScore;
  final int? bestScore;
  final int? latestScore;

  /// Improvement from first scored to latest scored session.
  /// Null when insufficient data. Negative means a decline.
  final int? improvement;

  final double? averageTechnical;
  final double? averageCommunication;
  final double? averageConfidence;
  final double? averageConciseness;
  final double? averageAdaptability;

  /// Chronological list of (session label, score) for the trend chart.
  final List<ScoreTrendPoint> scoreTrend;

  /// Most recent sessions (already sorted, limited).
  final List<InterviewSession> latestSessions;

  /// True when exactly one scored session exists.
  final bool hasBaseline;

  /// True when two or more scored sessions exist.
  final bool hasTrend;

  String get practiceTimeLabel {
    final totalMinutes = totalPracticeDuration.inMinutes;
    if (totalMinutes >= 60) {
      final hours = totalMinutes ~/ 60;
      final mins = totalMinutes % 60;
      return mins > 0 ? '${hours}h ${mins}m' : '${hours}h';
    }
    return '$totalMinutes min';
  }
}

class ScoreTrendPoint {
  const ScoreTrendPoint({
    required this.label,
    required this.score,
    required this.date,
  });

  final String label;
  final int score;
  final DateTime date;
}

/// Pure domain service that derives all progress values from actual sessions.
///
/// Rules:
/// - Only uses real stored sessions.
/// - Excludes missing scores from averages (does not treat null as zero).
/// - Single scored session → "Baseline established", no improvement claim.
/// - Negative trends reported honestly.
/// - No fabricated streaks, readiness %, or hiring predictions.
class ProgressCalculator {
  const ProgressCalculator();

  /// Calculates progress from [sessions], optionally filtered to a date range.
  ProgressSummary calculate(
    List<InterviewSession> sessions, {
    DateTime? from,
    DateTime? to,
  }) {
    var filtered = List<InterviewSession>.from(sessions);

    if (from != null) {
      filtered = filtered
          .where((s) =>
              s.startedAt.isAtSameMomentAs(from) ||
              s.startedAt.isAfter(from))
          .toList();
    }
    if (to != null) {
      filtered = filtered
          .where((s) =>
              s.startedAt.isAtSameMomentAs(to) ||
              s.startedAt.isBefore(to))
          .toList();
    }

    final totalInterviews = filtered.length;
    final totalPractice = filtered.fold<Duration>(
      Duration.zero,
      (sum, s) => sum + s.duration,
    );

    // Scored sessions — sorted chronologically for trend.
    final scored = filtered
        .where((s) => s.overallScore != null)
        .toList()
      ..sort((a, b) => a.startedAt.compareTo(b.startedAt));

    final averageScore = scored.isNotEmpty
        ? scored.map((s) => s.overallScore!).reduce((a, b) => a + b) /
            scored.length
        : null;

    final bestScore = scored.isNotEmpty
        ? scored
            .map((s) => s.overallScore!)
            .reduce((a, b) => a > b ? a : b)
        : null;

    final latestScore =
        scored.isNotEmpty ? scored.last.overallScore : null;

    final hasBaseline = scored.length == 1;
    final hasTrend = scored.length >= 2;

    final improvement = hasTrend
        ? scored.last.overallScore! - scored.first.overallScore!
        : null;

    // Per-skill averages — only from sessions with scores.
    final withScores =
        filtered.where((s) => s.scores != null).toList();
    final avgTech = _avg(withScores, (s) => s.scores!.technicalAccuracy);
    final avgComm = _avg(withScores, (s) => s.scores!.communication);
    final avgConf = _avg(withScores, (s) => s.scores!.confidence);
    final avgConc = _avg(withScores, (s) => s.scores!.conciseness);
    final avgAdapt = _avg(withScores, (s) => s.scores!.adaptability);

    // Score trend points.
    final trend = scored
        .asMap()
        .entries
        .map((e) => ScoreTrendPoint(
              label: 'Session ${e.key + 1}',
              score: e.value.overallScore!,
              date: e.value.startedAt,
            ))
        .toList();

    // Latest sessions — sorted most-recent first, limited to 5.
    final latest = List<InterviewSession>.from(filtered)
      ..sort((a, b) => b.startedAt.compareTo(a.startedAt));
    final latestSessions =
        latest.length > 5 ? latest.sublist(0, 5) : latest;

    return ProgressSummary(
      totalInterviews: totalInterviews,
      totalPracticeDuration: totalPractice,
      averageScore: averageScore,
      bestScore: bestScore,
      latestScore: latestScore,
      improvement: improvement,
      averageTechnical: avgTech,
      averageCommunication: avgComm,
      averageConfidence: avgConf,
      averageConciseness: avgConc,
      averageAdaptability: avgAdapt,
      scoreTrend: trend,
      latestSessions: latestSessions,
      hasBaseline: hasBaseline,
      hasTrend: hasTrend,
    );
  }

  double? _avg(
    List<InterviewSession> sessions,
    int Function(InterviewSession) extract,
  ) {
    if (sessions.isEmpty) return null;
    return sessions.map(extract).reduce((a, b) => a + b) /
        sessions.length;
  }
}
