import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';
import '../utils/app_i18n.dart';
import '../widgets/app_backdrop.dart';
import '../widgets/language_toggle_button.dart';

class TermDatesScreen extends StatelessWidget {
  const TermDatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isKhmer = context.watch<AppController>().isKhmer;

    final List<_TermDateItem> items = <_TermDateItem>[
      _TermDateItem(
        titleEn: 'Course Registration',
        titleKh: 'ចុះឈ្មោះវគ្គសិក្សា',
        start: DateTime(2026, 6, 1),
        end: DateTime(2026, 6, 7),
      ),
      _TermDateItem(
        titleEn: 'Theory Lessons Start',
        titleKh: 'ចាប់ផ្តើមមេរៀនទ្រឹស្តី',
        start: DateTime(2026, 6, 8),
      ),
      _TermDateItem(
        titleEn: 'Midterm Practice Test',
        titleKh: 'តេស្តអនុវត្តពាក់កណ្តាលវគ្គ',
        start: DateTime(2026, 7, 15),
      ),
      _TermDateItem(
        titleEn: 'Road Sign Review Week',
        titleKh: 'សប្តាហ៍ពិនិត្យសញ្ញាចរាចរណ៍',
        start: DateTime(2026, 8, 10),
        end: DateTime(2026, 8, 14),
      ),
      _TermDateItem(
        titleEn: 'Final Exam',
        titleKh: 'ប្រឡងបញ្ចប់វគ្គ',
        start: DateTime(2026, 8, 28),
      ),
      _TermDateItem(
        titleEn: 'Result Announcement',
        titleKh: 'ប្រកាសលទ្ធផល',
        start: DateTime(2026, 9, 5),
      ),
    ];

    final DateTime firstDate = items.first.start;
    final DateTime lastDate = items.last.end ?? items.last.start;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppI18n.t('dates', isKhmer)),
        actions: const <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 12),
            child: Center(child: LanguageToggleButton()),
          ),
        ],
      ),
      body: AppBackdrop(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
          children: <Widget>[
            _TermDatesHero(
              title: AppI18n.t('dates', isKhmer),
              subtitle: isKhmer ? 'កាលវិភាគសម្រាប់អ្នករៀនបើកបរ' : 'Schedule for driving learners',
              totalEvents: items.length,
              periodText: '${_formatDate(firstDate)} - ${_formatDate(lastDate)}',
            ),
            const SizedBox(height: 16),
            ...List<Widget>.generate(items.length, (int index) {
              final _TermDateItem item = items[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _TermDateCard(
                  title: isKhmer ? item.titleKh : item.titleEn,
                  dateText: _formatDateRange(item.start, item.end),
                  monthLabel: _monthLabel(item.start),
                  dayLabel: item.start.day.toString().padLeft(2, '0'),
                  isLast: index == items.length - 1,
                  isRange: item.end != null,
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _TermDatesHero extends StatelessWidget {
  const _TermDatesHero({
    required this.title,
    required this.subtitle,
    required this.totalEvents,
    required this.periodText,
  });

  final String title;
  final String subtitle;
  final int totalEvents;
  final String periodText;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Color(0xFF1B5D96),
            Color(0xFF4EA3D3),
          ],
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x3A225B89),
            blurRadius: 18,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color(0x3DFFFFFF),
                ),
                child: const Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 22,
                        height: 1.1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: Color(0xFFE6F5FF),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: <Widget>[
              _HeroChip(
                icon: Icons.event_note_rounded,
                text: '$totalEvents events',
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _HeroChip(
                  icon: Icons.schedule_rounded,
                  text: periodText,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(11),
        color: const Color(0x2EFFFFFF),
        border: Border.all(color: const Color(0x48FFFFFF)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Icon(icon, size: 15, color: Colors.white),
          const SizedBox(width: 6),
          Flexible(
            child: Text(
              text,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TermDateCard extends StatelessWidget {
  const _TermDateCard({
    required this.title,
    required this.dateText,
    required this.monthLabel,
    required this.dayLabel,
    required this.isLast,
    required this.isRange,
  });

  final String title;
  final String dateText;
  final String monthLabel;
  final String dayLabel;
  final bool isLast;
  final bool isRange;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(
          width: 56,
          child: Column(
            children: <Widget>[
              Container(
                width: 50,
                padding: const EdgeInsets.symmetric(vertical: 7),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F4FF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFCBE2F8)),
                ),
                child: Column(
                  children: <Widget>[
                    Text(
                      monthLabel,
                      style: const TextStyle(
                        color: Color(0xFF2F6D9B),
                        fontWeight: FontWeight.w700,
                        fontSize: 10,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      dayLabel,
                      style: const TextStyle(
                        color: Color(0xFF12385B),
                        fontWeight: FontWeight.w800,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              if (!isLast)
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  width: 2,
                  height: 66,
                  color: const Color(0xB4B5D5EE),
                ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: Colors.white.withAlpha(242),
              border: Border.all(color: const Color(0xFFD2E4F4)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: const Color(0xFFEAF5FF),
                  ),
                  child: const Icon(
                    Icons.flag_rounded,
                    size: 18,
                    color: Color(0xFF2D628F),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: const TextStyle(
                          color: Color(0xFF163453),
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        dateText,
                        style: const TextStyle(
                          color: Color(0xFF44607A),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isRange ? const Color(0xFFEAF8FF) : const Color(0xFFF0F4FF),
                          border: Border.all(
                            color: isRange ? const Color(0xFFCAEBFF) : const Color(0xFFD7DEF8),
                          ),
                        ),
                        child: Text(
                          isRange ? 'Week Event' : 'Single Day',
                          style: TextStyle(
                            color: isRange ? const Color(0xFF2C6D92) : const Color(0xFF42547B),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _TermDateItem {
  const _TermDateItem({
    required this.titleEn,
    required this.titleKh,
    required this.start,
    this.end,
  });

  final String titleEn;
  final String titleKh;
  final DateTime start;
  final DateTime? end;
}

String _formatDateRange(DateTime start, DateTime? end) {
  if (end == null) {
    return _formatDate(start);
  }
  return '${_formatDate(start)} - ${_formatDate(end)}';
}

String _monthLabel(DateTime date) {
  const List<String> months = <String>[
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];
  return months[date.month - 1];
}

String _formatDate(DateTime date) {
  const List<String> months = <String>[
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];
  return '${months[date.month - 1]} ${date.day}, ${date.year}';
}
