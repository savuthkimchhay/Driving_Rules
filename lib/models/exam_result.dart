class ExamResult {
  const ExamResult({
    required this.totalScore,
    required this.totalQuestions,
    required this.passed,
    required this.timedOut,
    required this.priorityFailed,
    required this.answeredCount,
  });

  final int totalScore;
  final int totalQuestions;
  final bool passed;
  final bool timedOut;
  final bool priorityFailed;
  final int answeredCount;
}
