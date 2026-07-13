import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/home/presentation/pages/home_page.dart';
import 'package:mockmate/features/onboarding/domain/models/user_profile.dart';

import '../../support/fake_onboarding_repository.dart';

void main() {
  testWidgets('home loads and displays the saved onboarding profile', (
    tester,
  ) async {
    await _pumpHome(
      tester,
      FakeOnboardingRepository(savedProfile: sampleUserProfile),
    );

    expect(find.byKey(const Key('homeDashboard')), findsOne);
    expect(find.text('Ready for your next interview?'), findsOne);
    expect(find.text('Junior Data Scientist'), findsWidgets);
    expect(find.text('Tech-Arabish'), findsWidgets);
    expect(find.text('Realistic'), findsWidgets);
    expect(find.text('Data Science'), findsOne);
    expect(find.text('Junior'), findsOne);
  });

  testWidgets('home shows truthful zero stats and intentional empty states', (
    tester,
  ) async {
    await _pumpHome(
      tester,
      FakeOnboardingRepository(savedProfile: sampleUserProfile),
    );

    expect(find.byKey(const Key('interviewDnaEmptyState')), findsOne);
    expect(
      find.text(
        'Complete your first mock interview to unlock your personalized performance profile.',
      ),
      findsOne,
    );
    expect(find.byKey(const Key('recentInterviewEmptyState')), findsOne);
    expect(find.text('No interviews yet'), findsOne);
    expect(find.byKey(const Key('interviewsStatValue')), findsOne);
    expect(find.text('0'), findsOne);
    expect(find.byKey(const Key('practiceTimeStatValue')), findsOne);
    expect(find.text('0 min'), findsOne);
    expect(find.byKey(const Key('bestScoreStatValue')), findsOne);
    expect(find.text('—'), findsOne);
    expect(find.textContaining('%'), findsNothing);
    expect(find.textContaining('streak', findRichText: true), findsNothing);
  });

  testWidgets('both interview CTAs use the same temporary interaction', (
    tester,
  ) async {
    await _pumpHome(
      tester,
      FakeOnboardingRepository(savedProfile: sampleUserProfile),
    );

    final mainButton = find.byKey(const Key('startInterviewButton'));
    await tester.ensureVisible(mainButton);
    await tester.tap(mainButton);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('interviewSetupComingSoonSheet')), findsOne);
    expect(find.text('Interview setup is coming next.'), findsOne);

    await tester.tap(find.byKey(const Key('dismissInterviewSetupSheetButton')));
    await tester.pumpAndSettle();

    final recentButton = find.byKey(const Key('startFirstInterviewButton'));
    await tester.ensureVisible(recentButton);
    await tester.pumpAndSettle();
    await tester.tap(recentButton);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('interviewSetupComingSoonSheet')), findsOne);
    expect(find.text('Interview setup is coming next.'), findsOne);
  });

  testWidgets('home shows a safe recovery state when profile is missing', (
    tester,
  ) async {
    await _pumpHome(tester, FakeOnboardingRepository());

    expect(find.text('Your setup is incomplete.'), findsOne);
    expect(find.byKey(const Key('returnToOnboardingButton')), findsOne);
    expect(find.byKey(const Key('homeDashboard')), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('home retries after a profile loading failure', (tester) async {
    final repository = FakeOnboardingRepository(
      failLoad: true,
      savedProfile: sampleUserProfile,
    );
    await _pumpHome(tester, repository);

    expect(find.text("We couldn't load your profile."), findsOne);
    repository.failLoad = false;
    await tester.tap(find.byKey(const Key('homeRetryButton')));
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('homeDashboard')), findsOne);
    expect(find.text('Junior Data Scientist'), findsWidgets);
  });

  testWidgets('home presents a branded skeleton while profile is loading', (
    tester,
  ) async {
    final repository = _DeferredOnboardingRepository();
    await tester.pumpWidget(
      MaterialApp(
        theme: MockMateTheme.dark,
        home: HomePage(onboardingRepository: repository),
      ),
    );

    expect(find.byKey(const Key('homeLoadingState')), findsOne);
    expect(find.byType(CircularProgressIndicator), findsNothing);

    repository.completer.complete(sampleUserProfile);
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('homeDashboard')), findsOne);
  });

  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(844, 390),
    const Size(1024, 768),
  ]) {
    testWidgets(
      'home dashboard avoids overflow at ${size.width}x${size.height}',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await _pumpHome(
          tester,
          FakeOnboardingRepository(savedProfile: sampleUserProfile),
        );

        expect(tester.takeException(), isNull);
        expect(find.byKey(const Key('homeDashboard')), findsOne);
        expect(find.byType(CustomScrollView), findsOne);
      },
    );
  }
}

Future<void> _pumpHome(
  WidgetTester tester,
  FakeOnboardingRepository repository,
) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: MockMateTheme.dark,
      home: HomePage(onboardingRepository: repository),
    ),
  );
  await tester.pumpAndSettle();
}

class _DeferredOnboardingRepository extends FakeOnboardingRepository {
  final completer = Completer<UserProfile?>();

  @override
  Future<UserProfile?> loadUserProfile() => completer.future;
}
