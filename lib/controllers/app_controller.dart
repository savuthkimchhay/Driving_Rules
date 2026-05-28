import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/exam_result.dart';

class AppController extends ChangeNotifier {
  static const String _avatarPathKey = 'avatar_path';
  static const String _lastScoreKey = 'last_score';
  static const String _lastPassedKey = 'last_passed';
  static const String _isKhmerKey = 'is_khmer';

  final ImagePicker _picker = ImagePicker();

  String? _avatarPath;
  int? _lastScore;
  bool? _lastPassed;
  bool _isKhmer = true;
  bool _isReady = false;

  String? get avatarPath => _avatarPath;
  int? get lastScore => _lastScore;
  bool? get lastPassed => _lastPassed;
  bool get isKhmer => _isKhmer;
  bool get isReady => _isReady;

  Future<void> init() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _avatarPath = prefs.getString(_avatarPathKey);
    _lastScore = prefs.getInt(_lastScoreKey);
    _lastPassed = prefs.getBool(_lastPassedKey);
    _isKhmer = prefs.getBool(_isKhmerKey) ?? true;
    _isReady = true;
    notifyListeners();
  }

  Future<void> toggleLanguage() async {
    _isKhmer = !_isKhmer;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isKhmerKey, _isKhmer);
  }

  Future<void> pickAvatarFromGallery() async {
    final XFile? file = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (file == null) return;

    _avatarPath = file.path;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_avatarPathKey, file.path);
  }

  Future<void> saveExamResult(ExamResult result) async {
    _lastScore = result.totalScore;
    _lastPassed = result.passed;
    notifyListeners();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_lastScoreKey, result.totalScore);
    await prefs.setBool(_lastPassedKey, result.passed);
  }
}
