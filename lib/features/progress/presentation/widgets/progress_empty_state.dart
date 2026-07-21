import 'package:flutter/material.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';

class ProgressEmptyState extends StatelessWidget {
  const ProgressEmptyState({this.onSeedDemo, super.key});

  final VoidCallback? onSeedDemo;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(MockMateSpacing.xLarge),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: MockMateColors.surfaceRaised,
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.insights_rounded,
                color: MockMateColors.cyan,
                size: 32,
              ),
            ),
            const SizedBox(height: MockMateSpacing.large),
            Text(
              'No Progress Yet',
              style: Theme.of(context).textTheme.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: MockMateSpacing.small),
            Text(
              "You haven't completed any mock interviews yet. Your progress and performance breakdown will appear here once you do.",
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
            if (onSeedDemo != null) ...[
              const SizedBox(height: MockMateSpacing.xLarge),
              OutlinedButton.icon(
                key: const Key('seedDemoDataButton'),
                onPressed: onSeedDemo,
                icon: const Icon(Icons.bug_report_rounded, size: 18),
                label: const Text('Preview with Demo Data'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
