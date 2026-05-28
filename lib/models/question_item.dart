enum QuestionCategory {
  general,
  sign,
  priority,
  technique,
  emergency,
}

extension QuestionCategoryX on QuestionCategory {
  String get title {
    switch (this) {
      case QuestionCategory.general:
        return 'General';
      case QuestionCategory.sign:
        return 'Sign';
      case QuestionCategory.priority:
        return 'Priority';
      case QuestionCategory.technique:
        return 'Technique';
      case QuestionCategory.emergency:
        return 'Emergency';
    }
  }

  String get jsonAssetPath => 'lib/data/$name.json';
}

class QuestionItem {
  QuestionItem({
    required this.id,
    required this.question,
    required this.options,
    required this.answerIndex,
    required this.category,
    this.icon,
  });

  final String id;
  final String question;
  final List<String> options;
  final int answerIndex;
  final QuestionCategory category;
  final String? icon;

  factory QuestionItem.fromJson(
    Map<String, dynamic> json,
    QuestionCategory category,
  ) {
    final List<MapEntry<String, dynamic>> optionEntries = json.entries
        .where((MapEntry<String, dynamic> entry) => _digitRegExp.hasMatch(entry.key))
        .toList()
      ..sort(
        (MapEntry<String, dynamic> a, MapEntry<String, dynamic> b) =>
            int.parse(a.key).compareTo(int.parse(b.key)),
      );

    final List<String> parsedOptions = optionEntries
        .map((MapEntry<String, dynamic> entry) => entry.value.toString())
        .toList(growable: false);
    if (parsedOptions.isEmpty) {
      throw const FormatException('Question options cannot be empty.');
    }
    final int parsedAnswer = int.tryParse(json['answer'].toString()) ?? 0;
    final int safeAnswerIndex = parsedAnswer.clamp(0, parsedOptions.length - 1);

    return QuestionItem(
      id: json['id'].toString(),
      question: json['question'].toString(),
      options: parsedOptions,
      answerIndex: safeAnswerIndex,
      category: category,
      icon: json['icon']?.toString(),
    );
  }

  static final RegExp _digitRegExp = RegExp(r'^\d+$');

  bool get hasImageQuestion {
    return _looksLikeImageFile(question);
  }

  String get questionImageAssetPath => _resolveImageAssetPath(question);

  bool get hasIcon {
    final String? value = icon?.trim();
    return value != null && value.isNotEmpty;
  }

  String get iconAssetPath {
    final String value = (icon ?? '').trim();
    if (value.isEmpty) {
      return 'lib/images/icon/icon-default.png';
    }
    return _resolveIconAssetPath(value);
  }

  String get correctAnswerText => options[answerIndex];

  static bool _looksLikeImageFile(String value) {
    final String lower = value.trim().toLowerCase();
    return lower.endsWith('.png') || lower.endsWith('.jpg') || lower.endsWith('.jpeg');
  }

  static String _resolveImageAssetPath(String raw) {
    final String normalized = raw.trim().replaceAll('\\', '/');
    if (normalized.startsWith('lib/images/img/')) return normalized;
    if (normalized.startsWith('images/img/')) return 'lib/$normalized';
    if (normalized.startsWith('img/')) return 'lib/images/$normalized';
    return 'lib/images/img/$normalized';
  }

  static String _resolveIconAssetPath(String raw) {
    final String normalized = raw.trim().replaceAll('\\', '/');
    if (normalized.startsWith('lib/images/icon/')) return normalized;
    if (normalized.startsWith('images/icon/')) return 'lib/$normalized';
    if (normalized.startsWith('icon/')) return 'lib/images/$normalized';
    return 'lib/images/icon/$normalized';
  }
}
