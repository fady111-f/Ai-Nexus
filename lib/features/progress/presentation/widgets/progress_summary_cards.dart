import 'package:flutter/material.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/interviews/domain/services/progress_calculator.dart';

class ProgressSummaryCards extends StatelessWidget {
  const ProgressSummaryCards({required this.summary, super.key});

  final ProgressSummary summary;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'Interviews',
                value: '${summary.totalInterviews}',
                icon: Icons.mic_none_rounded,
              ),
            ),
            const SizedBox(width: MockMateSpacing.medium),
            Expanded(
              child: _SummaryCard(
                label: 'Practice Time',
                value: summary.practiceTimeLabel,
                icon: Icons.timer_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: MockMateSpacing.medium),
        Row(
          children: [
            Expanded(
              child: _SummaryCard(
                label: 'Average Score',
                value: summary.averageScore != null
                    ? summary.averageScore!.toStringAsFixed(1)
                    : '—',
                icon: Icons.analytics_outlined,
              ),
            ),
            const SizedBox(width: MockMateSpacing.medium),
            Expanded(
              child: _SummaryCard(
                label: 'Improvement',
                value: summary.improvement != null
                    ? '${summary.improvement! > 0 ? '+' : ''}${summary.improvement}'
                    : '—',
                valueColor:
                    summary.improvement != null && summary.improvement! > 0
                    ? MockMateColors.cyan
                    : null,
                icon: Icons.trending_up_rounded,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
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
              Icon(icon, size: 18, color: MockMateColors.textSecondary),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: MockMateColors.textSecondary,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: MockMateSpacing.medium),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              maxLines: 1,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: valueColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
