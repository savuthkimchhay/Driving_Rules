import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';
import '../models/question_item.dart';
import '../utils/app_i18n.dart';

class QuestionView extends StatelessWidget {
  const QuestionView({
    super.key,
    required this.question,
    required this.currentSelection,
    this.onSelect,
    this.showCorrectAnswer = false,
    this.questionNumber,
  });

  final QuestionItem question;
  final int? currentSelection;
  final ValueChanged<int>? onSelect;
  final bool showCorrectAnswer;
  final int? questionNumber;

  bool get _readOnly => onSelect == null;
  bool get _isConceptCategory =>
      question.category == QuestionCategory.general ||
      question.category == QuestionCategory.technique ||
      question.category == QuestionCategory.emergency;

  @override
  Widget build(BuildContext context) {
    final bool isKhmer = context.watch<AppController>().isKhmer;
    final bool useConceptStyle = showCorrectAnswer && _readOnly && _isConceptCategory;

    if (useConceptStyle) {
      return Container(
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: const Color(0x293A3A6D),
          border: Border.all(color: const Color(0x5FA8B8FF)),
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(11, 11, 11, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                width: 34,
                child: Text(
                  '${questionNumber ?? ''}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    height: 1,
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      question.question,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        height: 1.3,
                        fontSize: 16.5,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Container(
                      decoration: const BoxDecoration(
                        border: Border(
                          left: BorderSide(
                            color: Color(0x73D7DCFF),
                            width: 1.4,
                          ),
                        ),
                      ),
                      padding: const EdgeInsets.only(left: 9),
                      child: Text(
                        question.correctAnswerText,
                        style: const TextStyle(
                          color: Color(0xFFD4DBF0),
                          fontWeight: FontWeight.w500,
                          height: 1.28,
                          fontSize: 13.8,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE1E7EF)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (question.hasIcon)
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      question.iconAssetPath,
                      width: 22,
                      height: 22,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'lib/images/icon/icon-default.png',
                        width: 22,
                        height: 22,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${AppI18n.t('question', isKhmer)} ${question.category.title}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2A4664),
                      ),
                    ),
                  ],
                ),
              ),
            if (question.hasImageQuestion)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFD),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFDDE4EE)),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    question.questionImageAssetPath,
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 120,
                      alignment: Alignment.center,
                      child: Text(question.question),
                    ),
                  ),
                ),
              )
            else
              Text(
                question.question,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF172B45),
                    ),
              ),
            const SizedBox(height: 12),
            ...List<Widget>.generate(question.options.length, (int optionIndex) {
              final bool selected = currentSelection == optionIndex;
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: selected ? const Color(0xFFE7F1FF) : const Color(0xFEFFFFFF),
                  border: Border.all(
                    color: selected ? const Color(0xFF0A84FF) : const Color(0xFFDCE3EB),
                  ),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: _readOnly ? null : () => onSelect?.call(optionIndex),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 22,
                          height: 22,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: selected
                                  ? const Color(0xFF0A84FF)
                                  : const Color(0xFF9CA9B8),
                              width: 2,
                            ),
                            color: selected ? const Color(0xFF0A84FF) : Colors.transparent,
                          ),
                          child: selected
                              ? const Icon(
                                  Icons.check,
                                  size: 14,
                                  color: Colors.white,
                                )
                              : null,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(question.options[optionIndex]),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
            if (showCorrectAnswer)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  '${AppI18n.t('correct_answer', isKhmer)}: ${question.correctAnswerText}',
                  style: const TextStyle(
                    color: Color(0xFF1B8F4C),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
