import 'dart:convert';

import 'package:mockmate/features/onboarding/domain/models/user_profile.dart';
import 'package:mockmate/features/onboarding/domain/repositories/onboarding_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalOnboardingService implements OnboardingRepository {
  static const profileStorageKey = 'mockmate_onboarding_profile';
  static const completionStorageKey = 'mockmate_onboarding_completed';

  Future<SharedPreferences> get _preferences => SharedPreferences.getInstance();

  @override
  Future<bool> isOnboardingCompleted() async {
    final preferences = await _preferences;
    if (!(preferences.getBool(completionStorageKey) ?? false)) {
      return false;
    }

    return await loadUserProfile() != null;
  }

  @override
  Future<UserProfile?> loadUserProfile() async {
    final preferences = await _preferences;
    final storedProfile = preferences.getString(profileStorageKey);
    if (storedProfile == null) {
      return null;
    }

    try {
      final decodedProfile = jsonDecode(storedProfile);
      if (decodedProfile is! Map<String, dynamic>) {
        return null;
      }
      return UserProfile.fromJson(decodedProfile);
    } on FormatException {
      return null;
    } on TypeError {
      return null;
    }
  }

  @override
  Future<void> markOnboardingCompleted() async {
    final preferences = await _preferences;
    final saved = await preferences.setBool(completionStorageKey, true);
    if (!saved) {
      throw StateError('Unable to store onboarding completion.');
    }
  }

  @override
  Future<void> saveUserProfile(UserProfile profile) async {
    final preferences = await _preferences;
    final saved = await preferences.setString(
      profileStorageKey,
      jsonEncode(profile.toJson()),
    );
    if (!saved) {
      throw StateError('Unable to store the user profile.');
    }
  }
}
