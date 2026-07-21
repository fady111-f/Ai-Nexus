import 'package:flutter/material.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';

class MockMateBrand extends StatelessWidget {
  const MockMateBrand({this.compact = false, super.key});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final markSize = compact ? 36.0 : 42.0;

    return Semantics(
      header: true,
      label: 'Gahez?',
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: markSize,
            height: markSize,
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: MockMateColors.surfaceRaised,
              borderRadius: BorderRadius.circular(compact ? 12 : 14),
              border: Border.all(color: MockMateColors.outlineStrong),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(compact ? 8 : 10),
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.mic, color: MockMateColors.cyan, size: 20),
              ),
            ),
          ),
          const SizedBox(width: MockMateSpacing.small),
          Text(
            'Gahez?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontSize: compact ? 18 : 20,
              letterSpacing: -0.4,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
