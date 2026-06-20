import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import '../atoms/v_card.dart';
import '../atoms/v_button.dart';
import 'package:confetti/confetti.dart';

/// Utilitas Dialog bergaya VCard untuk konsistensi UI/UX Elite.
class VDialog {
  static void show({
    required String title,
    String? message,
    Widget? content,
    String confirmLabel = "OK!",
    String? cancelLabel,
    IconData icon = Icons.info_outline_rounded,
    Color iconColor = AppColors.primary,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool hideButtons = false,
    bool showConfetti = false,
    bool barrierDismissible = true,
  }) {
    HapticFeedback.mediumImpact();
    
    Get.dialog(
      _ConfettiDialogWrapper(
        showConfetti: showConfetti,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Material(
            color: Colors.transparent,
            child: VCard(
              padding: 24,
              child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: iconColor.withAlpha(20),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: 40),
                ),
                const SizedBox(height: 20),
                Text(
                  title.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.primaryDark,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 12),
                if (message != null)
                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primaryDark.withAlpha(180),
                      height: 1.5,
                    ),
                  ),
                if (content != null) ...[
                  const SizedBox(height: 16),
                  content,
                ],
                if (!hideButtons) ...[
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      if (cancelLabel != null) ...[
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              HapticFeedback.lightImpact();
                              Get.back();
                              onCancel?.call();
                            },
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              side: const BorderSide(color: AppColors.primaryDark, width: 2),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            ),
                            child: Text(
                              cancelLabel.toUpperCase(),
                              style: AppTextStyles.bodyBold.copyWith(fontSize: 14, color: AppColors.primaryDark),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],
                      Expanded(
                        child: VButton(
                          label: confirmLabel,
                          onPressed: () {
                            Get.back();
                            onConfirm?.call();
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
            ),
          ),
          ),
        ),
      ),
      barrierColor: Colors.black.withAlpha(100),
      barrierDismissible: barrierDismissible,
      transitionCurve: Curves.elasticOut,
    );
  }
}

class _ConfettiDialogWrapper extends StatefulWidget {
  final Widget child;
  final bool showConfetti;

  const _ConfettiDialogWrapper({required this.child, this.showConfetti = false});

  @override
  State<_ConfettiDialogWrapper> createState() => _ConfettiDialogWrapperState();
}

class _ConfettiDialogWrapperState extends State<_ConfettiDialogWrapper> {
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    if (widget.showConfetti) {
      _confettiController.play();
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        widget.child,
        if (widget.showConfetti)
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              shouldLoop: false,
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              maxBlastForce: 100,
              minBlastForce: 80,
              gravity: 0.2,
              colors: const [Colors.green, Colors.blue, Colors.pink, Colors.orange, Colors.purple],
            ),
          ),
      ],
    );
  }
}
