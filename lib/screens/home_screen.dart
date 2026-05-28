import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../controllers/app_controller.dart';
import '../models/question_item.dart';
import '../utils/app_i18n.dart';
import '../utils/category_assets.dart';
import '../widgets/app_backdrop.dart';
import '../widgets/language_toggle_button.dart';
import '../widgets/module_tile.dart';
import 'exam_intro_screen.dart';
import 'module_screen.dart';
import 'term_dates_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PageController _bannerController = PageController(initialPage: 0);
  Timer? _autoSlideTimer;
  int _bannerIndex = 0;
  int _bannerPage = 0;
  int _navIndex = 0;

  @override
  void initState() {
    super.initState();
    _autoSlideTimer = Timer.periodic(const Duration(seconds: 3), (Timer timer) {
      if (!mounted || !_bannerController.hasClients) return;
      final int nextPage = _bannerPage + 1;
      _bannerController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _autoSlideTimer?.cancel();
    _bannerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppController appController = context.watch<AppController>();
    final bool isKhmer = appController.isKhmer;
    const String fallbackBanner = 'lib/images/img/home-banner.jpg';

    final List<({String title, String subtitle, String icon, VoidCallback onTap})> modules =
        <({String title, String subtitle, String icon, VoidCallback onTap})>[
      (
        title: AppI18n.t('general', isKhmer),
        subtitle: AppI18n.t('basic_rule', isKhmer),
        icon: categoryIconAsset(QuestionCategory.general),
        onTap: () => _openModule(QuestionCategory.general),
      ),
      (
        title: AppI18n.t('sign', isKhmer),
        subtitle: AppI18n.t('traffic_sign', isKhmer),
        icon: categoryIconAsset(QuestionCategory.sign),
        onTap: () => _openModule(QuestionCategory.sign),
      ),
      (
        title: AppI18n.t('priority', isKhmer),
        subtitle: AppI18n.t('right_of_way', isKhmer),
        icon: categoryIconAsset(QuestionCategory.priority),
        onTap: () => _openModule(QuestionCategory.priority),
      ),
      (
        title: AppI18n.t('technique', isKhmer),
        subtitle: AppI18n.t('safe_drive', isKhmer),
        icon: categoryIconAsset(QuestionCategory.technique),
        onTap: () => _openModule(QuestionCategory.technique),
      ),
      (
        title: AppI18n.t('emergency', isKhmer),
        subtitle: AppI18n.t('first_aid', isKhmer),
        icon: categoryIconAsset(QuestionCategory.emergency),
        onTap: () => _openModule(QuestionCategory.emergency),
      ),
      (
        title: AppI18n.t('exam', isKhmer),
        subtitle: AppI18n.t('minutes_45', isKhmer),
        icon: 'lib/images/icon/icon-exam.png',
        onTap: () => Get.to<void>(() => const ExamIntroScreen()),
      ),
    ];

    return Scaffold(
      extendBody: true,
      body: Stack(
        children: <Widget>[
          const AppBackdrop(
            dark: true,
            child: SizedBox.expand(),
          ),
          SafeArea(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.white,
                          child: ClipOval(
                            child: Image.asset(
                              'lib/images/icon/app-logo.png',
                              width: 30,
                              height: 30,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            AppI18n.t('app_name', isKhmer),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const LanguageToggleButton(compact: true),
                        const SizedBox(width: 8),
                        Text(
                          appController.lastPassed == true ? 'KIMCHHAY' : AppI18n.t('user', isKhmer),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.keyboard_arrow_down, color: Colors.white),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 0),
                  sliver: SliverToBoxAdapter(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: SizedBox(
                        height: 185,
                        child: PageView(
                          controller: _bannerController,
                          onPageChanged: (int index) {
                            if (index == 3) {
                              setState(() {
                                _bannerIndex = 0;
                              });
                              _bannerPage = 0;
                              Future<void>.microtask(() {
                                if (!mounted || !_bannerController.hasClients) return;
                                _bannerController.jumpToPage(0);
                              });
                              return;
                            }
                            setState(() {
                              _bannerIndex = index;
                            });
                            _bannerPage = index;
                          },
                          children: <Widget>[
                            _buildBannerCard(
                              title: AppI18n.t('banner_1_title', isKhmer),
                              subtitle: AppI18n.t('banner_1_sub', isKhmer),
                              imageAsset: 'lib/images/img/driving-rules-in-dubai-1.webp',
                              fallbackAsset: fallbackBanner,
                            ),
                            _buildBannerCard(
                              title: AppI18n.t('banner_2_title', isKhmer),
                              subtitle: AppI18n.t('banner_2_sub', isKhmer),
                              imageAsset: 'lib/images/img/images (1).jpg',
                              fallbackAsset: fallbackBanner,
                            ),
                            _buildBannerCard(
                              title: AppI18n.t('banner_3_title', isKhmer),
                              subtitle: AppI18n.t('banner_3_sub', isKhmer),
                              imageAsset: 'lib/images/img/images.jpg',
                              fallbackAsset: fallbackBanner,
                            ),
                            _buildBannerCard(
                              title: AppI18n.t('banner_1_title', isKhmer),
                              subtitle: AppI18n.t('banner_1_sub', isKhmer),
                              imageAsset: 'lib/images/img/driving-rules-in-dubai-1.webp',
                              fallbackAsset: fallbackBanner,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
                  sliver: SliverToBoxAdapter(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List<Widget>.generate(3, (int index) {
                        final bool selected = index == _bannerIndex;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: selected ? 18 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: selected ? Colors.white : const Color(0x88FFFFFF),
                          ),
                        );
                      }),
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(14, 12, 14, 92),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        final module = modules[index];
                        return ModuleTile(
                          title: module.title,
                          subtitle: module.subtitle,
                          iconAsset: module.icon,
                          onTap: module.onTap,
                        );
                      },
                      childCount: modules.length,
                    ),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.94,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 0, 10, 12),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
                  child: Container(
                    height: 58,
                    decoration: BoxDecoration(
                      color: const Color(0x55FFFFFF),
                      border: Border.all(color: const Color(0x77FFFFFF)),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _buildNavItem(0, Icons.home_rounded, AppI18n.t('home', isKhmer)),
                        _buildNavItem(1, Icons.feed_outlined, AppI18n.t('news', isKhmer)),
                        _buildNavItem(2, Icons.inbox_rounded, AppI18n.t('inbox', isKhmer)),
                        _buildNavItem(3, Icons.calendar_month_outlined, AppI18n.t('dates', isKhmer)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBannerCard({
    required String title,
    required String subtitle,
    required String imageAsset,
    required String fallbackAsset,
  }) {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Image.asset(
          imageAsset,
          fit: BoxFit.cover,
          errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) {
            return Image.asset(
              fallbackAsset,
              fit: BoxFit.cover,
            );
          },
        ),
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Color(0x22000000),
                Color(0xAA003356),
              ],
            ),
          ),
        ),
        Positioned(
          left: 14,
          right: 14,
          bottom: 16,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 18,
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
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final bool selected = _navIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _navIndex = index;
        });
        if (index == 3) {
          Get.to<void>(() => const TermDatesScreen());
        }
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            icon,
            size: 20,
            color: selected ? Colors.white : const Color(0xC7E8F2FF),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: selected ? Colors.white : const Color(0xC7E8F2FF),
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _openModule(QuestionCategory category) {
    Get.to<void>(() => ModuleScreen(category: category));
  }
}
