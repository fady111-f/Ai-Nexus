import 'package:mockmate/features/interviews/domain/models/interview_session.dart';

/// Abstraction for interview session storage.
///
/// UI code depends on this interface, not the concrete implementation.
/// This allows replacing SharedPreferences with Firebase, SQLite, or
/// any other backend without changing Progress or Replay pages.
abstract interface class InterviewRepository {
  /// Returns all stored sessions, sorted by [InterviewSession.startedAt]
  /// descending (most recent first).
  Future<List<InterviewSession>> getSessions();

  /// Returns a single session by [id], or `null` if not found.
  Future<InterviewSession?> getSessionById(String id);

  /// Persists a session. Overwrites any existing session with the same ID.
  Future<void> saveSession(InterviewSession session);

  /// Removes a session by [id]. No-op if not found.
  Future<void> deleteSession(String id);

  /// Toggles the bookmark state of a question within a session.
  Future<void> updateQuestionBookmark({
    required String sessionId,
    required String questionId,
    required bool isBookmarked,
  });

  /// Seed the repository with demo data for debugging and previews.
  Future<void> seedDemoSessions();

  /// Removes all sessions where [InterviewSession.isDemo] is `true`.
  Future<void> clearDemoSessions();
}
