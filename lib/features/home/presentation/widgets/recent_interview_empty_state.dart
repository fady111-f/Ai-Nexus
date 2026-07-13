import 'package:flutter/material.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';

class RecentInterviewEmptyState extends StatelessWidget {
  const RecentInterviewEmptyState({required this.onStartInterview, super.key});

  final VoidCallback onStartInterview;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Recent Interview', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: MockMateSpacing.small),
        DecoratedBox(
          key: const Key('recentInterviewEmptyState'),
          decoration: BoxDecoration(
            color: MockMateColors.surface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: MockMateColors.outline),
          ),
          child: Padding(
            padding: const EdgeInsets.all(MockMateSpacing.large),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: MockMateColors.surfaceRaised,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(
                    Icons.history_rounded,
                    color: MockMateColors.cyan,
                    size: 23,
                  ),
                ),
                const SizedBox(height: MockMateSpacing.medium),
                Text(
                  'No interviews yet',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: MockMateSpacing.xSmall),
                Text(
                  'Your first session will appear here with feedback, scores, and key moments.',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: MockMateSpacing.large),
                OutlinedButton.icon(
                  key: const Key('startFirstInterviewButton'),
                  onPressed: onStartInterview,
                  icon: const Icon(Icons.mic_none_rounded, size: 19),
                  label: const Text('Start Your First Interview'),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
