import 'dart:convert';

import 'package:flutter/services.dart';

import '../models/question_item.dart';

class QuestionService {
  const QuestionService();

  Future<List<QuestionItem>> loadByCategory(QuestionCategory category) async {
    final String raw = await rootBundle.loadString(category.jsonAssetPath);
    final List<dynamic> decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .cast<Map<String, dynamic>>()
        .map((Map<String, dynamic> json) => QuestionItem.fromJson(json, category))
        .toList(growable: false);
  }

  Future<Map<QuestionCategory, List<QuestionItem>>> loadAll() async {
    final Map<QuestionCategory, List<QuestionItem>> data =
        <QuestionCategory, List<QuestionItem>>{};
    for (final QuestionCategory category in QuestionCategory.values) {
      data[category] = await loadByCategory(category);
    }
    return data;
  }
}
