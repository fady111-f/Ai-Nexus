import 'package:mockmate/features/onboarding/domain/models/user_profile.dart';
import 'package:mockmate/features/onboarding/domain/repositories/onboarding_repository.dart';

const sampleUserProfile = UserProfile(
  careerField: CareerField.dataScience,
  experienceLevel: ExperienceLevel.junior,
  careerGoal: CareerGoal.newOpportunity,
  targetRole: 'Junior Data Scientist',
  preferredLanguage: PreferredLanguage.techArabish,
  preferredDifficulty: InterviewDifficulty.realistic,
);

class FakeOnboardingRepository implements OnboardingRepository {
  FakeOnboardingRepository({
    this.completed = false,
    this.failCompletionCheck = false,
    this.failSave = false,
    this.failLoad = false,
    this.savedProfile,
  });

  bool completed;
  bool failCompletionCheck;
  bool failSave;
  bool failLoad;
  UserProfile? savedProfile;

  @override
  Future<bool> isOnboardingCompleted() async {
    if (failCompletionCheck) {
      throw StateError('Completion check failed.');
    }
    return completed;
  }

  @override
  Future<UserProfile?> loadUserProfile() async {
    if (failLoad) {
      throw StateError('Profile load failed.');
    }
    return savedProfile;
  }

  @override
  Future<void> markOnboardingCompleted() async {
    if (failSave) {
      throw StateError('Completion write failed.');
    }
    completed = true;
  }

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    if (failSave) {
      throw StateError('Profile write failed.');
    }
    savedProfile = profile;
  }
}
