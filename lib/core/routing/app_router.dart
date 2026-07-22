import 'package:flutter/material.dart';
import 'package:mockmate/core/routing/app_routes.dart';
import 'package:mockmate/core/routing/replay_route_arguments.dart';
import 'package:mockmate/features/auth/domain/auth_service.dart';
import 'package:mockmate/features/auth/presentation/pages/sign_in_page.dart';
import 'package:mockmate/features/home/presentation/pages/home_page.dart';
import 'package:mockmate/features/interviews/domain/repositories/interview_repository.dart';
import 'package:mockmate/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:mockmate/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:mockmate/features/progress/presentation/pages/progress_page.dart';
import 'package:mockmate/features/replay/presentation/pages/interview_replay_page.dart';
import '../../features/profile/profile_screen.dart';
import '../../features/cv_manager/cv_manager_screen.dart';
import '../../features/live_interview/live_interview_screen.dart';
import '../../features/live_interview/presentation/pages/interview_setup_screen.dart';
import '../../features/live_interview/presentation/pages/pre_interview_lobby_screen.dart';
import '../../features/results/results_screen.dart';

class AppRouter {
  const AppRouter({
    required this.authService,
    required this.onboardingRepository,
    required this.interviewRepository,
  });

  final AuthService authService;
  final OnboardingRepository onboardingRepository;
  final InterviewRepository interviewRepository;

  Route<void> onGenerateRoute(RouteSettings settings) {
    final page = switch (settings.name) {
      AppRoutes.home => HomePage(
          onboardingRepository: onboardingRepository,
          interviewRepository: interviewRepository,
        ),
      AppRoutes.onboarding => OnboardingPage(
          onboardingRepository: onboardingRepository,
        ),
      AppRoutes.signIn || null => SignInPage(
          authService: authService,
          onboardingRepository: onboardingRepository,
        ),
      AppRoutes.profile => ProfileScreen(
          onboardingRepository: onboardingRepository,
          interviewRepository: interviewRepository,
          authService: authService,
        ),
      AppRoutes.cvManager => const CVManagerScreen(),
      AppRoutes.setup => const InterviewSetupScreen(),
      AppRoutes.lobby => PreInterviewLobbyScreen(
          config: settings.arguments is InterviewSetupConfig
              ? settings.arguments as InterviewSetupConfig
              : null,
        ),
      AppRoutes.liveInterview => const LiveInterviewScreen(),
      AppRoutes.results => const ResultsScreen(),
      AppRoutes.progress => ProgressPage(
          interviewRepository: interviewRepository,
        ),
      AppRoutes.replay => _buildReplayPage(settings),
      _ => SignInPage(
          authService: authService,
          onboardingRepository: onboardingRepository,
        ),
    };

    return MaterialPageRoute<void>(builder: (_) => page, settings: settings);
  }

  Widget _buildReplayPage(RouteSettings settings) {
    final args = settings.arguments;
    if (args is ReplayRouteArguments) {
      return InterviewReplayPage(
        sessionId: args.sessionId,
        interviewRepository: interviewRepository,
      );
    }
    // Missing or invalid arguments — show error state.
    return InterviewReplayPage(
      sessionId: '',
      interviewRepository: interviewRepository,
    );
  }
}
