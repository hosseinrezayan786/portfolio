import 'package:flutter/material.dart';
import 'package:personal_portfolio/constants/colors.dart';
import 'package:personal_portfolio/screens/widget/navigation_bar.dart';
import 'package:personal_portfolio/sections/about/about_section.dart';
import 'package:personal_portfolio/sections/contact/contact_section.dart';
import 'package:personal_portfolio/sections/experience/experience_section.dart';
import 'package:personal_portfolio/sections/home/home_section.dart';
import 'package:personal_portfolio/sections/projects/projects_section.dart';
import 'package:personal_portfolio/sections/skill/skill_section.dart';

class NewPortfolioScreen extends StatefulWidget {
  const NewPortfolioScreen({super.key});

  @override
  State<NewPortfolioScreen> createState() => _NewPortfolioScreenState();
}

class _NewPortfolioScreenState extends State<NewPortfolioScreen> {
  final ScrollController _scrolController = ScrollController();

  final homeKey = GlobalKey();
  final aboutKey = GlobalKey();
  final skillsKey = GlobalKey();
  final projectsKey = GlobalKey();
  final experienceKey = GlobalKey();
  final contactKey = GlobalKey();

  final int _currentSection = 0;

  // Future<void> scrollToSection(GlobalKey key) async {
  //   final context = key.currentContext;

  //   if (context == null) return;

  //   await Scrollable.ensureVisible(
  //     context,
  //     duration: const Duration(milliseconds: 500),
  //     curve: Curves.easeInOut,
  //   );
  // }

  void scrollToSection(int sectionIndex) {
    if (sectionIndex < 0 || sectionIndex > 5) return;

    // Special case for Home section - scroll to top
    if (sectionIndex == 0) {
      _scrolController.animateTo(
        0,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
      return;
    }

    final sectionKeys = [
      aboutKey,
      skillsKey,
      projectsKey,
      experienceKey,
      contactKey,
    ];

    final keyIndex = sectionIndex - 1; // Adjust for Home being index 0
    if (keyIndex < 0 || keyIndex >= sectionKeys.length) return;

    final key = sectionKeys[keyIndex];
    final context = key.currentContext;
    if (context == null) return;

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    try {
      final position = renderBox.localToGlobal(Offset.zero);
      final scrollOffset = _scrolController.offset;
      final targetOffset = scrollOffset + position.dy;

      _scrolController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    } catch (e) {
      // Fallback to old method
      final double screenHeight = MediaQuery.of(this.context).size.height;
      final double targetOffset = sectionIndex * screenHeight;
      _scrolController.animateTo(
        targetOffset,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,

      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrolController,
            child: Column(
              children: [
                SizedBox(
                  height: 800,
                  width: double.infinity,
                  child: HomeSection(key: homeKey),
                ),
                SizedBox(
                  height: 800,
                  width: double.infinity,
                  child: AboutSection(key: aboutKey),
                ),
                SkillsSection(key: skillsKey),
                ProjectsSection(key: projectsKey),
                ExperienceSection(key: experienceKey),
                ContactSection(key: contactKey),
              ],
            ),
          ),

          Positioned(
            top: 0,
            left: 0,
            right: 0,

            child: PortfolioNavigationBar(
              currentSection: _currentSection,
              onSectionTap: (sectionIndex) {
                scrollToSection(sectionIndex);
              },
            ),
          ),
        ],
      ),
    );
  }
}
