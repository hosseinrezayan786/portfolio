import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../constants/portfolio_data.dart';
import 'expandable_contact_tile.dart';
import 'contact_form.dart';
import 'animated_social_icons.dart';

class ContactDesktopLayout extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController messageController;
  final bool isSending;
  final VoidCallback sendEmail;
  final AnimationController socialIconsController;
  final void Function(VisibilityInfo info) onVisibilityChanged;
  final void Function(String url) launchUrl;
  final void Function(String email) launchEmail;
  final void Function(String phone) launchPhone;

  const ContactDesktopLayout({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.messageController,
    required this.isSending,
    required this.sendEmail,
    required this.socialIconsController,
    required this.onVisibilityChanged,
    required this.launchUrl,
    required this.launchEmail,
    required this.launchPhone,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ExpandableContactTile(
                icon: Icons.email,
                label: 'Email',
                value: PortfolioData.email,
                onTap: () => launchEmail(PortfolioData.email),
              ),
              const SizedBox(height: 16),
              ExpandableContactTile(
                icon: Icons.phone,
                label: 'Phone',
                value: PortfolioData.phone,
                onTap: () => launchPhone(PortfolioData.phone),
              ),
              const SizedBox(height: 24),
              VisibilityDetector(
                key: const Key('social-icons-desktop'),
                onVisibilityChanged: onVisibilityChanged,
                child: AnimatedSocialIcons(
                  animationController: socialIconsController,
                  onLaunchUrl: launchUrl,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 40),
        Expanded(
          flex: 2,
          child: Center(
            child: ContactForm(
              formKey: formKey,
              nameController: nameController,
              emailController: emailController,
              messageController: messageController,
              isSending: isSending,
              sendEmail: sendEmail,
              isMobile: false,
            ),
          ),
        ),
        const SizedBox(width: 40),
        const Expanded(child: SizedBox()),
      ],
    );
  }
}
