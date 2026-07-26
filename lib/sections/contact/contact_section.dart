import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:personal_portfolio/utils/email_function.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../../constants/colors.dart';
import '../../constants/text_styles.dart';

import 'widgets/contact_widgets.dart';

class ContactSection extends StatefulWidget {
  final Function(VoidCallback)? onRegisterReset;

  const ContactSection({super.key, this.onRegisterReset});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isSending = false;

  late AnimationController _socialIconsController;
  bool _hasAnimated = false;

  @override
  void initState() {
    super.initState();
    _socialIconsController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && widget.onRegisterReset != null) {
        widget.onRegisterReset!(resetAnimations);
      }
    });
  }

  void resetAnimations() {
    setState(() {
      _hasAnimated = false;
    });
    _socialIconsController.reset();
  }

  void _onVisibilityChanged(VisibilityInfo info) {
    if (info.visibleFraction > 0.3 && !_hasAnimated && mounted) {
      _socialIconsController.forward();
      _hasAnimated = true;
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchEmail(String email) async {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    if (!isMobile) {
      // Desktop: open Gmail in new tab
      final gmailUrl = 'https://mail.google.com/mail/?view=cm&fs=1&to=$email';
      if (await canLaunchUrl(Uri.parse(gmailUrl))) {
        await launchUrl(Uri.parse(gmailUrl));
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Could not open Gmail.')));
        }
      }
    } else {
      // Mobile: use mailto link
      final Uri emailLaunchUri = Uri(scheme: 'mailto', path: email);
      if (await canLaunchUrl(emailLaunchUri)) {
        await launchUrl(emailLaunchUri);
      } else {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Could not open email app.')));
        }
      }
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _sendEmail() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSending = true;
    });

    try {
      final name = _nameController.text.trim();
      final message = _messageController.text.trim();
      final email = _emailController.text.trim();

      final result = await sendContactForm(name, email, message);
      if (result) {
        _nameController.clear();
        _emailController.clear();
        _messageController.clear();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Email sent successfully!',
                style: AppTextStyles.bodySmall(
                  context,
                ).copyWith(color: Colors.white),
              ),
              backgroundColor: AppColors.primary,
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Failed to send email!',
                style: AppTextStyles.bodySmall(
                  context,
                ).copyWith(color: Colors.white),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSending = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    _socialIconsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isMobile = size.width < 768;
    final keyboardHeight = MediaQuery.viewInsetsOf(context).bottom;

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: Stack(
        children: [
          if (!isMobile)
            Positioned.fill(
              child: CustomPaint(painter: TiltedBackgroundPainter()),
            ),
          if (isMobile)
            Positioned(
              left: 0,
              right: 0,
              top: 235,
              height: kIsWeb ? 320 : 460,
              child: CustomPaint(painter: MobileFormBackgroundPainter()),
            ),
          AnimatedPadding(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeOut,
            padding: EdgeInsets.only(
              left: isMobile ? 20 : 60,
              right: isMobile ? 20 : 60,
              top: isMobile ? 60 : 100,
              bottom: isMobile ? 40 + keyboardHeight : 60,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('CONTACT ME', style: AppTextStyles.sectionTitle(context)),
                const SizedBox(height: 16),
                Text(
                  'Let\'s Build Something Meaningful',
                  style: AppTextStyles.heading2(context),
                ),
                const SizedBox(height: 16),
                Text(
                  'Every great product starts with a conversation. If you\'re building something that can make people\'s lives easier, I\'d be happy to help bring it to life.',
                  style: AppTextStyles.bodyLarge(context),
                ),
                const SizedBox(height: 60),
                isMobile
                    ? ContactMobileLayout(
                        formKey: _formKey,
                        nameController: _nameController,
                        emailController: _emailController,
                        messageController: _messageController,
                        isSending: _isSending,
                        sendEmail: _sendEmail,
                        socialIconsController: _socialIconsController,
                        onVisibilityChanged: _onVisibilityChanged,
                        launchUrl: _launchUrl,
                        launchEmail: _launchEmail,
                        launchPhone: _launchPhone,
                      )
                    : ContactDesktopLayout(
                        formKey: _formKey,
                        nameController: _nameController,
                        emailController: _emailController,
                        messageController: _messageController,
                        isSending: _isSending,
                        sendEmail: _sendEmail,
                        socialIconsController: _socialIconsController,
                        onVisibilityChanged: _onVisibilityChanged,
                        launchUrl: _launchUrl,
                        launchEmail: _launchEmail,
                        launchPhone: _launchPhone,
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
