import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mockmate/app/mockmate_app.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/auth/data/firebase_auth_service.dart';
import 'package:mockmate/features/auth/data/temporary_auth_service.dart';
import 'package:mockmate/features/auth/domain/auth_service.dart';
import 'package:mockmate/features/interviews/data/local_interview_repository.dart';
import 'package:mockmate/features/onboarding/data/local_onboarding_service.dart';
import 'package:mockmate/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: MockMateColors.background,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  AuthService authService;
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    authService = FirebaseAuthService();
  } catch (e) {
    debugPrint('Firebase initialization: $e. Using TemporaryAuthService.');
    authService = TemporaryAuthService();
  }

  runApp(
    MockMateApp(
      authService: authService,
      onboardingRepository: LocalOnboardingService(),
      interviewRepository: LocalInterviewRepository(),
    ),
  );
}

