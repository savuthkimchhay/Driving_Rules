import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';
import '../models/question_item.dart';
import '../services/question_service.dart';
import '../utils/app_i18n.dart';
import '../utils/category_assets.dart';
import '../widgets/app_backdrop.dart';
import '../widgets/language_toggle_button.dart';
import '../widgets/question_view.dart';

class ModuleScreen extends StatefulWidget {
  const ModuleScreen({
    super.key,
    required this.category,
  });

  final QuestionCategory category;

  @override
  State<ModuleScreen> createState() => _ModuleScreenState();
}

class _ModuleScreenState extends State<ModuleScreen> {
  final QuestionService _questionService = const QuestionService();
  final TextEditingController _searchController = TextEditingController();
  late final Future<List<QuestionItem>> _questionsFuture;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _questionsFuture = _questionService.loadByCategory(widget.category);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isKhmer = context.watch<AppController>().isKhmer;
    final String categoryTitle = AppI18n.categoryTitle(widget.category, isKhmer);

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryTitle),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(child: LanguageToggleButton()),
          ),
        ],
      ),
      body: AppBackdrop(
        child: FutureBuilder<List<QuestionItem>>(
          future: _questionsFuture,
          builder: (
            BuildContext context,
            AsyncSnapshot<List<QuestionItem>> snapshot,
          ) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text('${AppI18n.t('load_fail', isKhmer)}: ${snapshot.error}'),
              );
            }

            final List<QuestionItem> items = snapshot.data ?? <QuestionItem>[];
            final List<QuestionItem> filtered = items.where(_matchesQuery).toList();

            return Column(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      color: const Color(0xE9FFFFFF),
                      border: Border.all(color: const Color(0xFFCEDFF1)),
                    ),
                    child: Row(
                      children: <Widget>[
                        Image.asset(
                          categoryIconAsset(widget.category),
                          width: 28,
                          height: 28,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            '${AppI18n.t('questions', isKhmer)} $categoryTitle (${filtered.length})',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF1F3551),
                                ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: AppI18n.t('search_hint', isKhmer),
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Image.asset(
                          'lib/images/icon/icon-search.png',
                          width: 18,
                          height: 18,
                        ),
                      ),
                    ),
                    onChanged: (String value) {
                      setState(() {
                        _query = value.trim().toLowerCase();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Text(AppI18n.t('no_result', isKhmer)),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (BuildContext context, int index) {
                            final QuestionItem question = filtered[index];
                            return QuestionView(
                              question: question,
                              currentSelection: question.answerIndex,
                              showCorrectAnswer: true,
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  bool _matchesQuery(QuestionItem item) {
    if (_query.isEmpty) return true;
    final String source = <String>[
      item.question,
      ...item.options,
      item.correctAnswerText,
    ].join(' ').toLowerCase();
    return source.contains(_query);
  }
}
