import 'package:flutter/material.dart';
import '../../../constants/colors.dart';
import '../../../constants/text_styles.dart';
import 'hover_button.dart';

class ContactForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController messageController;
  final bool isSending;
  final VoidCallback sendEmail;
  final bool isMobile;

  const ContactForm({
    super.key,
    required this.formKey,
    required this.nameController,
    required this.emailController,
    required this.messageController,
    required this.isSending,
    required this.sendEmail,
    this.isMobile = false,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final maxWidth = size.width < 768 ? double.infinity : 500.0;

    final fieldTextStyle = isMobile
        ? AppTextStyles.bodySmall(context)
        : AppTextStyles.bodyMedium(context);
    final fieldSpacing = isMobile ? 14.0 : 20.0;
    final contentPadding = isMobile
        ? const EdgeInsets.symmetric(horizontal: 12, vertical: 12)
        : null;

    final borderRadius = BorderRadius.circular(10);
    final border = isMobile
        ? OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.55),
            ),
          )
        : UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primary.withValues(alpha: 0.3),
            ),
          );
    final focusedBorder = isMobile
        ? OutlineInputBorder(
            borderRadius: borderRadius,
            borderSide: const BorderSide(
              color: AppColors.primaryLight,
              width: 2,
            ),
          )
        : const UnderlineInputBorder(
            borderSide: BorderSide(
              color: AppColors.primaryLight,
              width: 2,
            ),
          );

    return SizedBox(
      width: maxWidth,
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: nameController,
              autovalidateMode: AutovalidateMode.onUnfocus,
              decoration: InputDecoration(
                labelText: 'Name',
                hintText: 'Your name',
                isDense: isMobile,
                contentPadding: contentPadding,
                border: border,
                enabledBorder: border,
                focusedBorder: focusedBorder,
                labelStyle: fieldTextStyle,
                filled: isMobile,
                fillColor:
                    isMobile ? AppColors.background.withValues(alpha: 0.5) : null,
              ),
              style: fieldTextStyle,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            SizedBox(height: fieldSpacing),
            TextFormField(
              controller: emailController,
              autovalidateMode: AutovalidateMode.onUnfocus,
              decoration: InputDecoration(
                labelText: 'Email',
                hintText: 'your.email@example.com',
                isDense: isMobile,
                contentPadding: contentPadding,
                border: border,
                enabledBorder: border,
                focusedBorder: focusedBorder,
                labelStyle: fieldTextStyle,
                filled: isMobile,
                fillColor:
                    isMobile ? AppColors.background.withValues(alpha: 0.5) : null,
              ),
              style: fieldTextStyle,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter your email';
                }
                final emailRegex = RegExp(
                  r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$',
                );
                if (!emailRegex.hasMatch(value.trim())) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            SizedBox(height: fieldSpacing),
            TextFormField(
              controller: messageController,
              autovalidateMode: AutovalidateMode.onUnfocus,
              decoration: InputDecoration(
                labelText: 'Message',
                hintText: 'Your message...',
                isDense: isMobile,
                contentPadding: contentPadding,
                border: border,
                enabledBorder: border,
                focusedBorder: focusedBorder,
                labelStyle: fieldTextStyle,
                filled: isMobile,
                fillColor:
                    isMobile ? AppColors.background.withValues(alpha: 0.5) : null,
              ),
              style: fieldTextStyle,
              maxLines: isMobile ? 3 : 4,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Please enter a message';
                }
                return null;
              },
            ),
            SizedBox(height: isMobile ? 20 : 30),
            HoverButton(
              onPressed: isSending ? null : sendEmail,
              child: isSending
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      'Send Message',
                      style: (isMobile
                              ? AppTextStyles.bodySmall(context)
                              : AppTextStyles.bodyMedium(context))
                          .copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
