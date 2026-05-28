import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';

class LanguageToggleButton extends StatelessWidget {
  const LanguageToggleButton({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final AppController appController = context.watch<AppController>();
    final bool isKhmer = appController.isKhmer;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: appController.toggleLanguage,
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 8 : 10,
            vertical: compact ? 4 : 6,
          ),
          decoration: BoxDecoration(
            color: compact ? const Color(0x22FFFFFF) : const Color(0xFFEAF1FB),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: compact ? const Color(0x66FFFFFF) : const Color(0xFFCAD8EA),
            ),
          ),
          child: Text(
            isKhmer ? 'KH | EN' : 'EN | KH',
            style: TextStyle(
              color: compact ? Colors.white : const Color(0xFF1C3552),
              fontWeight: FontWeight.w700,
              fontSize: compact ? 12 : 13,
            ),
          ),
        ),
      ),
    );
  }
}
