enum CareerField {
  softwareEngineering,
  dataScience,
  aiMachineLearning,
  cybersecurity,
  productManagement,
  uiUxDesign,
  other,
}

enum ExperienceLevel { student, freshGraduate, junior, midLevel, senior }

enum CareerGoal {
  internship,
  firstJob,
  careerSwitch,
  newOpportunity,
  promotion,
}

enum PreferredLanguage { english, arabic, techArabish }

enum InterviewDifficulty { friendly, realistic, tough }

extension CareerFieldLabel on CareerField {
  String get label => switch (this) {
    CareerField.softwareEngineering => 'Software Engineering',
    CareerField.dataScience => 'Data Science',
    CareerField.aiMachineLearning => 'AI / Machine Learning',
    CareerField.cybersecurity => 'Cybersecurity',
    CareerField.productManagement => 'Product Management',
    CareerField.uiUxDesign => 'UI / UX Design',
    CareerField.other => 'Other',
  };
}

extension ExperienceLevelLabel on ExperienceLevel {
  String get label => switch (this) {
    ExperienceLevel.student => 'Student',
    ExperienceLevel.freshGraduate => 'Fresh Graduate',
    ExperienceLevel.junior => 'Junior',
    ExperienceLevel.midLevel => 'Mid-Level',
    ExperienceLevel.senior => 'Senior',
  };
}

extension CareerGoalLabel on CareerGoal {
  String get label => switch (this) {
    CareerGoal.internship => 'Internship',
    CareerGoal.firstJob => 'First Job',
    CareerGoal.careerSwitch => 'Career Switch',
    CareerGoal.newOpportunity => 'New Opportunity',
    CareerGoal.promotion => 'Promotion',
  };

  String get description => switch (this) {
    CareerGoal.internship =>
      'Build confidence for your first professional interviews.',
    CareerGoal.firstJob => 'Turn preparation into your first full-time offer.',
    CareerGoal.careerSwitch =>
      'Translate your experience into a new direction.',
    CareerGoal.newOpportunity => 'Level up for the role that comes next.',
    CareerGoal.promotion => 'Show that you are ready for more responsibility.',
  };
}

extension PreferredLanguageLabel on PreferredLanguage {
  String get label => switch (this) {
    PreferredLanguage.english => 'English',
    PreferredLanguage.arabic => 'Arabic',
    PreferredLanguage.techArabish => 'Tech-Arabish',
  };

  String? get description => switch (this) {
    PreferredLanguage.techArabish =>
      'English + Egyptian Arabic, the way tech interviews actually happen.',
    _ => null,
  };
}

extension InterviewDifficultyLabel on InterviewDifficulty {
  String get label => switch (this) {
    InterviewDifficulty.friendly => 'Friendly',
    InterviewDifficulty.realistic => 'Realistic',
    InterviewDifficulty.tough => 'Tough',
  };

  String get description => switch (this) {
    InterviewDifficulty.friendly => 'Supportive and relaxed.',
    InterviewDifficulty.realistic => 'Balanced and close to a real interview.',
    InterviewDifficulty.tough => 'Direct, challenging, and less forgiving.',
  };
}

class UserProfile {
  const UserProfile({
    required this.careerField,
    required this.experienceLevel,
    required this.careerGoal,
    required this.targetRole,
    required this.preferredLanguage,
    required this.preferredDifficulty,
  });

  final CareerField careerField;
  final ExperienceLevel experienceLevel;
  final CareerGoal careerGoal;
  final String targetRole;
  final PreferredLanguage preferredLanguage;
  final InterviewDifficulty preferredDifficulty;

  Map<String, Object> toJson() => {
    'careerField': careerField.name,
    'experienceLevel': experienceLevel.name,
    'careerGoal': careerGoal.name,
    'targetRole': targetRole.trim(),
    'preferredLanguage': preferredLanguage.name,
    'preferredDifficulty': preferredDifficulty.name,
  };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final targetRole = json['targetRole'];
    if (targetRole is! String || targetRole.trim().isEmpty) {
      throw const FormatException('Invalid target role.');
    }

    return UserProfile(
      careerField: _enumFromName(
        CareerField.values,
        json['careerField'],
        'careerField',
      ),
      experienceLevel: _enumFromName(
        ExperienceLevel.values,
        json['experienceLevel'],
        'experienceLevel',
      ),
      careerGoal: _enumFromName(
        CareerGoal.values,
        json['careerGoal'],
        'careerGoal',
      ),
      targetRole: targetRole.trim(),
      preferredLanguage: _enumFromName(
        PreferredLanguage.values,
        json['preferredLanguage'],
        'preferredLanguage',
      ),
      preferredDifficulty: _enumFromName(
        InterviewDifficulty.values,
        json['preferredDifficulty'],
        'preferredDifficulty',
      ),
    );
  }
}

T _enumFromName<T extends Enum>(
  List<T> values,
  Object? storedValue,
  String fieldName,
) {
  if (storedValue is String) {
    for (final value in values) {
      if (value.name == storedValue) {
        return value;
      }
    }
  }
  throw FormatException('Invalid $fieldName.');
}
