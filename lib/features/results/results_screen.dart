import 'package:flutter/material.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MockMateColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Interview Insights'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(MockMateSpacing.large),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 440),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: MockMateColors.surface,
                      shape: BoxShape.circle,
                      border: Border.all(color: MockMateColors.outline),
                    ),
                    child: const Icon(
                      Icons.analytics_outlined,
                      size: 40,
                      color: MockMateColors.cyan,
                    ),
                  ),
                  const SizedBox(height: MockMateSpacing.large),
                  Text(
                    'No results yet',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: MockMateSpacing.xSmall),
                  Text(
                    'Complete an interview to see your performance breakdown, '
                    'AI feedback, and personalized improvement areas.',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: MockMateSpacing.large),
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
