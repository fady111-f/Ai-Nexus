import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockmate/features/progress/presentation/pages/progress_page.dart';

import '../../support/fake_interview_repository.dart';

void main() {
  testWidgets('ProgressPage shows empty state when no sessions exist', (tester) async {
    final repo = FakeInterviewRepository();
    
    await tester.pumpWidget(
      MaterialApp(
        home: ProgressPage(interviewRepository: repo),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('No Progress Yet'), findsOneWidget);
  });
}
