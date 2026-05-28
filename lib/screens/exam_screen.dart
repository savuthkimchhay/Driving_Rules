import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';
import '../controllers/exam_controller.dart';
import '../models/question_item.dart';
import '../services/question_service.dart';
import '../utils/app_i18n.dart';
import '../utils/exam_question_builder.dart';
import '../widgets/language_toggle_button.dart';
import '../widgets/question_view.dart';
import 'exam_result_screen.dart';

class ExamScreen extends StatefulWidget {
  const ExamScreen({super.key});

  @override
  State<ExamScreen> createState() => _ExamScreenState();
}

class _ExamScreenState extends State<ExamScreen> {
  late final Future<ExamController> _controllerFuture;

  @override
  void initState() {
    super.initState();
    _controllerFuture = _createController();
  }

  @override
  Widget build(BuildContext context) {
    final bool isKhmer = context.watch<AppController>().isKhmer;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppI18n.t('exam_screen', isKhmer)),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(child: LanguageToggleButton()),
          ),
        ],
      ),
      body: FutureBuilder<ExamController>(
        future: _controllerFuture,
        builder: (
          BuildContext context,
          AsyncSnapshot<ExamController> snapshot,
        ) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Text('${AppI18n.t('prepare_exam_failed', isKhmer)}: ${snapshot.error}'),
              ),
            );
          }
          final ExamController controller = snapshot.data!;
          return _ExamRunner(controller: controller);
        },
      ),
    );
  }

  Future<ExamController> _createController() async {
    final QuestionService service = const QuestionService();
    final Map<QuestionCategory, List<QuestionItem>> all = await service.loadAll();
    final List<QuestionItem> examQuestions = buildExamQuestions(all);
    return ExamController(questions: examQuestions);
  }
}

class _ExamRunner extends StatefulWidget {
  const _ExamRunner({
    required this.controller,
  });

  final ExamController controller;

  @override
  State<_ExamRunner> createState() => _ExamRunnerState();
}

class _ExamRunnerState extends State<_ExamRunner> {
  bool _resultOpened = false;

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(covariant _ExamRunner oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    widget.controller.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    final result = widget.controller.result;
    if (result == null || _resultOpened || !mounted) return;

    _resultOpened = true;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => ExamResultScreen(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool isKhmer = context.watch<AppController>().isKhmer;

    return AnimatedBuilder(
      animation: widget.controller,
      builder: (BuildContext context, _) {
        final ExamController controller = widget.controller;
        final QuestionItem question = controller.currentQuestion;
        final bool isLast = controller.currentIndex == controller.questions.length - 1;

        return Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          '${AppI18n.t('question', isKhmer)} ${controller.currentIndex + 1}/${controller.questions.length}',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8EDF5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          _formatDuration(controller.remaining),
                          style: const TextStyle(
                            color: Color(0xFF1D3653),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: LinearProgressIndicator(
                      minHeight: 8,
                      value: (controller.currentIndex + 1) / controller.questions.length,
                      backgroundColor: const Color(0xFFDCE4EE),
                      valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFFFFA726)),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                children: <Widget>[
                  QuestionView(
                    question: question,
                    currentSelection: controller.selectedAnswer,
                    onSelect: controller.selectAnswer,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.canGoBack ? controller.goBack : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'lib/images/icon/icon-back.png',
                            width: 18,
                            height: 18,
                          ),
                          const SizedBox(width: 6),
                          Text(AppI18n.t('back', isKhmer)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        final bool moved = controller.goNext();
                        if (!moved && controller.selectedAnswer == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(AppI18n.t('select_first', isKhmer)),
                            ),
                          );
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(isLast
                              ? AppI18n.t('finish_exam', isKhmer)
                              : AppI18n.t('next', isKhmer)),
                          const SizedBox(width: 6),
                          Image.asset(
                            'lib/images/icon/icon-next.png',
                            width: 18,
                            height: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  String _formatDuration(Duration duration) {
    final int minutes = duration.inMinutes;
    final int seconds = duration.inSeconds.remainder(60);
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }
}
