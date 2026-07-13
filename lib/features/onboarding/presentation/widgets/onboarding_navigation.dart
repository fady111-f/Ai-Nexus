import 'package:flutter/material.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';

class OnboardingNavigation extends StatelessWidget {
  const OnboardingNavigation({
    required this.isLastStep,
    required this.isBusy,
    required this.canContinue,
    required this.onBack,
    required this.onContinue,
    this.errorMessage,
    super.key,
  });

  final bool isLastStep;
  final bool isBusy;
  final bool canContinue;
  final VoidCallback onBack;
  final VoidCallback onContinue;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: MockMateColors.background.withValues(alpha: 0.97),
        border: const Border(top: BorderSide(color: MockMateColors.outline)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          MockMateSpacing.large,
          MockMateSpacing.small,
          MockMateSpacing.large,
          MockMateSpacing.medium,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (errorMessage != null) ...[
              Semantics(
                liveRegion: true,
                child: Text(
                  errorMessage!,
                  key: const Key('onboardingPersistenceError'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.error,
                    fontSize: 12,
                  ),
                ),
              ),
              const SizedBox(height: MockMateSpacing.xSmall),
            ],
            Row(
              children: [
                SizedBox(
                  width: 112,
                  child: OutlinedButton(
                    key: const Key('onboardingBackButton'),
                    onPressed: isBusy ? null : onBack,
                    child: const Text('Back'),
                  ),
                ),
                const SizedBox(width: MockMateSpacing.small),
                Expanded(
                  child: ElevatedButton(
                    key: const Key('onboardingContinueButton'),
                    onPressed: isBusy || !canContinue ? null : onContinue,
                    child: Text(isLastStep ? 'Complete Setup' : 'Continue'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
