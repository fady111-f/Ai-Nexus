class CVModel {
  final String fileName;
  final String fileSize;
  final String uploadDate;
  final int atsScore;
  final List<String> strengths;
  final List<String> improvements;

  CVModel({
    required this.fileName,
    required this.fileSize,
    required this.uploadDate,
    required this.atsScore,
    required this.strengths,
    required this.improvements,
  });
}