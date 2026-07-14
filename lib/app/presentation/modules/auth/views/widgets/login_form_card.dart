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

/// LoginFormCard: Elite Hero Quest Auth Card.
class LoginFormCard extends GetView<AuthController> {
  const LoginFormCard({super.key});

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
                delay: const Duration(milliseconds: 200),
                child: VInput(
                  key: const Key('login_email_input'),
                  hint: "Username/Email",
                  prefixIcon: Icons.alternate_email_rounded,
                  controller: controller.emailController,
                  keyboardType: TextInputType.emailAddress,
                  autofillHints: const [AutofillHints.email],
                  textInputAction: TextInputAction.next,
                  focusNode: controller.loginEmailFocus,
                ),
              ),
              
              const SizedBox(height: AppDesign.space16),
              
              FadeInUp(
                delay: const Duration(milliseconds: 350),
                child: VInput(
                  key: const Key('login_password_input'),
                  hint: "Password",
                  prefixIcon: Icons.lock_person_rounded,
                  isPassword: true,
                  controller: controller.passwordController,
                  autofillHints: const [AutofillHints.password],
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => controller.login(),
                  focusNode: controller.loginPasswordFocus,
                ),
              ),
              
              _buildForgotPassword(),
              const SizedBox(height: AppDesign.space32),
              
              FadeInUp(
                delay: const Duration(milliseconds: 500),
                child: Obx(() => VButton(
                  label: "LET'S GO!",
                  icon: Icons.bolt_rounded,
                  isLoading: controller.isLoading.value,
                  onPressed: controller.isLoading.value ? null : () => controller.login(),
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
          "Welcome Back, Hero!",
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
          "Log in to keep your eyes safe.",
          style: AppTextStyles.caption.copyWith(
            color: AppColors.primaryDark.withValues(alpha: 0.6), 
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildForgotPassword() {
    return Align(
      alignment: Alignment.centerRight,
      child: Padding(
        padding: const EdgeInsets.only(top: AppDesign.space12),
        child: GestureDetector(
          onTap: () => controller.showForgotPasswordDialog(),
          child: Text(
            "Forgot Password?",
            style: AppTextStyles.caption.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
              fontSize: 11,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ),
    );
  }
}
