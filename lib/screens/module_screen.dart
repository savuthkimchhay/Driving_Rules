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
    final bool isSignGridModule = widget.category == QuestionCategory.sign;
    final bool isPriorityListModule = widget.category == QuestionCategory.priority;
    final bool isVisualModule = isSignGridModule || isPriorityListModule;

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
        dark: isVisualModule,
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
                      color: isVisualModule ? const Color(0x24FFFFFF) : const Color(0xE9FFFFFF),
                      border: Border.all(
                        color: isVisualModule ? const Color(0x5FFFFFFF) : const Color(0xFFCEDFF1),
                      ),
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
                                  color: isVisualModule ? Colors.white : const Color(0xFF1F3551),
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
                    style: TextStyle(
                      color: isVisualModule ? Colors.white : const Color(0xFF172B45),
                    ),
                    decoration: InputDecoration(
                      hintText: AppI18n.t('search_hint', isKhmer),
                      hintStyle: TextStyle(
                        color: isVisualModule ? const Color(0xB3E7F1FF) : null,
                      ),
                      fillColor: isVisualModule ? const Color(0x21FFFFFF) : null,
                      filled: isVisualModule,
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
                      : isSignGridModule
                          ? _buildSignGrid(
                              context: context,
                              items: filtered,
                              isKhmer: isKhmer,
                            )
                          : isPriorityListModule
                              ? _buildPriorityList(
                                  context: context,
                                  items: filtered,
                                  isKhmer: isKhmer,
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

  Widget _buildPriorityList({
    required BuildContext context,
    required List<QuestionItem> items,
    required bool isKhmer,
  }) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(14, 8, 14, 16),
      itemCount: items.length,
      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 14),
      itemBuilder: (BuildContext context, int index) {
        final QuestionItem item = items[index];
        return Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0x24FFFFFF),
            border: Border.all(color: const Color(0x55FFFFFF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: double.infinity,
                  height: 170,
                  color: const Color(0x18000000),
                  padding: const EdgeInsets.all(12),
                  child: Image.asset(
                    item.questionImageAssetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                      return Image.asset('lib/images/icon/icon-default.png');
                    },
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '${AppI18n.t('correct_answer', isKhmer)}:',
                style: const TextStyle(
                  color: Color(0xCFE8F2FF),
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item.correctAnswerText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  height: 1.3,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSignGrid({
    required BuildContext context,
    required List<QuestionItem> items,
    required bool isKhmer,
  }) {
    const int columnCount = 3;
    final int rowCount = (items.length / columnCount).ceil();

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(14, 6, 14, 16),
      itemCount: rowCount,
      itemBuilder: (BuildContext context, int rowIndex) {
        final int start = rowIndex * columnCount;
        final int end = (start + columnCount) > items.length ? items.length : (start + columnCount);
        final List<QuestionItem> rowItems = items.sublist(start, end);

        return Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List<Widget>.generate(columnCount, (int columnIndex) {
                if (columnIndex >= rowItems.length) {
                  return const Expanded(child: SizedBox());
                }
                final QuestionItem item = rowItems[columnIndex];
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                    child: _SignTile(
                      item: item,
                      onTap: () => _showSignAnswerSheet(context, item, isKhmer),
                    ),
                  ),
                );
              }),
            ),
            if (rowIndex < rowCount - 1)
              const Divider(
                color: Color(0x63C7D9FF),
                thickness: 1,
                height: 10,
              ),
          ],
        );
      },
    );
  }

  void _showSignAnswerSheet(BuildContext context, QuestionItem item, bool isKhmer) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    Color(0xFF102F5D),
                    Color(0xFF163B75),
                  ],
                ),
                border: Border.all(color: const Color(0x84FFFFFF)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          width: 64,
                          height: 64,
                          color: const Color(0x1AFFFFFF),
                          padding: const EdgeInsets.all(6),
                          child: Image.asset(
                            item.questionImageAssetPath,
                            fit: BoxFit.contain,
                            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
                              return Image.asset('lib/images/icon/icon-default.png');
                            },
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          AppI18n.t('correct_answer', isKhmer),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    item.correctAnswerText,
                    style: const TextStyle(
                      color: Color(0xFFEAF2FF),
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SignTile extends StatelessWidget {
  const _SignTile({
    required this.item,
    required this.onTap,
  });

  final QuestionItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: Ink(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: const Color(0x24FFFFFF),
          border: Border.all(color: const Color(0x55FFFFFF)),
        ),
        child: AspectRatio(
          aspectRatio: 1,
          child: Image.asset(
            item.questionImageAssetPath,
            fit: BoxFit.contain,
            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
              return Image.asset('lib/images/icon/icon-default.png');
            },
          ),
        ),
      ),
    );
  }
}
