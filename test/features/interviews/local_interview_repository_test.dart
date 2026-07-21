import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockmate/features/interviews/data/local_interview_repository.dart';
import 'package:mockmate/features/interviews/domain/models/interview_session.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late LocalInterviewRepository repository;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    repository = LocalInterviewRepository();
  });

  group('LocalInterviewRepository', () {
    test('returns empty list when no data exists', () async {
      final sessions = await repository.getSessions();
      expect(sessions, isEmpty);
    });

    test('recovers gracefully from corrupted JSON string', () async {
      SharedPreferences.setMockInitialValues({
        LocalInterviewRepository.storageKey: '{ bad json',
      });

      final sessions = await repository.getSessions();
      expect(sessions, isEmpty);

      // Verify the bad data was cleared
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.containsKey(LocalInterviewRepository.storageKey), false);
    });

    test('recovers gracefully from wrong preference type', () async {
      SharedPreferences.setMockInitialValues({
        LocalInterviewRepository.storageKey: 42, // int instead of String
      });

      final sessions = await repository.getSessions();
      expect(sessions, isEmpty);
    });

    test('ignores future schema versions', () async {
      SharedPreferences.setMockInitialValues({
        LocalInterviewRepository.storageKey: jsonEncode({
          'schemaVersion': 999, // Future version
          'sessions': [],
        }),
      });

      final sessions = await repository.getSessions();
      expect(sessions, isEmpty);
    });

    test('saves and retrieves a session correctly', () async {
      final session = InterviewSession(
        id: 'test-1',
        jobTitle: 'Developer',
        startedAt: DateTime.now(),
        duration: const Duration(minutes: 10),
        interviewType: InterviewType.mixed,
        difficulty: 'Realistic',
        language: 'English',
        createdAt: DateTime.now(),
      );

      await repository.saveSession(session);

      final loaded = await repository.getSessions();
      expect(loaded.length, 1);
      expect(loaded.first.id, 'test-1');
    });

    test('seedDemoSessions populates database and clears them', () async {
      await repository.seedDemoSessions();
      final seeded = await repository.getSessions();
      
      expect(seeded, isNotEmpty);
      expect(seeded.every((s) => s.isDemo), isTrue);

      await repository.clearDemoSessions();
      final cleared = await repository.getSessions();
      expect(cleared, isEmpty);
    });
  });
}
