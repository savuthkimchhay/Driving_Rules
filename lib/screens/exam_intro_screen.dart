import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';
import '../utils/app_i18n.dart';
import '../widgets/language_toggle_button.dart';
import 'exam_screen.dart';

class ExamIntroScreen extends StatelessWidget {
  const ExamIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isKhmer = context.watch<AppController>().isKhmer;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppI18n.t('exam_intro', isKhmer)),
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                gradient: const LinearGradient(
                  colors: <Color>[Color(0xFF1A314F), Color(0xFF2D5B8A)],
                ),
              ),
              child: Row(
                children: <Widget>[
                  Image.asset(
                    'lib/images/icon/icon-exam.png',
                    width: 34,
                    height: 34,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      AppI18n.t('exam_intro_title', isKhmer),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              AppI18n.t('exam_rules', isKhmer),
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 12),
            Text(AppI18n.t('rule_1', isKhmer)),
            Text(AppI18n.t('rule_2', isKhmer)),
            Text(AppI18n.t('rule_3', isKhmer)),
            Text(AppI18n.t('rule_4', isKhmer)),
            const SizedBox(height: 18),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: () {
                  Get.to<void>(() => const ExamScreen());
                },
                child: Text(AppI18n.t('start_exam', isKhmer)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
