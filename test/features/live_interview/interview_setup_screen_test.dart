import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/live_interview/presentation/pages/interview_setup_screen.dart';

void main() {
  Widget buildTestableWidget() {
    return MaterialApp(
      theme: MockMateTheme.dark,
      home: const InterviewSetupScreen(),
    );
  }

  testWidgets('InterviewSetupScreen renders all 6 configuration steps', (tester) async {
    await tester.pumpWidget(buildTestableWidget());

    expect(find.text('Configure Your Practice Session'), findsOneWidget);
    expect(find.text('1. Choose CV'), findsOneWidget);
    expect(find.text('2. Target Job'), findsOneWidget);
    expect(find.text('3. Interview Type'), findsOneWidget);
    expect(find.text('4. Difficulty'), findsOneWidget);
    expect(find.text('5. Duration'), findsOneWidget);
    expect(find.text('6. Language'), findsOneWidget);
    expect(find.byKey(const Key('startLiveInterviewButton')), findsOneWidget);
  });

  testWidgets('InterviewSetupScreen language selection supports Tech-Arabish, Arabic, English', (tester) async {
    await tester.pumpWidget(buildTestableWidget());

    expect(find.text('Tech-Arabish'), findsOneWidget);
    expect(find.text('Arabic'), findsOneWidget);
    expect(find.text('English'), findsOneWidget);

    await tester.tap(find.text('Arabic'));
    await tester.pumpAndSettle();
  });
}
