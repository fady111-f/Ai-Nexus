import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mockmate/app/mockmate_app.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/auth/data/temporary_auth_service.dart';
import 'package:mockmate/features/interviews/data/local_interview_repository.dart';
import 'package:mockmate/features/onboarding/data/local_onboarding_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: MockMateColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  runApp(
    MockMateApp(
      authService: TemporaryAuthService(),
      onboardingRepository: LocalOnboardingService(),
      interviewRepository: LocalInterviewRepository(),
    ),
  );
}
