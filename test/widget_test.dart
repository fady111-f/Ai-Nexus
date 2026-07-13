import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockmate/app/mockmate_app.dart';
import 'package:mockmate/features/auth/data/temporary_auth_service.dart';

import 'support/fake_onboarding_repository.dart';

void main() {
  testWidgets('launches on the preserved sign-in screen', (tester) async {
    await tester.pumpWidget(
      MockMateApp(
        authService: TemporaryAuthService(),
        onboardingRepository: FakeOnboardingRepository(),
      ),
    );

    expect(
      find.text('Your toughest interview\nbefore the real one.'),
      findsOne,
    );
    expect(find.text('Sign In'), findsOne);
    expect(find.text('Continue as Guest'), findsOne);
  });

  for (final buttonKey in ['signInButton', 'guestButton']) {
    testWidgets('$buttonKey authenticates a new user and opens onboarding', (
      tester,
    ) async {
      final authService = TemporaryAuthService();
      await tester.pumpWidget(
        MockMateApp(
          authService: authService,
          onboardingRepository: FakeOnboardingRepository(),
        ),
      );

      await tester.tap(find.byKey(Key(buttonKey)));
      await tester.pumpAndSettle();

      expect(find.text('What do you want to be known for?'), findsOne);
      expect(await authService.isAuthenticated(), isTrue);
    });
  }

  testWidgets('completed onboarding routes sign-in directly to home', (
    tester,
  ) async {
    final authService = TemporaryAuthService();
    await tester.pumpWidget(
      MockMateApp(
        authService: authService,
        onboardingRepository: FakeOnboardingRepository(
          completed: true,
          savedProfile: sampleUserProfile,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byKey(const Key('homeDashboard')), findsOne);
    expect(find.text('What do you want to be known for?'), findsNothing);
    expect(await authService.isAuthenticated(), isTrue);

    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    expect(navigator.canPop(), isFalse);
  });

  testWidgets('sign-in handles a local completion check failure', (
    tester,
  ) async {
    await tester.pumpWidget(
      MockMateApp(
        authService: TemporaryAuthService(),
        onboardingRepository: FakeOnboardingRepository(
          failCompletionCheck: true,
        ),
      ),
    );

    await tester.tap(find.byKey(const Key('signInButton')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.byKey(const Key('signInEntryError')), findsOne);
    expect(find.text('Sign In'), findsOne);
  });

  for (final size in [
    const Size(320, 568),
    const Size(390, 844),
    const Size(844, 390),
    const Size(1024, 768),
  ]) {
    testWidgets(
      'sign-in layout has no overflow at ${size.width}x${size.height}',
      (tester) async {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          MockMateApp(
            authService: TemporaryAuthService(),
            onboardingRepository: FakeOnboardingRepository(),
          ),
        );
        await tester.pump(const Duration(milliseconds: 100));

        expect(tester.takeException(), isNull);
        expect(find.byKey(const Key('signInButton')), findsOne);
      },
    );
  }
}
