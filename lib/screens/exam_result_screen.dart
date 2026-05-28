import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';
import '../models/exam_result.dart';
import '../utils/app_i18n.dart';
import '../widgets/language_toggle_button.dart';
import 'home_screen.dart';

class ExamResultScreen extends StatefulWidget {
  const ExamResultScreen({
    super.key,
    required this.result,
  });

  final ExamResult result;

  @override
  State<ExamResultScreen> createState() => _ExamResultScreenState();
}

class _ExamResultScreenState extends State<ExamResultScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AppController>().saveExamResult(widget.result);
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isKhmer = context.watch<AppController>().isKhmer;
    final String statusText = widget.result.passed
        ? AppI18n.t('passed', isKhmer)
        : AppI18n.t('failed', isKhmer);
    final Color statusColor = widget.result.passed ? Colors.green : Colors.red;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppI18n.t('exam_result', isKhmer)),
        automaticallyImplyLeading: false,
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(child: LanguageToggleButton()),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Color(0xFFDDE6F0)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Image.asset(
                          widget.result.passed
                              ? 'lib/images/icon/icon-rgb.png'
                              : 'lib/images/icon/icon-info.png',
                          width: 22,
                          height: 22,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          AppI18n.t('final_result', isKhmer),
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF1D3653),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      statusText,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w800,
                          ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '${AppI18n.t('score', isKhmer)}: ${widget.result.totalScore}/${widget.result.totalQuestions}',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    Text(
                      '${AppI18n.t('answered', isKhmer)}: ${widget.result.answeredCount}/${widget.result.totalQuestions}',
                    ),
                    const SizedBox(height: 8),
                    if (widget.result.timedOut)
                      Text(
                        AppI18n.t('reason_timeout', isKhmer),
                        style: const TextStyle(color: Colors.red),
                      ),
                    if (widget.result.priorityFailed)
                      Text(
                        AppI18n.t('reason_priority', isKhmer),
                        style: const TextStyle(color: Colors.red),
                      ),
                    if (!widget.result.timedOut && !widget.result.priorityFailed)
                      Text(
                        widget.result.passed
                            ? AppI18n.t('result_pass', isKhmer)
                            : AppI18n.t('result_fail', isKhmer),
                      ),
                  ],
                ),
              ),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Get.offAll<void>(() => const HomeScreen());
                },
                child: Text(AppI18n.t('back_home', isKhmer)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
