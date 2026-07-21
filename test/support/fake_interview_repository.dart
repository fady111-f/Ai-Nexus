import 'package:mockmate/features/interviews/domain/models/interview_session.dart';
import 'package:mockmate/features/interviews/domain/repositories/interview_repository.dart';

class FakeInterviewRepository implements InterviewRepository {
  List<InterviewSession> sessions = [];

  @override
  Future<List<InterviewSession>> getSessions() async {
    return sessions;
  }

  @override
  Future<InterviewSession?> getSessionById(String id) async {
    for (final session in sessions) {
      if (session.id == id) return session;
    }
    return null;
  }

  @override
  Future<void> saveSession(InterviewSession session) async {
    final index = sessions.indexWhere((s) => s.id == session.id);
    if (index >= 0) {
      sessions[index] = session;
    } else {
      sessions.add(session);
    }
  }

  @override
  Future<void> deleteSession(String id) async {
    sessions.removeWhere((s) => s.id == id);
  }

  @override
  Future<void> seedDemoSessions() async {
    // No-op for tests unless specifically needed
  }

  @override
  Future<void> updateQuestionBookmark({
    required String sessionId,
    required String questionId,
    required bool isBookmarked,
  }) async {
    final sessionIndex = sessions.indexWhere((s) => s.id == sessionId);
    if (sessionIndex < 0) return;

    final session = sessions[sessionIndex];
    final updatedQuestions = session.questions.map((q) {
      if (q.id == questionId) {
        return q.copyWith(isBookmarked: isBookmarked);
      }
      return q;
    }).toList();

    sessions[sessionIndex] = session.copyWith(questions: updatedQuestions);
  }

  @override
  Future<void> clearDemoSessions() async {
    sessions.removeWhere((s) => s.isDemo);
  }
}
