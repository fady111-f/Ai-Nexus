import 'package:flutter/material.dart';
import 'package:mockmate/core/routing/app_routes.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/auth/presentation/widgets/mockmate_brand.dart';
import 'package:mockmate/features/onboarding/domain/models/user_profile.dart';
import 'package:mockmate/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:mockmate/features/onboarding/presentation/widgets/onboarding_navigation.dart';
import 'package:mockmate/features/onboarding/presentation/widgets/onboarding_option_card.dart';
import 'package:mockmate/features/onboarding/presentation/widgets/onboarding_progress.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({required this.onboardingRepository, super.key});

  final OnboardingRepository onboardingRepository;

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  static const _totalSteps = 4;

  final _targetRoleController = TextEditingController();
  final _targetRoleFocusNode = FocusNode();

  int _currentStep = 0;
  int _transitionDirection = 1;
  CareerField? _careerField;
  ExperienceLevel? _experienceLevel;
  CareerGoal? _careerGoal;
  PreferredLanguage? _preferredLanguage;
  InterviewDifficulty? _preferredDifficulty;
  bool _targetRoleHasError = false;
  bool _isSaving = false;
  String? _persistenceError;

  bool get _isLastStep => _currentStep == _totalSteps - 1;

  bool get _canContinue => switch (_currentStep) {
    0 => _careerField != null && _experienceLevel != null,
    1 => _careerGoal != null,
    2 => true,
    3 => _preferredLanguage != null && _preferredDifficulty != null,
    _ => false,
  };

  @override
  void dispose() {
    _targetRoleController.dispose();
    _targetRoleFocusNode.dispose();
    super.dispose();
  }

  void _goBack() {
    if (_isSaving) {
      return;
    }
    if (_currentStep == 0) {
      Navigator.of(context).maybePop();
      return;
    }
    FocusManager.instance.primaryFocus?.unfocus();
    setState(() {
      _transitionDirection = -1;
      _currentStep -= 1;
      _persistenceError = null;
    });
  }

  Future<void> _continue() async {
    if (_currentStep == 2) {
      FocusManager.instance.primaryFocus?.unfocus();
      if (_targetRoleController.text.trim().isEmpty) {
        setState(() => _targetRoleHasError = true);
        _targetRoleFocusNode.requestFocus();
        return;
      }
    }

    if (_isLastStep) {
      await _completeOnboarding();
      return;
    }

    setState(() {
      _transitionDirection = 1;
      _currentStep += 1;
      _persistenceError = null;
    });
  }

  Future<void> _completeOnboarding() async {
    final careerField = _careerField;
    final experienceLevel = _experienceLevel;
    final careerGoal = _careerGoal;
    final preferredLanguage = _preferredLanguage;
    final preferredDifficulty = _preferredDifficulty;
    final targetRole = _targetRoleController.text.trim();

    if (careerField == null ||
        experienceLevel == null ||
        careerGoal == null ||
        preferredLanguage == null ||
        preferredDifficulty == null ||
        targetRole.isEmpty) {
      setState(() {
        _persistenceError =
            'Please complete every selection before continuing.';
      });
      return;
    }

    setState(() {
      _isSaving = true;
      _persistenceError = null;
    });

    final profile = UserProfile(
      careerField: careerField,
      experienceLevel: experienceLevel,
      careerGoal: careerGoal,
      targetRole: targetRole,
      preferredLanguage: preferredLanguage,
      preferredDifficulty: preferredDifficulty,
    );

    try {
      await widget.onboardingRepository.saveUserProfile(profile);
      await widget.onboardingRepository.markOnboardingCompleted();
      if (!mounted) {
        return;
      }
      await Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(AppRoutes.home, (route) => false);
    } on Object {
      if (mounted) {
        setState(() {
          _persistenceError =
              'We could not save your setup. Check your device storage and try again.';
        });
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final reduceMotion =
        MediaQuery.maybeOf(context)?.disableAnimations ?? false;
    final transitionDuration = reduceMotion
        ? Duration.zero
        : const Duration(milliseconds: 220);

    return PopScope(
      canPop: _currentStep == 0 && !_isSaving,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop && !_isSaving) {
          _goBack();
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            const Positioned.fill(child: _OnboardingBackground()),
            SafeArea(
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final compact = constraints.maxHeight < 680;
                  final horizontalPadding = constraints.maxWidth < 360
                      ? MockMateSpacing.medium
                      : constraints.maxWidth >= 900
                      ? MockMateSpacing.xxLarge
                      : MockMateSpacing.large;

                  return Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 960),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(
                              horizontalPadding,
                              compact ? 12 : MockMateSpacing.large,
                              horizontalPadding,
                              compact ? 12 : MockMateSpacing.medium,
                            ),
                            child: Row(
                              children: [
                                MockMateBrand(compact: compact),
                                const SizedBox(width: MockMateSpacing.large),
                                Expanded(
                                  child: OnboardingProgress(
                                    currentStep: _currentStep,
                                    totalSteps: _totalSteps,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: AnimatedSwitcher(
                              duration: transitionDuration,
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeInCubic,
                              transitionBuilder: (child, animation) {
                                final offset = Tween<Offset>(
                                  begin: Offset(
                                    0,
                                    0.035 * _transitionDirection,
                                  ),
                                  end: Offset.zero,
                                ).animate(animation);
                                return FadeTransition(
                                  opacity: animation,
                                  child: SlideTransition(
                                    position: offset,
                                    child: child,
                                  ),
                                );
                              },
                              child: SingleChildScrollView(
                                key: ValueKey(_currentStep),
                                keyboardDismissBehavior:
                                    ScrollViewKeyboardDismissBehavior.onDrag,
                                padding: EdgeInsets.fromLTRB(
                                  horizontalPadding,
                                  compact ? 12 : MockMateSpacing.large,
                                  horizontalPadding,
                                  MockMateSpacing.xLarge,
                                ),
                                child: Align(
                                  alignment: Alignment.topCenter,
                                  child: ConstrainedBox(
                                    constraints: const BoxConstraints(
                                      maxWidth: 760,
                                    ),
                                    child: _buildCurrentStep(compact: compact),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          OnboardingNavigation(
                            isLastStep: _isLastStep,
                            isBusy: _isSaving,
                            canContinue: _canContinue,
                            onBack: _goBack,
                            onContinue: _continue,
                            errorMessage: _persistenceError,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrentStep({required bool compact}) => switch (_currentStep) {
    0 => _CareerProfileStep(
      compact: compact,
      careerField: _careerField,
      experienceLevel: _experienceLevel,
      onCareerFieldSelected: (value) => setState(() => _careerField = value),
      onExperienceLevelSelected: (value) =>
          setState(() => _experienceLevel = value),
    ),
    1 => _CareerGoalStep(
      compact: compact,
      careerGoal: _careerGoal,
      onSelected: (value) => setState(() => _careerGoal = value),
    ),
    2 => _TargetRoleStep(
      compact: compact,
      controller: _targetRoleController,
      focusNode: _targetRoleFocusNode,
      hasError: _targetRoleHasError,
      onChanged: (value) {
        if (_targetRoleHasError && value.trim().isNotEmpty) {
          setState(() => _targetRoleHasError = false);
        }
      },
      onSubmitted: (_) => _continue(),
    ),
    3 => _InterviewPreferencesStep(
      compact: compact,
      preferredLanguage: _preferredLanguage,
      preferredDifficulty: _preferredDifficulty,
      onLanguageSelected: (value) => setState(() => _preferredLanguage = value),
      onDifficultySelected: (value) =>
          setState(() => _preferredDifficulty = value),
    ),
    _ => const SizedBox.shrink(),
  };
}

class _StepHeading extends StatelessWidget {
  const _StepHeading({
    required this.title,
    required this.compact,
    this.supportingText,
  });

  final String title;
  final String? supportingText;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.displaySmall?.copyWith(
            fontSize: compact ? 28 : 34,
            height: 1.12,
            letterSpacing: -1,
          ),
        ),
        if (supportingText != null) ...[
          const SizedBox(height: MockMateSpacing.small),
          Text(supportingText!, style: Theme.of(context).textTheme.bodyLarge),
        ],
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.titleMedium?.copyWith(
        color: MockMateColors.textSecondary,
        fontSize: 13,
        letterSpacing: 0.5,
      ),
    );
  }
}

class _CareerProfileStep extends StatelessWidget {
  const _CareerProfileStep({
    required this.compact,
    required this.careerField,
    required this.experienceLevel,
    required this.onCareerFieldSelected,
    required this.onExperienceLevelSelected,
  });

  final bool compact;
  final CareerField? careerField;
  final ExperienceLevel? experienceLevel;
  final ValueChanged<CareerField> onCareerFieldSelected;
  final ValueChanged<ExperienceLevel> onExperienceLevelSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeading(
          compact: compact,
          title: 'What do you want to be known for?',
          supportingText:
              "Tell us where you're heading so MockMate can shape your practice around you.",
        ),
        SizedBox(height: compact ? 20 : MockMateSpacing.xLarge),
        const _SectionLabel('CAREER FIELD'),
        const SizedBox(height: MockMateSpacing.small),
        _CompactOptionGrid(
          children: CareerField.values
              .map(
                (value) => OnboardingOptionCard(
                  key: Key('careerField_${value.name}'),
                  title: value.label,
                  selected: careerField == value,
                  dense: true,
                  onTap: () => onCareerFieldSelected(value),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: MockMateSpacing.large),
        const _SectionLabel('EXPERIENCE LEVEL'),
        const SizedBox(height: MockMateSpacing.small),
        _CompactOptionGrid(
          children: ExperienceLevel.values
              .map(
                (value) => OnboardingOptionCard(
                  key: Key('experienceLevel_${value.name}'),
                  title: value.label,
                  selected: experienceLevel == value,
                  dense: true,
                  onTap: () => onExperienceLevelSelected(value),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _CareerGoalStep extends StatelessWidget {
  const _CareerGoalStep({
    required this.compact,
    required this.careerGoal,
    required this.onSelected,
  });

  final bool compact;
  final CareerGoal? careerGoal;
  final ValueChanged<CareerGoal> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeading(compact: compact, title: 'What are you preparing for?'),
        SizedBox(height: compact ? 20 : MockMateSpacing.xLarge),
        ...CareerGoal.values.map(
          (value) => Padding(
            padding: const EdgeInsets.only(bottom: MockMateSpacing.small),
            child: OnboardingOptionCard(
              key: Key('careerGoal_${value.name}'),
              title: value.label,
              subtitle: value.description,
              icon: _careerGoalIcon(value),
              selected: careerGoal == value,
              onTap: () => onSelected(value),
            ),
          ),
        ),
      ],
    );
  }
}

class _TargetRoleStep extends StatelessWidget {
  const _TargetRoleStep({
    required this.compact,
    required this.controller,
    required this.focusNode,
    required this.hasError,
    required this.onChanged,
    required this.onSubmitted,
  });

  final bool compact;
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool hasError;
  final ValueChanged<String> onChanged;
  final ValueChanged<String> onSubmitted;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeading(
          compact: compact,
          title: "What's the role you're aiming for?",
          supportingText: 'You can change this anytime later.',
        ),
        SizedBox(height: compact ? 24 : MockMateSpacing.xxLarge),
        const _SectionLabel('TARGET ROLE'),
        const SizedBox(height: MockMateSpacing.small),
        TextField(
          key: const Key('targetRoleField'),
          controller: controller,
          focusNode: focusNode,
          onChanged: onChanged,
          onSubmitted: onSubmitted,
          textInputAction: TextInputAction.done,
          textCapitalization: TextCapitalization.words,
          autocorrect: false,
          style: Theme.of(context).textTheme.titleMedium,
          decoration: InputDecoration(
            hintText: 'Junior Data Scientist',
            errorText: hasError ? 'Enter a target role to continue.' : null,
            prefixIcon: const Icon(Icons.work_outline_rounded),
          ),
        ),
        const SizedBox(height: MockMateSpacing.medium),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 2),
              child: Icon(
                Icons.tips_and_updates_outlined,
                size: 17,
                color: MockMateColors.cyan,
              ),
            ),
            const SizedBox(width: MockMateSpacing.xSmall),
            Expanded(
              child: Text(
                'A specific role helps MockMate tailor future interview practice.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _InterviewPreferencesStep extends StatelessWidget {
  const _InterviewPreferencesStep({
    required this.compact,
    required this.preferredLanguage,
    required this.preferredDifficulty,
    required this.onLanguageSelected,
    required this.onDifficultySelected,
  });

  final bool compact;
  final PreferredLanguage? preferredLanguage;
  final InterviewDifficulty? preferredDifficulty;
  final ValueChanged<PreferredLanguage> onLanguageSelected;
  final ValueChanged<InterviewDifficulty> onDifficultySelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _StepHeading(
          compact: compact,
          title: 'How should MockMate interview you?',
        ),
        SizedBox(height: compact ? 20 : MockMateSpacing.xLarge),
        const _SectionLabel('PREFERRED LANGUAGE'),
        const SizedBox(height: MockMateSpacing.small),
        ...PreferredLanguage.values.map(
          (value) => Padding(
            padding: const EdgeInsets.only(bottom: MockMateSpacing.small),
            child: OnboardingOptionCard(
              key: Key('preferredLanguage_${value.name}'),
              title: value.label,
              subtitle: value.description,
              icon: _languageIcon(value),
              selected: preferredLanguage == value,
              onTap: () => onLanguageSelected(value),
            ),
          ),
        ),
        const SizedBox(height: MockMateSpacing.medium),
        const _SectionLabel('INTERVIEW DIFFICULTY'),
        const SizedBox(height: MockMateSpacing.small),
        ...InterviewDifficulty.values.map(
          (value) => Padding(
            padding: const EdgeInsets.only(bottom: MockMateSpacing.small),
            child: OnboardingOptionCard(
              key: Key('preferredDifficulty_${value.name}'),
              title: value.label,
              subtitle: value.description,
              icon: _difficultyIcon(value),
              selected: preferredDifficulty == value,
              onTap: () => onDifficultySelected(value),
            ),
          ),
        ),
      ],
    );
  }
}

class _CompactOptionGrid extends StatelessWidget {
  const _CompactOptionGrid({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columnCount = constraints.maxWidth >= 680 ? 3 : 2;
        const gap = MockMateSpacing.small;
        final itemWidth =
            (constraints.maxWidth - gap * (columnCount - 1)) / columnCount;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: children
              .map((child) => SizedBox(width: itemWidth, child: child))
              .toList(),
        );
      },
    );
  }
}

class _OnboardingBackground extends StatelessWidget {
  const _OnboardingBackground();

  @override
  Widget build(BuildContext context) {
    return CustomPaint(painter: const _OnboardingBackgroundPainter());
  }
}

class _OnboardingBackgroundPainter extends CustomPainter {
  const _OnboardingBackgroundPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final glow = Paint()
      ..color = MockMateColors.primary.withValues(alpha: 0.07)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 100);
    canvas.drawCircle(Offset(size.width * 0.82, size.height * 0.12), 130, glow);

    final line = Paint()
      ..color = MockMateColors.outline.withValues(alpha: 0.22)
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(size.width * 0.08, 0),
      Offset(size.width * 0.34, size.height),
      line,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

IconData _careerGoalIcon(CareerGoal goal) => switch (goal) {
  CareerGoal.internship => Icons.school_outlined,
  CareerGoal.firstJob => Icons.rocket_launch_outlined,
  CareerGoal.careerSwitch => Icons.swap_horiz_rounded,
  CareerGoal.newOpportunity => Icons.trending_up_rounded,
  CareerGoal.promotion => Icons.workspace_premium_outlined,
};

IconData _languageIcon(PreferredLanguage language) => switch (language) {
  PreferredLanguage.english => Icons.language_rounded,
  PreferredLanguage.arabic => Icons.translate_rounded,
  PreferredLanguage.techArabish => Icons.forum_outlined,
};

IconData _difficultyIcon(InterviewDifficulty difficulty) =>
    switch (difficulty) {
      InterviewDifficulty.friendly => Icons.sentiment_satisfied_alt_rounded,
      InterviewDifficulty.realistic => Icons.tune_rounded,
      InterviewDifficulty.tough => Icons.bolt_rounded,
    };
