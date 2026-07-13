import 'package:flutter_test/flutter_test.dart';
import 'package:mockmate/features/onboarding/data/local_onboarding_service.dart';
import 'package:mockmate/features/onboarding/domain/models/user_profile.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  const profile = UserProfile(
    careerField: CareerField.dataScience,
    experienceLevel: ExperienceLevel.freshGraduate,
    careerGoal: CareerGoal.firstJob,
    targetRole: 'Junior Data Scientist',
    preferredLanguage: PreferredLanguage.techArabish,
    preferredDifficulty: InterviewDifficulty.realistic,
  );

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('profile and completion survive a new service instance', () async {
    final service = LocalOnboardingService();
    expect(await service.isOnboardingCompleted(), isFalse);

    await service.saveUserProfile(profile);
    await service.markOnboardingCompleted();

    final serviceAfterRestart = LocalOnboardingService();
    final restored = await serviceAfterRestart.loadUserProfile();

    expect(await serviceAfterRestart.isOnboardingCompleted(), isTrue);
    expect(restored, isNotNull);
    expect(restored!.careerField, CareerField.dataScience);
    expect(restored.experienceLevel, ExperienceLevel.freshGraduate);
    expect(restored.careerGoal, CareerGoal.firstJob);
    expect(restored.targetRole, 'Junior Data Scientist');
    expect(restored.preferredLanguage, PreferredLanguage.techArabish);
    expect(restored.preferredDifficulty, InterviewDifficulty.realistic);
  });

  test('malformed persisted data is treated as incomplete', () async {
    SharedPreferences.setMockInitialValues({
      LocalOnboardingService.completionStorageKey: true,
      LocalOnboardingService.profileStorageKey:
          '{"careerField":"unknown","targetRole":4}',
    });
    final service = LocalOnboardingService();

    expect(await service.loadUserProfile(), isNull);
    expect(await service.isOnboardingCompleted(), isFalse);
  });
}
