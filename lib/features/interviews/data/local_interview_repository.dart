import 'dart:convert';

import 'package:mockmate/features/interviews/data/demo_interview_seeder.dart';
import 'package:mockmate/features/interviews/domain/models/interview_session.dart';
import 'package:mockmate/features/interviews/domain/repositories/interview_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// SharedPreferences-backed [InterviewRepository] for local storage.
///
/// Uses a single namespaced key with a versioned JSON envelope.
/// Handles malformed JSON, wrong preference types, and missing data
/// gracefully — never crashes from corrupted local storage.
class LocalInterviewRepository implements InterviewRepository {
  /// The SharedPreferences key used for all interview session data.
  static const storageKey = 'mockmate_interview_sessions_v1';

  Future<SharedPreferences> get _preferences =>
      SharedPreferences.getInstance();

  @override
  Future<List<InterviewSession>> getSessions() async {
    final sessions = await _loadAll();
    sessions.sort((a, b) => b.startedAt.compareTo(a.startedAt));
    return sessions;
  }

  @override
  Future<InterviewSession?> getSessionById(String id) async {
    final sessions = await _loadAll();
    for (final session in sessions) {
      if (session.id == id) return session;
    }
    return null;
  }

  @override
  Future<void> saveSession(InterviewSession session) async {
    final sessions = await _loadAll();
    final index = sessions.indexWhere((s) => s.id == session.id);
    if (index >= 0) {
      sessions[index] = session;
    } else {
      sessions.add(session);
    }
    await _saveAll(sessions);
  }

  @override
  Future<void> deleteSession(String id) async {
    final sessions = await _loadAll();
    sessions.removeWhere((s) => s.id == id);
    await _saveAll(sessions);
  }

  @override
  Future<void> updateQuestionBookmark({
    required String sessionId,
    required String questionId,
    required bool isBookmarked,
  }) async {
    final sessions = await _loadAll();
    final sessionIndex =
        sessions.indexWhere((s) => s.id == sessionId);
    if (sessionIndex < 0) return;

    final session = sessions[sessionIndex];
    final updatedQuestions = session.questions.map((q) {
      if (q.id == questionId) {
        return q.copyWith(isBookmarked: isBookmarked);
      }
      return q;
    }).toList();

    sessions[sessionIndex] = session.copyWith(
      questions: updatedQuestions,
    );
    await _saveAll(sessions);
  }

  @override
  Future<void> seedDemoSessions() async {
    final seeder = DemoInterviewSeeder(this);
    await seeder.seed();
  }

  @override
  Future<void> clearDemoSessions() async {
    final sessions = await _loadAll();
    sessions.removeWhere((s) => s.isDemo);
    await _saveAll(sessions);
  }

  // ── Private helpers ──────────────────────────────────────────────

  Future<List<InterviewSession>> _loadAll() async {
    final preferences = await _preferences;
    final raw = preferences.get(storageKey);

    // Handle wrong preference type (not a String).
    if (raw == null) return [];
    if (raw is! String) {
      // Corrupted — clear and return empty to recover safely.
      await preferences.remove(storageKey);
      return [];
    }

    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return [];

      final version = decoded['schemaVersion'] as int? ?? 1;
      if (version > currentSessionSchemaVersion) {
        // Future version — return empty rather than corrupt data.
        return [];
      }

      final sessionsJson = decoded['sessions'] as List<dynamic>?;
      if (sessionsJson == null) return [];

      return sessionsJson
          .whereType<Map<String, dynamic>>()
          .map(_safeParseSession)
          .whereType<InterviewSession>()
          .toList();
    } on FormatException {
      // Malformed JSON — clear and return empty.
      await preferences.remove(storageKey);
      return [];
    }
  }

  InterviewSession? _safeParseSession(Map<String, dynamic> json) {
    try {
      return InterviewSession.fromJson(json);
    } catch (_) {
      // Skip corrupt individual sessions rather than losing all data.
      return null;
    }
  }

  Future<void> _saveAll(List<InterviewSession> sessions) async {
    final preferences = await _preferences;
    final envelope = {
      'schemaVersion': currentSessionSchemaVersion,
      'sessions': sessions.map((s) => s.toJson()).toList(),
    };
    await preferences.setString(storageKey, jsonEncode(envelope));
  }
}
