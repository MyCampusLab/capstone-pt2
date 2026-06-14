import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/auth/auth_footer_link.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_immersive_background.dart';
import 'widgets/register_form_card.dart';
import 'package:visionsafe/app/routes/app_pages.dart';
import 'package:visionsafe/app/core/values/app_design.dart';
import 'package:visionsafe/app/presentation/global_widgets/animations/fade_in_up.dart';

/// RegisterView: World-Class Auth Experience.
class RegisterView extends GetView<AuthController> {
  const RegisterView({super.key});

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
                          size: 150,
                          state: controller.registerMascotState.value,
                          lookAt: controller.registerLookAt.value,
                        )),
                      ),
                    ),
                    const SizedBox(width: AppDesign.spaceXL),
                    Expanded(
                      flex: 6,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const RegisterFormCard(),
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
                    SizedBox(height: isSmall ? AppDesign.spaceL : AppDesign.space32),
                    
                    // Hero Mascot with peeking tag
                    Hero(
                      tag: 'vizo_mascot',
                      child: Obx(() => VizoMascot(
                        size: isSmall ? 100 : 130,
                        state: controller.registerMascotState.value,
                        lookAt: controller.registerLookAt.value,
                      )),
                    ),
                    
                    SizedBox(height: isSmall ? AppDesign.spaceM : AppDesign.space24),
                    
                    // Elite Form Card
                    const RegisterFormCard(),
                    
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
        text: "Already a Hero? ",
        linkText: "Back to Quest!",
        onTap: () {
          controller.clearFields();
          Get.offNamed(Routes.login);
        },
      ),
    );
  }
}
