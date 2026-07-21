/// Metadata for an interview recording.
///
/// The [isAvailable] flag indicates whether the referenced audio file
/// can be played. It may be `false` when the file has been deleted or
/// was never created (e.g. demo sessions).
class InterviewRecording {
  const InterviewRecording({
    required this.uri,
    required this.duration,
    this.format,
    this.isAvailable = true,
  });

  final String uri;
  final Duration duration;
  final String? format;
  final bool isAvailable;

  Map<String, dynamic> toJson() => {
        'uri': uri,
        'durationMs': duration.inMilliseconds,
        'format': format,
        'isAvailable': isAvailable,
      };

  factory InterviewRecording.fromJson(Map<String, dynamic> json) {
    return InterviewRecording(
      uri: json['uri'] as String? ?? '',
      duration: Duration(milliseconds: json['durationMs'] as int? ?? 0),
      format: json['format'] as String?,
      isAvailable: json['isAvailable'] as bool? ?? false,
    );
  }
}
