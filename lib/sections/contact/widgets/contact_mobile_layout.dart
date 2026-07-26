import 'package:flutter/material.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../../constants/portfolio_data.dart';
import 'expandable_contact_tile.dart';
import 'contact_form.dart';
import 'animated_social_icons.dart';

class ContactMobileLayout extends StatelessWidget {
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

  const ContactMobileLayout({
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: ContactForm(
            formKey: formKey,
            nameController: nameController,
            emailController: emailController,
            messageController: messageController,
            isSending: isSending,
            sendEmail: sendEmail,
            isMobile: true,
          ),
        ),

        const SizedBox(height: 40),
        ExpandableContactTile(
          icon: Icons.email,
          label: 'Email',
          value: PortfolioData.email,
          onTap: () => launchEmail(PortfolioData.email),
          isRealMobile: true,
        ),
        const SizedBox(height: 16),
        ExpandableContactTile(
          icon: Icons.phone,
          label: 'Phone',
          value: PortfolioData.phone,
          onTap: () => launchPhone(PortfolioData.phone),
          isRealMobile: true,
        ),
        const SizedBox(height: 24),
        VisibilityDetector(
          key: const Key('social-icons-mobile'),
          onVisibilityChanged: onVisibilityChanged,
          child: AnimatedSocialIcons(
            animationController: socialIconsController,
            onLaunchUrl: launchUrl,
            alignment: WrapAlignment.start,
          ),
        ),
      ],
    );
  }
}
