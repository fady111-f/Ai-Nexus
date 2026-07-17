import 'package:flutter/material.dart';
import 'package:mockmate/core/routing/app_routes.dart';
import 'package:mockmate/features/auth/domain/auth_service.dart';
import 'package:mockmate/features/auth/presentation/pages/sign_in_page.dart';
import 'package:mockmate/features/home/presentation/pages/home_page.dart';
import 'package:mockmate/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:mockmate/features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/cv_manager/cv_manager_screen.dart';
import '../../features/live_interview/live_interview_screen.dart';
import '../../features/results/results_screen.dart';

class AppRouter {
  const AppRouter({
    required this.authService,
    required this.onboardingRepository,
  });

  final AuthService authService;
  final OnboardingRepository onboardingRepository;

  Route<void> onGenerateRoute(RouteSettings settings) {
    final page = switch (settings.name) {
      AppRoutes.home => HomePage(onboardingRepository: onboardingRepository),
      AppRoutes.onboarding => OnboardingPage(
        onboardingRepository: onboardingRepository,
      ),
      AppRoutes.signIn || null => SignInPage(
        authService: authService,
        onboardingRepository: onboardingRepository,
      ),
      AppRoutes.profile => const ProfileScreen(),
      AppRoutes.cvManager => const CVManagerScreen(),
      AppRoutes.liveInterview => const LiveInterviewScreen(),
      AppRoutes.results => const ResultsScreen(),
      _ => SignInPage(
        authService: authService,
        onboardingRepository: onboardingRepository,
      ),
    };

    return MaterialPageRoute<void>(builder: (_) => page, settings: settings);
  }
}
