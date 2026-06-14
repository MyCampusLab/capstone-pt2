import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/auth/auth_footer_link.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_immersive_background.dart';
import 'widgets/login_form_card.dart';
import 'package:visionsafe/app/routes/app_pages.dart';
import 'package:visionsafe/app/core/values/app_design.dart';

import 'package:visionsafe/app/presentation/global_widgets/animations/fade_in_up.dart';

/// LoginView: World-Class Auth Experience.
/// Features immersive layered background, responsive centering, and AAA animations.
class LoginView extends GetView<AuthController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0EAFC),
      resizeToAvoidBottomInset: true,
      body: VImmersiveBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isSmall = constraints.maxHeight < 700;
              final isLandscape = constraints.maxWidth > constraints.maxHeight;
              
              Widget bodyContent;
              if (isLandscape) {
                bodyContent = Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 4,
                      child: Hero(
                        tag: 'vizo_mascot',
                        child: Obx(() => VizoMascot(
                          size: 180,
                          state: controller.loginMascotState.value,
                          lookAt: controller.loginLookAt.value,
                        )),
                      ),
                    ),
                    const SizedBox(width: AppDesign.spaceXL),
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const LoginFormCard(),
                          const SizedBox(height: AppDesign.space16),
                          _buildFooter(),
                        ],
                      ),
                    ),
                  ],
                );
              } else {
                bodyContent = Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: isSmall ? AppDesign.spaceXL : AppDesign.space64),
                    
                    // Hero Mascot with floating animation
                    Hero(
                      tag: 'vizo_mascot',
                      child: Obx(() => VizoMascot(
                        size: isSmall ? 130 : 160,
                        state: controller.loginMascotState.value,
                        lookAt: controller.loginLookAt.value,
                      )),
                    ),
                    
                    SizedBox(height: isSmall ? AppDesign.spaceL : AppDesign.space40),
                    
                    // Elite Form Card
                    const LoginFormCard(),
                    
                    const SizedBox(height: AppDesign.space32),
                    
                    // Modern Footer
                    _buildFooter(),
                    
                    const SizedBox(height: AppDesign.spaceXL),
                  ],
                );
              }
              
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: AppDesign.spaceL),
                    child: bodyContent,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return FadeInUp(
      delay: const Duration(milliseconds: 800),
      child: AuthFooterLink(
        text: "New here? ",
        linkText: "Join the quest!",
        onTap: () {
          controller.clearFields();
          Get.toNamed(Routes.register);
        },
      ),
    );
  }
}
