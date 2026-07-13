import 'package:flutter/material.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';

class OnboardingProgress extends StatelessWidget {
  const OnboardingProgress({
    required this.currentStep,
    required this.totalSteps,
    super.key,
  });

  final int currentStep;
  final int totalSteps;

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final duration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 220);

    return Semantics(
      label: 'Step ${currentStep + 1} of $totalSteps',
      value: '${currentStep + 1} of $totalSteps',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Step ${currentStep + 1} of $totalSteps',
            key: const Key('onboardingStepLabel'),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: MockMateColors.textPrimary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(height: MockMateSpacing.xSmall),
          Row(
            children: List.generate(totalSteps, (index) {
              final active = index <= currentStep;
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: index == 0 ? 0 : 6),
                  child: AnimatedContainer(
                    key: Key('onboardingProgressSegment$index'),
                    duration: duration,
                    curve: Curves.easeOutCubic,
                    height: 4,
                    decoration: BoxDecoration(
                      color: active
                          ? MockMateColors.primary
                          : MockMateColors.outlineStrong,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
