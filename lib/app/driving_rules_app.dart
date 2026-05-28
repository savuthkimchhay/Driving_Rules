import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';
import '../screens/home_screen.dart';
import '../theme/app_theme.dart';
import '../utils/app_i18n.dart';

class DrivingRulesApp extends StatelessWidget {
  const DrivingRulesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AppController>(
      create: (_) => AppController()..init(),
      child: Consumer<AppController>(
        builder: (BuildContext context, AppController appController, _) {
          return GetMaterialApp(
            title: AppI18n.t('app_name', appController.isKhmer),
            debugShowCheckedModeBanner: false,
            theme: buildAppTheme(),
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
