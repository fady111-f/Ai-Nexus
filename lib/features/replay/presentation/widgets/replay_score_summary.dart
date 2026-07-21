import 'package:flutter/material.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/interviews/domain/models/interview_session.dart';

class ReplayScoreSummary extends StatelessWidget {
  const ReplayScoreSummary({required this.session, super.key});

  final InterviewSession session;

  @override
  Widget build(BuildContext context) {
    if (session.scores == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(MockMateSpacing.large),
      decoration: BoxDecoration(
        color: MockMateColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: MockMateColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  'Score Summary',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: MockMateColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: MockMateColors.cyan.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      '${session.overallScore}',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: MockMateColors.cyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      ' / 100',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: MockMateColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: MockMateSpacing.large),
          _ScoreRow(
            label: 'Technical Accuracy',
            score: session.scores!.technicalAccuracy,
          ),
          const SizedBox(height: MockMateSpacing.medium),
          _ScoreRow(
            label: 'Communication',
            score: session.scores!.communication,
          ),
          const SizedBox(height: MockMateSpacing.medium),
          _ScoreRow(label: 'Confidence', score: session.scores!.confidence),
          const SizedBox(height: MockMateSpacing.medium),
          _ScoreRow(label: 'Adaptability', score: session.scores!.adaptability),
          const SizedBox(height: MockMateSpacing.medium),
          _ScoreRow(label: 'Conciseness', score: session.scores!.conciseness),
        ],
      ),
    );
  }
}

class _ScoreRow extends StatelessWidget {
  const _ScoreRow({required this.label, required this.score});

  final String label;
  final int score;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 140,
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: MockMateColors.textSecondary,
            ),
          ),
        ),
        const SizedBox(width: MockMateSpacing.medium),
        Expanded(
          child: Stack(
            children: [
              Container(
                height: 8,
                decoration: BoxDecoration(
                  color: MockMateColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              FractionallySizedBox(
                widthFactor: score / 100.0,
                child: Container(
                  height: 8,
                  decoration: BoxDecoration(
                    color: MockMateColors.cyan,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: MockMateSpacing.medium),
        SizedBox(
          width: 32,
          child: Text(
            '$score',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
