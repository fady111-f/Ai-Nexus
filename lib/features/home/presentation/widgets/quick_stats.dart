import 'package:flutter/material.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/interviews/domain/models/interview_session.dart';

class QuickStats extends StatelessWidget {
  const QuickStats({required this.sessions, super.key});

  final List<InterviewSession> sessions;

  @override
  Widget build(BuildContext context) {
    final totalInterviews = sessions.length;
    final totalPracticeMinutes = sessions.fold<int>(
      0,
      (sum, session) => sum + session.duration.inMinutes,
    );
    
    int? bestScore;
    for (final session in sessions) {
      if (session.overallScore != null) {
        if (bestScore == null || session.overallScore! > bestScore) {
          bestScore = session.overallScore;
        }
      }
    }

    return Semantics(
      label:
          'Quick Stats. $totalInterviews interviews, $totalPracticeMinutes minutes practice time, ${bestScore ?? 'no'} best score.',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Quick Stats', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: MockMateSpacing.small),
          DecoratedBox(
            decoration: BoxDecoration(
              color: MockMateColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: MockMateColors.outline),
            ),
            child: IntrinsicHeight(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: _StatItem(
                      value: '$totalInterviews',
                      label: 'Interviews',
                      valueKey: const Key('interviewsStatValue'),
                    ),
                  ),
                  _divider(),
                  Expanded(
                    child: _StatItem(
                      value: '$totalPracticeMinutes min',
                      label: 'Practice Time',
                      valueKey: const Key('practiceTimeStatValue'),
                    ),
                  ),
                  _divider(),
                  Expanded(
                    child: _StatItem(
                      value: bestScore != null ? '$bestScore' : '—',
                      label: 'Best Score',
                      valueKey: const Key('bestScoreStatValue'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _divider() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 16),
    child: VerticalDivider(
      width: 1,
      thickness: 1,
      color: MockMateColors.outline,
    ),
  );
}

class _StatItem extends StatelessWidget {
  const _StatItem({
    required this.value,
    required this.label,
    required this.valueKey,
  });

  final String value;
  final String label;
  final Key valueKey;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            key: valueKey,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontSize: 21),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontSize: 12),
          ),
        ],
      ),
    );
  }
}
