import 'package:flutter/foundation.dart';
import 'package:mockmate/features/interviews/domain/models/interview_question.dart';
import 'package:mockmate/features/interviews/domain/models/interview_scores.dart';
import 'package:mockmate/features/interviews/domain/models/interview_session.dart';
import 'package:mockmate/features/interviews/domain/models/interview_timeline_event.dart';
import 'package:mockmate/features/interviews/domain/repositories/interview_repository.dart';

/// Seeds deterministic demo interview sessions for testing.
///
/// Only available when [kDebugMode] is `true`. Every seeded session
/// has [InterviewSession.isDemo] set to `true` and is clearly labeled.
class DemoInterviewSeeder {
  const DemoInterviewSeeder(this._repository);

  final InterviewRepository _repository;

  /// Returns `true` only in debug mode — the only condition under
  /// which demo data can be seeded.
  static bool get isAvailable => kDebugMode;

  /// Seeds three deterministic demo sessions for "Junior Data Scientist".
  ///
  /// Throws [StateError] if called outside debug mode.
  Future<void> seed() async {
    if (!kDebugMode) {
      throw StateError('Demo seeding is only available in debug mode.');
    }

    for (final session in _demoSessions) {
      await _repository.saveSession(session);
    }
  }

  /// Removes all demo sessions.
  Future<void> clear() async {
    await _repository.clearDemoSessions();
  }

