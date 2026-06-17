import 'package:get/get.dart';
import 'package:visionsafe/app/data/services/reward_service.dart';

class HealthQuizController extends GetxController {
  final _rewardService = Get.find<RewardService>();

  final currentQuestionIndex = 0.obs;
  final score = 0.obs;
  final isQuizFinished = false.obs;
  final selectedAnswer = (-1).obs;
  final isAnswerRevealed = false.obs;

  final questions = [
    {
      'question': 'Berapa jarak ideal antara mata dengan layar HP?',
      'options': ['10 - 20 cm', '30 - 40 cm', '50 - 60 cm', 'Lebih dari 1 meter'],
      'correctIndex': 1,
      'explanation': 'Jarak aman mata ke layar HP adalah sekitar 30-40 cm untuk mencegah kelelahan otot mata (Astenopia).',
    },
    {
      'question': 'Apa itu aturan 20-20-20?',
      'options': [
        'Tidur 20 jam sehari',
        'Setiap 20 menit, lihat benda berjarak 20 kaki selama 20 detik',
        'Kedip 20 kali dalam 20 detik',
        'Main HP maksimal 20 menit sehari'
      ],
      'correctIndex': 1,
      'explanation': 'Aturan 20-20-20 dirancang oleh ahli optometri untuk merelaksasi otot silia mata saat menatap layar dekat terlalu lama.',
    },
    {
      'question': 'Mengapa kita sering lupa berkedip saat main game di HP?',
      'options': [
        'Karena layar HP terlalu terang',
        'Karena kita sangat fokus',
        'Karena radiasi hp membuat mata kaku',
        'Karena game mengatur kedipan mata'
      ],
      'correctIndex': 1,
      'explanation': 'Saat sangat fokus, frekuensi kedipan mata manusia bisa turun drastis hingga 60%. Ini menyebabkan mata kering dan merah.',
    },
    {
      'question': 'Apa efek buruk jika sering main HP di ruangan gelap gulita?',
      'options': [
        'Mata silau dan pupil bekerja terlalu keras',
        'Mata menjadi rabun jauh (Miopia)',
        'Mata menjadi buta warna',
        'Layar HP jadi cepat rusak'
      ],
      'correctIndex': 0,
      'explanation': 'Kontras tinggi antara layar terang dan ruangan gelap memaksa otot pupil terus beradaptasi, menyebabkan ketegangan mata (Eye Strain).',
    },
  ];

  void submitAnswer(int index) {
    if (isAnswerRevealed.value) return; // Mencegah double tap

    selectedAnswer.value = index;
    isAnswerRevealed.value = true;

    final isCorrect = index == questions[currentQuestionIndex.value]['correctIndex'];
    if (isCorrect) {
      score.value += 1;
    }
  }

  void nextQuestion() {
    if (currentQuestionIndex.value < questions.length - 1) {
      currentQuestionIndex.value++;
      selectedAnswer.value = -1;
      isAnswerRevealed.value = false;
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    isQuizFinished.value = true;
    
    // Berikan reward berdasarkan skor
    // 1 Soal benar = 20 XP
    final xpGained = score.value * 20;
    if (xpGained > 0) {
      _rewardService.addXp(xpGained);
    }
  }

  void resetQuiz() {
    currentQuestionIndex.value = 0;
    score.value = 0;
    isQuizFinished.value = false;
    selectedAnswer.value = -1;
    isAnswerRevealed.value = false;
  }
}
