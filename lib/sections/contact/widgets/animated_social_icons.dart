import 'package:flutter/material.dart';
import 'package:simple_icons/simple_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../../../constants/portfolio_data.dart';
import 'social_icon_button.dart';

class AnimatedSocialIcons extends StatelessWidget {
  final AnimationController animationController;
  final void Function(String url) onLaunchUrl;
  final WrapAlignment alignment;

  const AnimatedSocialIcons({
    super.key,
    required this.animationController,
    required this.onLaunchUrl,
    this.alignment = WrapAlignment.start,
  });

  List<Map<String, dynamic>> _getSocialIcons() {
    return <Map<String, dynamic>>[
      if (PortfolioData.githubUrl.isNotEmpty)
        {
          'icon': SimpleIcons.github,
          'color': const Color(0xFF181717),
          'url': PortfolioData.githubUrl,
        },
      if (PortfolioData.linkedinUrl.isNotEmpty)
        {
          'icon': FontAwesomeIcons.linkedin,
          'color': const Color(0xFF0A66C2),
          'url': PortfolioData.linkedinUrl,
        },

      if (PortfolioData.whatsappUrl.isNotEmpty)
        {
          'icon': SimpleIcons.whatsapp,
          'color': const Color(0xFF25D366),
          'url': PortfolioData.whatsappUrl,
        },
    ];
  }

  @override
  Widget build(BuildContext context) {
    final socialIcons = _getSocialIcons();

    return Center(
      child: Wrap(
        spacing: 16,
        runSpacing: 16,
        alignment: alignment,
        children: List.generate(socialIcons.length, (index) {
          final startInterval = index * 0.15;
          final endInterval = startInterval + 0.4;

          final animation = CurvedAnimation(
            parent: animationController,
            curve: Interval(
              startInterval.clamp(0.0, 1.0),
              endInterval.clamp(0.0, 1.0),
              curve: Curves.linearToEaseOut,
            ),
          );

          return AnimatedBuilder(
            animation: animation,
            builder: (context, child) {
              final clampedOpacity = animation.value.clamp(0.0, 1.0);
              return Transform.translate(
                offset: Offset(0, -50 * (1 - animation.value)),
                child: Opacity(opacity: clampedOpacity, child: child),
              );
            },
            child: SocialIconButton(
              icon: socialIcons[index]['icon'] as IconData,
              brandColor: socialIcons[index]['color'] as Color,
              onTap: () => onLaunchUrl(socialIcons[index]['url'] as String),
            ),
          );
        }),
      ),
    );
  }
}
