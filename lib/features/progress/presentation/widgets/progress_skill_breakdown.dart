import 'package:flutter/material.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/interviews/domain/services/progress_calculator.dart';

class ProgressSkillBreakdown extends StatelessWidget {
  const ProgressSkillBreakdown({required this.summary, super.key});

  final ProgressSummary summary;

  @override
  Widget build(BuildContext context) {
    if (summary.averageTechnical == null) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: MockMateSpacing.large),
          child: Text(
            'Skill Breakdown',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: MockMateSpacing.medium),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: MockMateSpacing.large),
          child: Container(
            padding: const EdgeInsets.all(MockMateSpacing.large),
            decoration: BoxDecoration(
              color: MockMateColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: MockMateColors.outline),
            ),
            child: Column(
              children: [
                _SkillBar(label: 'Technical Depth', score: summary.averageTechnical!),
                const SizedBox(height: MockMateSpacing.medium),
                _SkillBar(label: 'Clarity', score: summary.averageCommunication!),
                const SizedBox(height: MockMateSpacing.medium),
                _SkillBar(label: 'Confidence', score: summary.averageConfidence!),
                const SizedBox(height: MockMateSpacing.medium),
                _SkillBar(label: 'Adaptability', score: summary.averageAdaptability!),
                const SizedBox(height: MockMateSpacing.medium),
                _SkillBar(label: 'Conciseness', score: summary.averageConciseness!),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _SkillBar extends StatelessWidget {
  const _SkillBar({required this.label, required this.score});

  final String label;
  final double score;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 110,
          child: Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
          width: 30,
          child: Text(
            score.toStringAsFixed(0),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}
