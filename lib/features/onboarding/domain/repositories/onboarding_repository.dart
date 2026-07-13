import 'package:mockmate/features/onboarding/domain/models/user_profile.dart';

abstract interface class OnboardingRepository {
  Future<void> saveUserProfile(UserProfile profile);

  Future<UserProfile?> loadUserProfile();

  Future<void> markOnboardingCompleted();

  Future<bool> isOnboardingCompleted();
}
