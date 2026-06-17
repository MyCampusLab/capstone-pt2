import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/health_quiz_controller.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import 'package:visionsafe/app/presentation/global_widgets/atoms/v_button.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/vizo_mascot.dart';
import 'package:visionsafe/app/presentation/global_widgets/templates/base_screen_template.dart';

class HealthQuizView extends GetView<HealthQuizController> {
  const HealthQuizView({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseScreenTemplate(
      appBar: AppBar(
        title: Text('KUIS SEHAT', style: AppTextStyles.heading2),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primaryDark),
          onPressed: () => Get.back(),
        ),
      ),
      bottomPadding: 140,
      child: Obx(() {
        if (controller.isQuizFinished.value) {
          return _buildResultScreen();
        }
        return _buildQuizScreen();
      }),
    );
  }

  Widget _buildQuizScreen() {
    final questionData = controller.questions[controller.currentQuestionIndex.value];
    final questionText = questionData['question'] as String;
    final options = questionData['options'] as List<String>;
    final correctIndex = questionData['correctIndex'] as int;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Progress Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "SOAL ${controller.currentQuestionIndex.value + 1}/${controller.questions.length}",
              style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "SKOR: ${controller.score.value}",
                style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        
        // Question Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.primaryDark, width: 3),
            boxShadow: const [
              BoxShadow(
                color: AppColors.primaryDark,
                offset: Offset(4, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Hero(
                tag: 'vizo_quiz',
                child: VizoMascot(
                  size: 80, 
                  state: controller.isAnswerRevealed.value 
                      ? (controller.selectedAnswer.value == correctIndex ? VizoState.happy : VizoState.sad)
                      : VizoState.idle,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                questionText,
                textAlign: TextAlign.center,
                style: AppTextStyles.heading2.copyWith(fontSize: 18),
              ),
            ],
          ),
        ),
        const SizedBox(height: 32),

        // Options
        ...List.generate(options.length, (index) {
          return _buildOptionButton(index, options[index], correctIndex);
        }),

        const SizedBox(height: 24),

        // Explanation / Next Button
        if (controller.isAnswerRevealed.value) ...[
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: controller.selectedAnswer.value == correctIndex 
                  ? AppColors.success.withAlpha(30)
                  : AppColors.danger.withAlpha(30),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: controller.selectedAnswer.value == correctIndex 
                    ? AppColors.success 
                    : AppColors.danger,
                width: 2,
              ),
            ),
            child: Text(
              questionData['explanation'] as String,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(fontSize: 13),
            ),
          ),
          const SizedBox(height: 24),
          VButton(
            label: controller.currentQuestionIndex.value == controller.questions.length - 1 
                ? "LIHAT HASIL" 
                : "LANJUT",
            onPressed: controller.nextQuestion,
          ),
        ]
      ],
    );
  }

  Widget _buildOptionButton(int index, String text, int correctIndex) {
    bool isSelected = controller.selectedAnswer.value == index;
    bool isRevealed = controller.isAnswerRevealed.value;
    bool isCorrect = index == correctIndex;

    Color bgColor = Colors.white;
    Color borderColor = AppColors.primaryDark;
    Color textColor = AppColors.primaryDark;

    if (isRevealed) {
      if (isCorrect) {
        bgColor = AppColors.success;
        textColor = Colors.white;
        borderColor = AppColors.success;
      } else if (isSelected) {
        bgColor = AppColors.danger;
        textColor = Colors.white;
        borderColor = AppColors.danger;
      } else {
        bgColor = Colors.grey[200]!;
        borderColor = Colors.grey[400]!;
        textColor = Colors.grey[500]!;
      }
    } else if (isSelected) {
      bgColor = AppColors.secondary.withAlpha(40);
      borderColor = AppColors.secondary;
    }

    return GestureDetector(
      onTap: () => controller.submitAnswer(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 2),
          boxShadow: isRevealed ? null : const [
            BoxShadow(
              color: AppColors.primaryDark,
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isRevealed && isCorrect ? Colors.white.withAlpha(50) : AppColors.primaryDark.withAlpha(10),
              ),
              child: Text(
                String.fromCharCode(65 + index), // A, B, C, D
                style: AppTextStyles.bodyBold.copyWith(color: textColor),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                text,
                style: AppTextStyles.bodyBold.copyWith(color: textColor),
              ),
            ),
            if (isRevealed && isCorrect)
              const Icon(Icons.check_circle, color: Colors.white)
            else if (isRevealed && isSelected && !isCorrect)
              const Icon(Icons.cancel, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildResultScreen() {
    final totalQuestions = controller.questions.length;
    final score = controller.score.value;
    final xpGained = score * 20;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          VizoMascot(
            size: 120,
            state: score > (totalQuestions / 2) ? VizoState.happy : VizoState.sad,
          ),
          const SizedBox(height: 32),
          Text(
            "KUIS SELESAI!",
            style: AppTextStyles.heading1,
          ),
          const SizedBox(height: 8),
          Text(
            "Kamu menjawab $score dari $totalQuestions pertanyaan dengan benar.",
            textAlign: TextAlign.center,
            style: AppTextStyles.bodyMedium,
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 20),
            decoration: BoxDecoration(
              color: AppColors.secondary,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.primaryDark, width: 3),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.primaryDark,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Text(
                  "REWARD XP",
                  style: AppTextStyles.caption.copyWith(color: Colors.white, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  "+$xpGained XP",
                  style: AppTextStyles.heading1.copyWith(color: Colors.white, fontSize: 32),
                ),
              ],
            ),
          ),
          const SizedBox(height: 48),
          VButton(
            label: "KEMBALI KE MENU",
            onPressed: () => Get.back(),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: controller.resetQuiz,
            child: Text(
              "MAIN LAGI",
              style: AppTextStyles.bodyBold.copyWith(color: AppColors.primary),
            ),
          ),
        ],
      ),
    );
  }
}
