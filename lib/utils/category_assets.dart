import '../models/question_item.dart';

String categoryIconAsset(QuestionCategory category) {
  switch (category) {
    case QuestionCategory.general:
      return 'lib/images/icon/icon-general.png';
    case QuestionCategory.sign:
      return 'lib/images/icon/icon-sign.png';
    case QuestionCategory.priority:
      return 'lib/images/icon/icon-priority.png';
    case QuestionCategory.technique:
      return 'lib/images/icon/icon-technique.png';
    case QuestionCategory.emergency:
      return 'lib/images/icon/icon-emergency.png';
  }
}
