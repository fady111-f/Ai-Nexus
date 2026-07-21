import 'package:flutter/material.dart';
import 'package:mockmate/core/routing/app_router.dart';
import 'package:mockmate/core/routing/app_routes.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/auth/domain/auth_service.dart';
import 'package:mockmate/features/interviews/domain/repositories/interview_repository.dart';
import 'package:mockmate/features/onboarding/domain/repositories/onboarding_repository.dart';

class MockMateApp extends StatelessWidget {
  const MockMateApp({
    required this.authService,
    required this.onboardingRepository,
    required this.interviewRepository,
    super.key,
  });

  final AuthService authService;
  final OnboardingRepository onboardingRepository;
  final InterviewRepository interviewRepository;

  @override
  Widget build(BuildContext context) {
    final router = AppRouter(
      authService: authService,
      onboardingRepository: onboardingRepository,
      interviewRepository: interviewRepository,
    );

    return MaterialApp(
      title: 'Gahez?',
      debugShowCheckedModeBanner: false,
      theme: MockMateTheme.dark,
      initialRoute: AppRoutes.signIn,
      onGenerateRoute: router.onGenerateRoute,
    );
  }
}
