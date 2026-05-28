import '../models/question_item.dart';

class AppI18n {
  static String t(String key, bool isKhmer) {
    final Map<String, String> dict = isKhmer ? _kh : _en;
    return dict[key] ?? key;
  }

  static String categoryTitle(QuestionCategory category, bool isKhmer) {
    switch (category) {
      case QuestionCategory.general:
        return t('general', isKhmer);
      case QuestionCategory.sign:
        return t('sign', isKhmer);
      case QuestionCategory.priority:
        return t('priority', isKhmer);
      case QuestionCategory.technique:
        return t('technique', isKhmer);
      case QuestionCategory.emergency:
        return t('emergency', isKhmer);
    }
  }

  static const Map<String, String> _en = <String, String>{
    'app_name': 'Driving Rules App',
    'user': 'User',
    'general': 'General',
    'sign': 'Sign',
    'priority': 'Priority',
    'technique': 'Technique',
    'emergency': 'Emergency',
    'exam': 'Exam',
    'basic_rule': 'Basic rule',
    'traffic_sign': 'Traffic sign',
    'right_of_way': 'Right of way',
    'safe_drive': 'Safe drive',
    'first_aid': 'First aid',
    'minutes_45': '45 min',
    'banner_1_title': 'Cambodia Driving Rules',
    'banner_1_sub': 'Official driving rules application',
    'banner_2_title': 'Learn on Phone & Tablet',
    'banner_2_sub': 'Study lessons with visual examples',
    'banner_3_title': 'Traffic Sign Reference',
    'banner_3_sub': 'Understand warning and priority signs',
    'home': 'Home',
    'news': 'News',
    'inbox': 'Inbox',
    'dates': 'Term Dates',
    'search_hint': 'Search question or answer...',
    'no_result': 'No results found.',
    'load_fail': 'Failed to load questions',
    'questions': 'Questions',
    'exam_screen': 'Driving Exam',
    'question': 'Question',
    'back': 'Back',
    'next': 'Next',
    'finish_exam': 'Finish Exam',
    'select_first': 'Please select an answer first.',
    'exam_intro': 'Exam',
    'exam_intro_title': 'Official Practice Exam',
    'exam_rules': 'Exam Rules',
    'rule_1': '1. 45 questions in 45 minutes.',
    'rule_2': '2. Each correct answer gets 1 point.',
    'rule_3': '3. Pass score is 38/45 or higher.',
    'rule_4': '4. If 1 Priority question is wrong, exam fails immediately.',
    'start_exam': 'Start Exam',
    'exam_result': 'Exam Result',
    'final_result': 'Final Result',
    'passed': 'PASSED',
    'failed': 'FAILED',
    'score': 'Score',
    'answered': 'Answered',
    'reason_timeout': 'Reason: Time is up.',
    'reason_priority': 'Reason: 1 Priority question was wrong.',
    'result_pass': 'Result: Passed (>= 38/45)',
    'result_fail': 'Result: Failed (< 38/45)',
    'back_home': 'Back to Home',
    'correct_answer': 'Correct answer',
    'updated': 'Updated',
    'profile_changed': 'Profile image changed',
    'prepare_exam_failed': 'Failed to prepare exam',
  };

  static const Map<String, String> _kh = <String, String>{
    'app_name': 'កម្មវិធីច្បាប់ចរាចរណ៍',
    'user': 'អ្នកប្រើប្រាស់',
    'general': 'ទូទៅ',
    'sign': 'ស្លាកសញ្ញា',
    'priority': 'អាទិភាព',
    'technique': 'បច្ចេកទេស',
    'emergency': 'សង្គ្រោះបឋម',
    'exam': 'ប្រឡង',
    'basic_rule': 'ច្បាប់មូលដ្ឋាន',
    'traffic_sign': 'សញ្ញាចរាចរណ៍',
    'right_of_way': 'សិទ្ធិអាទិភាព',
    'safe_drive': 'បើកបរដោយសុវត្ថិភាព',
    'first_aid': 'ជំនួយបឋម',
    'minutes_45': '45 នាទី',
    'banner_1_title': 'ច្បាប់ចរាចរណ៍កម្ពុជា',
    'banner_1_sub': 'កម្មវិធីសម្រាប់រៀនច្បាប់បើកបរ',
    'banner_2_title': 'រៀនតាមទូរស័ព្ទ និងថេប្លេត',
    'banner_2_sub': 'មេរៀនជាមួយរូបភាពងាយយល់',
    'banner_3_title': 'ឯកសារយោងស្លាកសញ្ញាចរាចរណ៍',
    'banner_3_sub': 'យល់ច្បាស់ពីសញ្ញាព្រមាន និងអាទិភាព',
    'home': 'ទំព័រដើម',
    'news': 'ព័ត៌មាន',
    'inbox': 'ប្រអប់សារ',
    'dates': 'កាលបរិច្ឆេទ',
    'search_hint': 'ស្វែងរកសំណួរ ឬ ចម្លើយ...',
    'no_result': 'មិនមានលទ្ធផលទេ។',
    'load_fail': 'មិនអាចផ្ទុកសំណួរ',
    'questions': 'សំណួរ',
    'exam_screen': 'ប្រឡងបើកបរ',
    'question': 'សំណួរ',
    'back': 'ថយក្រោយ',
    'next': 'បន្ទាប់',
    'finish_exam': 'បញ្ចប់ប្រឡង',
    'select_first': 'សូមជ្រើសចម្លើយជាមុនសិន។',
    'exam_intro': 'ប្រឡង',
    'exam_intro_title': 'សាកល្បងប្រឡងផ្លូវការ',
    'exam_rules': 'លក្ខខណ្ឌប្រឡង',
    'rule_1': '1. មានសំណួរ 45 ក្នុងរយៈពេល 45 នាទី។',
    'rule_2': '2. ឆ្លើយត្រឹមត្រូវ 1 សំណួរ = 1 ពិន្ទុ។',
    'rule_3': '3. ជាប់បើបានពិន្ទុចាប់ពី 38/45 ឡើងទៅ។',
    'rule_4': '4. ប្រសិនបើខុសសំណួរអាទិភាព 1 សំណួរ នឹងធ្លាក់ភ្លាម។',
    'start_exam': 'ចាប់ផ្តើមប្រឡង',
    'exam_result': 'លទ្ធផលប្រឡង',
    'final_result': 'សរុបលទ្ធផល',
    'passed': 'ជាប់',
    'failed': 'ធ្លាក់',
    'score': 'ពិន្ទុ',
    'answered': 'បានឆ្លើយ',
    'reason_timeout': 'មូលហេតុ៖ អស់ពេល។',
    'reason_priority': 'មូលហេតុ៖ ខុសសំណួរអាទិភាព 1 សំណួរ។',
    'result_pass': 'លទ្ធផល៖ ជាប់ (>= 38/45)',
    'result_fail': 'លទ្ធផល៖ ធ្លាក់ (< 38/45)',
    'back_home': 'ត្រឡប់ទៅទំព័រដើម',
    'correct_answer': 'ចម្លើយត្រឹមត្រូវ',
    'updated': 'បានកែប្រែ',
    'profile_changed': 'បានប្តូររូបប្រវត្តិរួចរាល់',
    'prepare_exam_failed': 'មិនអាចរៀបចំការប្រឡង',
  };
}
