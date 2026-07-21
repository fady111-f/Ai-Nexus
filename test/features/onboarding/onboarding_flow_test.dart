import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockmate/app/mockmate_app.dart';
import 'package:mockmate/features/auth/data/temporary_auth_service.dart';
import 'package:mockmate/features/onboarding/domain/models/user_profile.dart';

import '../../support/fake_onboarding_repository.dart';
import '../../support/fake_interview_repository.dart';

void main() {
  testWidgets('step navigation and back move through the controlled flow', (
    tester,
  ) async {
    await _enterOnboarding(tester, FakeOnboardingRepository());

    await _completeCareerProfile(tester);
    expect(find.text('What are you preparing for?'), findsOne);
    expect(find.text('Step 2 of 4'), findsOne);

    await tester.tap(find.byKey(const Key('onboardingBackButton')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();
    expect(find.text('What do you want to be known for?'), findsOne);
    expect(find.text('Step 1 of 4'), findsOne);
  });

  testWidgets('system back moves to the previous onboarding step', (
    tester,
  ) async {
    await _enterOnboarding(tester, FakeOnboardingRepository());
    await _completeCareerProfile(tester);

    await tester.binding.handlePopRoute();
    await tester.pumpAndSettle();

    expect(find.text('What do you want to be known for?'), findsOne);
  });

  testWidgets('back on step one returns to sign-in', (tester) async {
    await _enterOnboarding(tester, FakeOnboardingRepository());

    await tester.tap(find.byKey(const Key('onboardingBackButton')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump();

    expect(find.text('Sign In'), findsOne);
    expect(find.text('What do you want to be known for?'), findsNothing);
  });

  testWidgets('target role cannot continue when empty', (tester) async {
    await _enterOnboarding(tester, FakeOnboardingRepository());
    await _reachTargetRole(tester);

    await tester.tap(find.byKey(const Key('onboardingContinueButton')));
    await tester.pumpAndSettle();

    expect(find.text('Enter a target role to continue.'), findsOne);
    expect(find.text("What's the role you're aiming for?"), findsOne);
    expect(find.text('Step 3 of 4'), findsOne);
  });

  testWidgets('completion saves profile, marks complete, and clears history', (
    tester,
  ) async {
    final repository = FakeOnboardingRepository();
    await _enterOnboarding(tester, repository);
    await _completeAllSteps(tester);

    expect(find.byKey(const Key('homeDashboard')), findsOne);
    expect(repository.completed, isTrue);
    expect(repository.savedProfile, isNotNull);
    expect(repository.savedProfile!.careerField, CareerField.dataScience);
    expect(
      repository.savedProfile!.experienceLevel,
      ExperienceLevel.freshGraduate,
    );
    expect(repository.savedProfile!.careerGoal, CareerGoal.firstJob);
    expect(repository.savedProfile!.targetRole, 'Junior Data Scientist');
    expect(
      repository.savedProfile!.preferredLanguage,
      PreferredLanguage.techArabish,
    );
    expect(
      repository.savedProfile!.preferredDifficulty,
      InterviewDifficulty.realistic,
    );

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    expect(navigator.canPop(), isFalse);

    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(find.byKey(const Key('homeDashboard')), findsOne);
    expect(find.text('How should MockMate interview you?'), findsNothing);
  });

  testWidgets('persistence failure is shown without leaving onboarding', (
    tester,
  ) async {
    final repository = FakeOnboardingRepository(failSave: true);
    await _enterOnboarding(tester, repository);
    await _reachPreferences(tester);
    await _selectPreferenceOptions(tester);

    await tester.tap(find.byKey(const Key('onboardingContinueButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('onboardingPersistenceError')), findsOne);
    expect(find.text('How should MockMate interview you?'), findsOne);
    expect(find.byKey(const Key('homeDashboard')), findsNothing);
  });

  testWidgets('target role remains usable with a small-phone keyboard inset', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await _enterOnboarding(tester, FakeOnboardingRepository());
    await _reachTargetRole(tester);

    tester.view.viewInsets = const FakeViewPadding(bottom: 260);
    addTearDown(tester.view.resetViewInsets);
    await tester.tap(find.byKey(const Key('targetRoleField')));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(
      find.byKey(const Key('onboardingContinueButton')).hitTestable(),
      findsOne,
    );
  });

  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(844, 390),
    const Size(1024, 768),
  ]) {
    testWidgets(
      'all onboarding steps avoid overflow at ${size.width}x${size.height}',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await _enterOnboarding(tester, FakeOnboardingRepository());
        expect(tester.takeException(), isNull);
        expect(find.byKey(const Key('onboardingContinueButton')), findsOne);

        await _completeCareerProfile(tester);
        expect(tester.takeException(), isNull);

        await _selectVisible(tester, const Key('careerGoal_firstJob'));
        await _continue(tester);
        expect(tester.takeException(), isNull);

        await tester.enterText(
          find.byKey(const Key('targetRoleField')),
          'Junior Data Scientist',
        );
        await _continue(tester);
        expect(tester.takeException(), isNull);

        expect(find.text('How should MockMate interview you?'), findsOne);
        expect(find.byKey(const Key('onboardingContinueButton')), findsOne);
      },
    );
  }
}

Future<void> _enterOnboarding(
  WidgetTester tester,
  FakeOnboardingRepository repository,
) async {
  await tester.pumpWidget(
    MockMateApp(
      authService: TemporaryAuthService(),
      onboardingRepository: repository,
      interviewRepository: FakeInterviewRepository(),
    ),
  );
  final signInButton = find.byKey(const Key('signInButton'));
  await tester.ensureVisible(signInButton);
  await tester.pump();
  await tester.tap(signInButton);
  await tester.pumpAndSettle();
  expect(find.text('What do you want to be known for?'), findsOne);
}

Future<void> _completeCareerProfile(WidgetTester tester) async {
  await _selectVisible(tester, const Key('careerField_dataScience'));
  await _selectVisible(tester, const Key('experienceLevel_freshGraduate'));
  await _continue(tester);
}

Future<void> _reachTargetRole(WidgetTester tester) async {
  await _completeCareerProfile(tester);
  await _selectVisible(tester, const Key('careerGoal_firstJob'));
  await _continue(tester);
}

Future<void> _reachPreferences(WidgetTester tester) async {
  await _reachTargetRole(tester);
  await tester.enterText(
    find.byKey(const Key('targetRoleField')),
    'Junior Data Scientist',
  );
  await _continue(tester);
}

Future<void> _selectPreferenceOptions(WidgetTester tester) async {
  await _selectVisible(tester, const Key('preferredLanguage_techArabish'));
  await _selectVisible(tester, const Key('preferredDifficulty_realistic'));
}

Future<void> _completeAllSteps(WidgetTester tester) async {
  await _reachPreferences(tester);
  await _selectPreferenceOptions(tester);
  await _continue(tester);
}

Future<void> _selectVisible(WidgetTester tester, Key key) async {
  final finder = find.byKey(key);
  await tester.ensureVisible(finder);
  await tester.pump();
  await tester.tap(finder);
  await tester.pump();
}

Future<void> _continue(WidgetTester tester) async {
  final button = find.byKey(const Key('onboardingContinueButton'));
  await tester.ensureVisible(button);
  await tester.tap(button);
  await tester.pumpAndSettle();
}
