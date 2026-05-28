import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app/driving_rules_app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: <SystemUiOverlay>[SystemUiOverlay.top],

  );
  runApp(const DrivingRulesApp());
}

