import 'package:flutter/material.dart';
import 'package:mockmate/core/theme/mockmate_theme.dart';
import 'package:mockmate/features/interviews/domain/models/interview_question.dart';
import 'package:mockmate/features/interviews/domain/models/interview_session.dart';

class ReplayTimeline extends StatelessWidget {
  const ReplayTimeline({
    required this.session,
    required this.onToggleBookmark,
    super.key,
  });

  final InterviewSession session;
  final void Function(String questionId, bool isBookmarked) onToggleBookmark;

  @override
  Widget build(BuildContext context) {
    if (session.questions.isEmpty) {
      return Center(
        child: Text(
          'No questions recorded for this session.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: MockMateColors.textSecondary,
              ),
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: session.questions.length,
      separatorBuilder: (_, _) => const SizedBox(height: MockMateSpacing.medium),
      itemBuilder: (context, index) {
        final question = session.questions[index];
        return _QuestionCard(
          question: question,
          index: index + 1,
          onToggleBookmark: (isBookmarked) => onToggleBookmark(question.id, isBookmarked),
        );
      },
    );
  }
}

class _QuestionCard extends StatefulWidget {
  const _QuestionCard({
    required this.question,
    required this.index,
    required this.onToggleBookmark,
  });

  final InterviewQuestion question;
  final int index;
  final ValueChanged<bool> onToggleBookmark;

  @override
  State<_QuestionCard> createState() => _QuestionCardState();
}

class _QuestionCardState extends State<_QuestionCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: MockMateColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: MockMateColors.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: _expanded
                ? const BorderRadius.vertical(top: Radius.circular(16))
                : BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(MockMateSpacing.large),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: MockMateColors.surfaceRaised,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${widget.index}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ),
                  const SizedBox(width: MockMateSpacing.medium),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.question.question,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        if (widget.question.startOffset != Duration.zero) ...[
                          const SizedBox(height: 4),
                          Text(
                            _formatDuration(widget.question.startOffset),
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: MockMateColors.textSecondary,
                                ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: MockMateSpacing.small),
                  IconButton(
                    icon: Icon(
                      widget.question.isBookmarked
                          ? Icons.bookmark_rounded
                          : Icons.bookmark_border_rounded,
                      color: widget.question.isBookmarked
                          ? MockMateColors.primary
                          : MockMateColors.textSecondary,
                    ),
                    onPressed: () {
                      widget.onToggleBookmark(!widget.question.isBookmarked);
                    },
                  ),
                ],
              ),
            ),
          ),
          if (_expanded && widget.question.answerTranscript.isNotEmpty)
            Padding(
              padding: const EdgeInsets.fromLTRB(
                MockMateSpacing.large,
                0,
                MockMateSpacing.large,
                MockMateSpacing.large,
              ),
              child: Container(
                padding: const EdgeInsets.all(MockMateSpacing.medium),
                decoration: BoxDecoration(
                  color: MockMateColors.surfaceRaised,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Your Answer',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: MockMateColors.textSecondary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.question.answerTranscript,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }
}