  static final _demoSessions = [
    // ── Session 1 — Score 61 ──────────────────────────────────────
    InterviewSession(
      id: 'demo-session-001',
      jobTitle: 'Junior Data Scientist',
      companyName: 'DataCorp',
      startedAt: DateTime(2026, 7, 10, 10, 0),
      duration: const Duration(minutes: 23),
      interviewType: InterviewType.mixed,
      difficulty: 'Realistic',
      language: 'English',
      overallScore: 61,
      scores: const InterviewScores(
        technicalAccuracy: 55,
        communication: 68,
        confidence: 58,
        conciseness: 62,
        adaptability: 60,
      ),
      questions: [
        InterviewQuestion(
          id: 'demo-q-001-1',
          order: 1,
          question:
              'Can you explain the difference between supervised and unsupervised learning?',
          answerTranscript:
              'Supervised learning uses labeled data to train models, while unsupervised learning finds patterns in unlabeled data. For example, classification is supervised and clustering is unsupervised.',
          feedback:
              'Good foundational answer. Consider adding real-world examples from your projects to make it more concrete and memorable.',
          score: 64,
          startOffset: const Duration(minutes: 1, seconds: 15),
          endOffset: const Duration(minutes: 3, seconds: 42),
          tags: ['machine-learning', 'fundamentals'],
        ),
        InterviewQuestion(
          id: 'demo-q-001-2',
          order: 2,
          question:
              'How would you handle missing values in a dataset?',
          answerTranscript:
              'I would first analyze the pattern of missing data. If it is random, I might use mean imputation. For systematic missing data, I would consider domain knowledge or use algorithms that handle missing values natively.',
          feedback:
              'Solid approach. Mentioning specific tools like pandas or scikit-learn imputers would strengthen the answer. Also consider discussing when deletion is appropriate.',
          score: 58,
          startOffset: const Duration(minutes: 4, seconds: 10),
          endOffset: const Duration(minutes: 7, seconds: 5),
          tags: ['data-cleaning', 'practical'],
        ),
        InterviewQuestion(
          id: 'demo-q-001-3',
          order: 3,
          question:
              'Tell me about a project where you worked with real data.',
          answerTranscript:
              'In my university capstone, I analyzed student performance data. I cleaned the dataset, performed exploratory analysis, and built a logistic regression model to predict at-risk students.',
          feedback:
              'Good that you shared a real project. The answer could be improved by discussing the impact of your work and any challenges you overcame during the project.',
          score: 62,
          startOffset: const Duration(minutes: 8, seconds: 0),
          endOffset: const Duration(minutes: 12, seconds: 30),
          tags: ['experience', 'storytelling'],
        ),
      ],
      timelineEvents: [
        const InterviewTimelineEvent(
          id: 'demo-e-001-1',
          timestamp: Duration(minutes: 2, seconds: 30),
          type: TimelineEventType.strongAnswer,
          title: 'Clear ML fundamentals',
          description:
              'Gave a concise and accurate explanation of supervised vs. unsupervised learning.',
          relatedQuestionId: 'demo-q-001-1',
        ),
        const InterviewTimelineEvent(
          id: 'demo-e-001-2',
          timestamp: Duration(minutes: 5, seconds: 45),
          type: TimelineEventType.technicalGap,
          title: 'Missing practical tooling',
          description:
              'Did not mention specific Python libraries or tools for handling missing data.',
          relatedQuestionId: 'demo-q-001-2',
        ),
        const InterviewTimelineEvent(
          id: 'demo-e-001-3',
          timestamp: Duration(minutes: 10, seconds: 15),
          type: TimelineEventType.rambling,
          title: 'Project description lacked focus',
          description:
              'The project description was too broad — narrowing down to impact and results would help.',
          relatedQuestionId: 'demo-q-001-3',
        ),
      ],
      createdAt: DateTime(2026, 7, 10, 10, 25),
      isDemo: true,
    ),

    // ── Session 2 — Score 70 ──────────────────────────────────────
    InterviewSession(
      id: 'demo-session-002',
      jobTitle: 'Junior Data Scientist',
      companyName: 'AnalyticaAI',
      startedAt: DateTime(2026, 7, 14, 14, 30),
      duration: const Duration(minutes: 28),
      interviewType: InterviewType.technical,
      difficulty: 'Realistic',
      language: 'English',
      overallScore: 70,
      scores: const InterviewScores(
        technicalAccuracy: 72,
        communication: 71,
        confidence: 65,
        conciseness: 70,
        adaptability: 68,
      ),
      questions: [
        InterviewQuestion(
          id: 'demo-q-002-1',
          order: 1,
          question:
              'What evaluation metrics would you use for a classification model?',
          answerTranscript:
              'It depends on the problem. For balanced classes, accuracy works. For imbalanced data, I would use precision, recall, and F1-score. AUC-ROC is also useful for comparing models overall.',
          feedback:
              'Strong answer that shows awareness of class imbalance. Consider also mentioning confusion matrices and when you would prioritize recall over precision.',
          score: 74,
          startOffset: const Duration(minutes: 2, seconds: 0),
          endOffset: const Duration(minutes: 5, seconds: 20),
          tags: ['metrics', 'classification'],
        ),
        InterviewQuestion(
          id: 'demo-q-002-2',
          order: 2,
          question:
              'Explain overfitting and how you would prevent it.',
          answerTranscript:
              'Overfitting is when a model performs well on training data but poorly on unseen data. I would prevent it using techniques like cross-validation, regularization such as L1 and L2, early stopping, or by using simpler models.',
          feedback:
              'Comprehensive answer covering multiple prevention strategies. Adding a brief example of when you encountered overfitting in practice would make it even stronger.',
          score: 72,
          startOffset: const Duration(minutes: 6, seconds: 0),
          endOffset: const Duration(minutes: 9, seconds: 45),
          tags: ['model-evaluation', 'regularization'],
        ),
        InterviewQuestion(
          id: 'demo-q-002-3',
          order: 3,
          question: 'How would you explain a complex model to a non-technical stakeholder?',
          answerTranscript:
              'I would focus on the business impact rather than the technical details. For example, instead of explaining gradient boosting, I would say the model identifies patterns in customer behavior to predict who is likely to churn, and show them the key factors driving those predictions.',
          feedback:
              'Excellent communication approach. You demonstrated the ability to translate technical concepts into business value. This is a strong skill for a data scientist.',
          score: 78,
          startOffset: const Duration(minutes: 11, seconds: 0),
          endOffset: const Duration(minutes: 15, seconds: 10),
          tags: ['communication', 'stakeholder-management'],
        ),
      ],
      timelineEvents: [
        const InterviewTimelineEvent(
          id: 'demo-e-002-1',
          timestamp: Duration(minutes: 3, seconds: 50),
          type: TimelineEventType.strongAnswer,
          title: 'Metrics awareness',
          description:
              'Showed nuanced understanding of when to use different classification metrics.',
          relatedQuestionId: 'demo-q-002-1',
        ),
        const InterviewTimelineEvent(
          id: 'demo-e-002-2',
          timestamp: Duration(minutes: 13, seconds: 0),
          type: TimelineEventType.strongAnswer,
          title: 'Effective communication',
          description:
              'Translated complex ML concepts into business-friendly language naturally.',
          relatedQuestionId: 'demo-q-002-3',
        ),
        const InterviewTimelineEvent(
          id: 'demo-e-002-3',
          timestamp: Duration(minutes: 8, seconds: 30),
          type: TimelineEventType.recovery,
          title: 'Recovered from initial hesitation',
          description:
              'Started the overfitting explanation slowly but recovered with a structured multi-point answer.',
          relatedQuestionId: 'demo-q-002-2',
        ),
      ],
      createdAt: DateTime(2026, 7, 14, 15, 0),
      isDemo: true,
    ),

    // ── Session 3 — Score 79 ──────────────────────────────────────
    InterviewSession(
      id: 'demo-session-003',
      jobTitle: 'Junior Data Scientist',
      startedAt: DateTime(2026, 7, 18, 9, 0),
      duration: const Duration(minutes: 32),
      interviewType: InterviewType.behavioral,
      difficulty: 'Realistic',
      language: 'English',
      overallScore: 79,
      scores: const InterviewScores(
        technicalAccuracy: 78,
        communication: 82,
        confidence: 76,
        conciseness: 80,
        adaptability: 77,
      ),
      questions: [
        InterviewQuestion(
          id: 'demo-q-003-1',
          order: 1,
          question:
              'Describe a time you had to learn a new technology quickly.',
          answerTranscript:
              'During an internship, I had to learn Docker in two days to containerize a data pipeline. I used official docs, built small practice images, and had the pipeline running in containers by day three. It taught me the value of structured, goal-driven learning.',
          feedback:
              'Excellent STAR-format response. Clear situation, action, and result. The reflection on learning approach adds depth.',
          score: 82,
          startOffset: const Duration(minutes: 1, seconds: 30),
          endOffset: const Duration(minutes: 5, seconds: 50),
          tags: ['learning', 'adaptability'],
        ),
        InterviewQuestion(
          id: 'demo-q-003-2',
          order: 2,
          question:
              'How do you prioritize tasks when working on multiple data projects?',
          answerTranscript:
              'I use a combination of urgency and impact. I categorize tasks into a matrix and tackle high-impact, urgent items first. I also communicate deadlines clearly with stakeholders and re-prioritize weekly based on changing needs.',
          feedback:
              'Good structured approach to prioritization. The mention of stakeholder communication shows maturity. Consider sharing a specific example to make it more memorable.',
          score: 76,
          startOffset: const Duration(minutes: 7, seconds: 0),
          endOffset: const Duration(minutes: 11, seconds: 20),
          tags: ['time-management', 'organization'],
        ),
        InterviewQuestion(
          id: 'demo-q-003-3',
          order: 3,
          question:
              'What would you do if your model results contradicted domain expert expectations?',
          answerTranscript:
              'I would first verify my data and methodology. Then I would present the findings transparently to the domain expert and explore possible explanations together. Sometimes the model reveals genuinely new patterns, but sometimes it indicates a data issue.',
          feedback:
              'Mature response showing both technical rigor and collaborative mindset. This is exactly the kind of critical thinking interviewers look for in data scientists.',
          score: 80,
          startOffset: const Duration(minutes: 13, seconds: 0),
          endOffset: const Duration(minutes: 18, seconds: 40),
          tags: ['critical-thinking', 'collaboration'],
        ),
      ],
      timelineEvents: [
        const InterviewTimelineEvent(
          id: 'demo-e-003-1',
          timestamp: Duration(minutes: 3, seconds: 30),
          type: TimelineEventType.strongAnswer,
          title: 'Excellent storytelling',
          description:
              'Used STAR format naturally to describe the Docker learning experience.',
          relatedQuestionId: 'demo-q-003-1',
        ),
        const InterviewTimelineEvent(
          id: 'demo-e-003-2',
          timestamp: Duration(minutes: 15, seconds: 45),
          type: TimelineEventType.strongAnswer,
          title: 'Critical thinking under pressure',
          description:
              'Demonstrated a balanced approach to handling conflicting model results.',
          relatedQuestionId: 'demo-q-003-3',
        ),
        const InterviewTimelineEvent(
          id: 'demo-e-003-3',
          timestamp: Duration(minutes: 20, seconds: 0),
          type: TimelineEventType.generalFeedback,
          title: 'Overall improvement noted',
          description:
              'Answers were more structured and confident compared to earlier sessions.',
        ),
      ],
      createdAt: DateTime(2026, 7, 18, 9, 35),
      isDemo: true,
    ),
  ];
}
