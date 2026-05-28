import 'dart:async';

import 'package:flutter/foundation.dart';

import '../models/exam_result.dart';
import '../models/question_item.dart';

class ExamController extends ChangeNotifier {
  ExamController({
    required List<QuestionItem> questions,
    Duration duration = const Duration(minutes: 45),
    this.passScore = 38,
  })  : _questions = questions,
        _remaining = duration,
        _duration = duration,
        _answers = List<int?>.filled(questions.length, null) {
    _startTimer();
  }

  final List<QuestionItem> _questions;
  final List<int?> _answers;
  final Duration _duration;
  final int passScore;

  Timer? _timer;
  Duration _remaining;
  int _currentIndex = 0;
  ExamResult? _result;

  List<QuestionItem> get questions => _questions;
  List<int?> get answers => _answers;
  Duration get duration => _duration;
  Duration get remaining => _remaining;
  int get currentIndex => _currentIndex;
  QuestionItem get currentQuestion => _questions[_currentIndex];
  int? get selectedAnswer => _answers[_currentIndex];
  bool get canGoBack => _currentIndex > 0;
  bool get canGoNext => _currentIndex < _questions.length - 1;
  bool get isFinished => _result != null;
  ExamResult? get result => _result;

  void selectAnswer(int index) {
    _answers[_currentIndex] = index;
    notifyListeners();
  }

  bool goBack() {
    if (!canGoBack || isFinished) return false;
    _currentIndex -= 1;
    notifyListeners();
    return true;
  }

  bool goNext() {
    if (isFinished || selectedAnswer == null) return false;

    if (_triggerPriorityFailIfNeeded()) {
      return true;
    }

    if (canGoNext) {
      _currentIndex += 1;
      notifyListeners();
      return true;
    }

    finish();
    return true;
  }

  bool finish() {
    if (isFinished || selectedAnswer == null) return false;

    if (_triggerPriorityFailIfNeeded()) {
      return true;
    }

    _completeExam(timedOut: false, priorityFailed: false);
    return true;
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (isFinished) {
        timer.cancel();
        return;
      }

      if (_remaining.inSeconds <= 1) {
        _remaining = Duration.zero;
        _completeExam(timedOut: true, priorityFailed: false);
      } else {
        _remaining -= const Duration(seconds: 1);
        notifyListeners();
      }
    });
  }

  bool _triggerPriorityFailIfNeeded() {
    final QuestionItem question = currentQuestion;
    if (question.category != QuestionCategory.priority) {
      return false;
    }

    final int selected = selectedAnswer ?? -1;
    if (selected != question.answerIndex) {
      _completeExam(timedOut: false, priorityFailed: true);
      return true;
    }
    return false;
  }

  void _completeExam({
    required bool timedOut,
    required bool priorityFailed,
  }) {
    if (isFinished) return;
    _timer?.cancel();

    int score = 0;
    int answered = 0;
    for (int i = 0; i < _questions.length; i++) {
      final int? answer = _answers[i];
      if (answer == null) continue;
      answered += 1;
      if (answer == _questions[i].answerIndex) {
        score += 1;
      }
    }

    final bool passed = !timedOut && !priorityFailed && score >= passScore;
    _result = ExamResult(
      totalScore: score,
      totalQuestions: _questions.length,
      passed: passed,
      timedOut: timedOut,
      priorityFailed: priorityFailed,
      answeredCount: answered,
    );
    notifyListeners();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
