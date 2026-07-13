import 'package:flutter/material.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';

class QuickStats extends StatelessWidget {
  const QuickStats({super.key});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label:
          'Quick Stats. Zero interviews, zero minutes practice time, no best score yet.',
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
                  const Expanded(
                    child: _StatItem(
                      value: '0',
                      label: 'Interviews',
                      valueKey: Key('interviewsStatValue'),
                    ),
                  ),
                  _divider(),
                  const Expanded(
                    child: _StatItem(
                      value: '0 min',
                      label: 'Practice Time',
                      valueKey: Key('practiceTimeStatValue'),
                    ),
                  ),
                  _divider(),
                  const Expanded(
                    child: _StatItem(
                      value: '—',
                      label: 'Best Score',
                      valueKey: Key('bestScoreStatValue'),
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
