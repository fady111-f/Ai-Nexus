import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockmate/features/replay/presentation/pages/interview_replay_page.dart';

import '../../support/fake_interview_repository.dart';

void main() {
  testWidgets('InterviewReplayPage shows error when session is missing', (tester) async {
    final repo = FakeInterviewRepository();
    
    await tester.pumpWidget(
      MaterialApp(
        home: InterviewReplayPage(
          sessionId: 'missing-id',
          interviewRepository: repo,
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('Session not found or error loading.'), findsOneWidget);
  });
}
