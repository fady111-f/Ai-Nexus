/// A single question within an interview session.
class InterviewQuestion {
  const InterviewQuestion({
    required this.id,
    required this.order,
    required this.question,
    required this.answerTranscript,
    required this.feedback,
    required this.startOffset,
    this.score,
    this.endOffset,
    this.isBookmarked = false,
    this.tags = const [],
  });

  final String id;
  final int order;
  final String question;
  final String answerTranscript;
  final String feedback;
  final int? score;
  final Duration startOffset;
  final Duration? endOffset;
  final bool isBookmarked;
  final List<String> tags;

  InterviewQuestion copyWith({bool? isBookmarked}) => InterviewQuestion(
        id: id,
        order: order,
        question: question,
        answerTranscript: answerTranscript,
        feedback: feedback,
        score: score,
        startOffset: startOffset,
        endOffset: endOffset,
        isBookmarked: isBookmarked ?? this.isBookmarked,
        tags: tags,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'order': order,
        'question': question,
        'answerTranscript': answerTranscript,
        'feedback': feedback,
        'score': score,
        'startOffsetMs': startOffset.inMilliseconds,
        'endOffsetMs': endOffset?.inMilliseconds,
        'isBookmarked': isBookmarked,
        'tags': tags,
      };

  factory InterviewQuestion.fromJson(Map<String, dynamic> json) {
    return InterviewQuestion(
      id: json['id'] as String? ?? '',
      order: json['order'] as int? ?? 0,
      question: json['question'] as String? ?? '',
      answerTranscript: json['answerTranscript'] as String? ?? '',
      feedback: json['feedback'] as String? ?? '',
      score: json['score'] as int?,
      startOffset:
          Duration(milliseconds: json['startOffsetMs'] as int? ?? 0),
      endOffset: json['endOffsetMs'] != null
          ? Duration(milliseconds: json['endOffsetMs'] as int)
          : null,
      isBookmarked: json['isBookmarked'] as bool? ?? false,
      tags: (json['tags'] as List<dynamic>?)
              ?.whereType<String>()
              .toList() ??
          const [],
    );
  }
}
