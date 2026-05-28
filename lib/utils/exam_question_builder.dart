import 'dart:math';

import '../models/question_item.dart';

List<QuestionItem> buildExamQuestions(
  Map<QuestionCategory, List<QuestionItem>> allQuestions, {
  Random? random,
}) {
  final Random rng = random ?? Random();

  final List<QuestionItem> general = _pickUnique(
    allQuestions[QuestionCategory.general] ?? <QuestionItem>[],
    20,
    rng,
  );
  final List<QuestionItem> sign = _pickUnique(
    allQuestions[QuestionCategory.sign] ?? <QuestionItem>[],
    10,
    rng,
  );
  final List<QuestionItem> priority = _pickUnique(
    allQuestions[QuestionCategory.priority] ?? <QuestionItem>[],
    5,
    rng,
  );
  final List<QuestionItem> technique = _pickUnique(
    allQuestions[QuestionCategory.technique] ?? <QuestionItem>[],
    5,
    rng,
  );
  final List<QuestionItem> emergency = _pickUnique(
    allQuestions[QuestionCategory.emergency] ?? <QuestionItem>[],
    5,
    rng,
  );

  return <QuestionItem>[
    ...general.sublist(0, 15),
    ...sign,
    ...priority,
    ...general.sublist(15, 20),
    ...technique,
    ...emergency,
  ];
}

List<QuestionItem> _pickUnique(
  List<QuestionItem> pool,
  int count,
  Random rng,
) {
  if (pool.length < count) {
    throw StateError('Not enough questions to build exam. Need $count, got ${pool.length}.');
  }

  final List<QuestionItem> copy = List<QuestionItem>.from(pool)..shuffle(rng);
  return copy.take(count).toList(growable: false);
}
