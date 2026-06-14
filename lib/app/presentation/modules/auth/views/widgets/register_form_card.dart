import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_input.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/auth/auth_divider.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/auth/auth_social_section.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/core/values/app_design.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/presentation/global_widgets/animations/fade_in_up.dart';

/// RegisterFormCard: Elite Hero Quest Registration Card.
class RegisterFormCard extends GetView<AuthController> {
  const RegisterFormCard({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppDesign.radiusL),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: AnimatedContainer(
          duration: AppDesign.slow,
          curve: AppDesign.smoothCurve,
          padding: const EdgeInsets.all(AppDesign.space24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.82), 
            borderRadius: BorderRadius.circular(AppDesign.radiusL),
            border: Border.all(
              color: AppColors.primaryDark.withValues(alpha: 0.1), 
              width: 1.5,
            ),
            boxShadow: AppDesign.premiumShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeading(),
              const SizedBox(height: AppDesign.space32),
              
              FadeInUp(
                delay: const Duration(milliseconds: 100),
                child: VInput(
                  key: const Key('reg_name_input'),
                  hint: "Full Name",
                  prefixIcon: Icons.badge_outlined,
                  controller: controller.nameController,
                  autofillHints: const [AutofillHints.name],
                  textInputAction: TextInputAction.next,
                  focusNode: controller.regNameFocus,
                ),
              ),
              
              const SizedBox(height: AppDesign.space12),
              
              FadeInUp(
                delay: const Duration(milliseconds: 200),
                child: VInput(
                  key: const Key('reg_email_input'),
                  hint: "Email Address",
                  prefixIcon: Icons.email_outlined,
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.next,
                  focusNode: controller.regEmailFocus,
                ),
              ),
              
              const SizedBox(height: AppDesign.space12),
              
              FadeInUp(
                delay: const Duration(milliseconds: 300),
                child: VInput(
                  key: const Key('reg_password_input'),
                  hint: "Password",
                  prefixIcon: Icons.lock_outline_rounded,
                  isPassword: true,
                  controller: controller.passwordController,
                  autofillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.next,
                  focusNode: controller.regPasswordFocus,
                ),
              ),
              
              const SizedBox(height: AppDesign.space12),
              
              FadeInUp(
                delay: const Duration(milliseconds: 400),
                child: VInput(
                  key: const Key('reg_confirm_password_input'),
                  hint: "Confirm Password",
                  prefixIcon: Icons.lock_reset_rounded,
                  isPassword: true,
                  controller: controller.confirmPasswordController,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => controller.register(),
                  focusNode: controller.regConfirmPasswordFocus,
                ),
              ),
              
              const SizedBox(height: AppDesign.space32),
              
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: Obx(() => VButton(
                  label: "CREATE ACCOUNT",
                  icon: Icons.person_add_alt_1_rounded,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.isLoading.value ? null : () => controller.register(),
                )),
              ),
              
              const SizedBox(height: AppDesign.space24),
              const FadeInUp(delay: Duration(milliseconds: 600), child: AuthDivider()),
              const SizedBox(height: AppDesign.space24),
              
              FadeInUp(
                delay: const Duration(milliseconds: 700),
                child: Obx(() => IgnorePointer(
                  ignoring: controller.isLoading.value,
                  child: Opacity(
                    opacity: controller.isLoading.value ? 0.5 : 1.0,
                    child: AuthSocialSection(
                      onGoogleTap: () => controller.loginWithGoogle(),
                    ),
                  ),
                )),
              ),
              
              const SizedBox(height: AppDesign.space12),
              _buildTermsText(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeading() {
    return Column(
      children: [
        Text(
          "Join the Quest!",
          textAlign: TextAlign.center,
          style: AppTextStyles.heading1.copyWith(
            color: AppColors.primaryDark,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: AppDesign.space4),
        Text(
          "Create an account to start your journey.",
          style: AppTextStyles.caption.copyWith(
            color: AppColors.primaryDark.withValues(alpha: 0.6), 
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildTermsText() {
    return Text(
      "By joining, you agree to our Terms of Service.",
      textAlign: TextAlign.center,
      style: AppTextStyles.caption.copyWith(
        color: AppColors.primaryDark.withValues(alpha: 0.45),
        fontWeight: FontWeight.w600,
        fontSize: 10,
      ),
    );
  }
}
