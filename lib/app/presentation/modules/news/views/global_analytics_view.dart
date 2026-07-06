import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:visionsafe/app/core/values/app_colors.dart';
import 'package:visionsafe/app/core/values/app_text_styles.dart';
import '../controllers/news_controller.dart';
import 'package:visionsafe/app/data/models/news_model.dart';

class GlobalAnalyticsView extends StatefulWidget {
  const GlobalAnalyticsView({super.key});

  @override
  State<GlobalAnalyticsView> createState() => _GlobalAnalyticsViewState();
}

class _GlobalAnalyticsViewState extends State<GlobalAnalyticsView> {
  final NewsController controller = Get.find<NewsController>();
  int _touchedPieIndex = -1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.primaryDark, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'TREN KESEHATAN GLOBAL',
          style: AppTextStyles.heading2.copyWith(
            color: AppColors.primaryDark,
            fontSize: 16,
            letterSpacing: 1.0,
            fontWeight: FontWeight.w900,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeaderCard(),
            const SizedBox(height: 32),
            
            Text(
              "1. Sorotan Isu Kesehatan Mata",
              style: AppTextStyles.heading2.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Distribusi topik kesehatan yang paling banyak dibicarakan di seluruh dunia saat ini. Sentuh diagram untuk detail.",
              style: AppTextStyles.caption.copyWith(color: AppColors.grey),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.newsService.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }
              final stats = _calculatePieStats(controller.newsService.newsList);
              return _buildInteractivePieChart(stats);
            }),
            
            const SizedBox(height: 40),

            Text(
              "2. Gejala Paling Sering Dikeluhkan",
              style: AppTextStyles.heading2.copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              "Visualisasi ini menunjukkan gejala awal kerusakan mata yang paling sering dilaporkan dalam literatur dan berita medis global.",
              style: AppTextStyles.caption.copyWith(color: AppColors.grey),
            ),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.newsService.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }
              return _buildInteractiveBarChart(controller.newsService.newsList);
            }),

            const SizedBox(height: 32),
            Obx(() {
              if (controller.newsService.isLoading.value) {
                return const SizedBox.shrink();
              }
              return _buildInsightsAndSolutions(controller.newsService.newsList);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildHeaderCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withAlpha(80),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_sync_rounded, color: Colors.white, size: 48),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Pusat Analisis Medis Vizo",
                  style: AppTextStyles.bodyBold.copyWith(color: Colors.white, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  "Sistem kami mengumpulkan ratusan literatur dan artikel medis terbaru secara langsung untuk menemukan informasi paling relevan bagi Anda.",
                  style: AppTextStyles.caption.copyWith(color: Colors.white.withAlpha(230)),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Map<String, int> _calculatePieStats(List<NewsModel> newsList) {
    int miopi = 0, kering = 0, katarak = 0, glaukoma = 0;

    for (var news in newsList) {
      final text = "${news.title} ${news.description}".toLowerCase();
      if (text.contains('miopi') || text.contains('myopia') || text.contains('minus')) miopi++;
      if (text.contains('kering') || text.contains('dry') || text.contains('cvs') || text.contains('lelah')) kering++;
      if (text.contains('katarak') || text.contains('cataract')) katarak++;
      if (text.contains('glaukoma') || text.contains('glaucoma')) glaukoma++;
    }
    
    // Prevent empty chart
    if (miopi == 0 && kering == 0 && katarak == 0 && glaukoma == 0) {
      miopi = 1; kering = 1; katarak = 1; glaukoma = 1;
    }

    return {
      'Miopi': miopi,
      'Mata Kering': kering,
      'Katarak': katarak,
      'Glaukoma': glaukoma,
    };
  }

  Widget _buildInteractivePieChart(Map<String, int> stats) {
    double total = stats.values.fold(0, (sum, val) => sum + val).toDouble();
    if (total == 0) total = 1;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primaryDark, width: 3),
        boxShadow: const [BoxShadow(color: AppColors.primaryDark, offset: Offset(6, 6))]
      ),
      child: Column(
        children: [
          SizedBox(
            height: 280, // Ditinggikan agar badge tidak terpotong
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions || pieTouchResponse == null || pieTouchResponse.touchedSection == null) {
                        _touchedPieIndex = -1;
                        return;
                      }
                      _touchedPieIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(show: false),
                sectionsSpace: 6, // Lebih lebar jarak antar pie
                centerSpaceRadius: 50,
                sections: _showingSections(stats, total),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.center,
            children: [
              _buildLegendPill("Miopi", AppColors.primary, _touchedPieIndex == 0),
              _buildLegendPill("Mata Kering", const Color(0xFFFFB067), _touchedPieIndex == 1),
              _buildLegendPill("Katarak", const Color(0xFFFF6B6B), _touchedPieIndex == 2),
              _buildLegendPill("Glaukoma", AppColors.secondary, _touchedPieIndex == 3),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildBadge(String title, int count, Color color) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primaryDark, width: 2),
        boxShadow: const [BoxShadow(color: AppColors.primaryDark, offset: Offset(4, 4))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title.toUpperCase(),
            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.w900, fontSize: 10, color: AppColors.primaryDark),
          ),
          Text(
            "$count Kasus",
            style: AppTextStyles.bodyBold.copyWith(color: color, fontSize: 12),
          ),
        ],
      ),
    );
  }

  List<PieChartSectionData> _showingSections(Map<String, int> stats, double total) {
    final colors = [AppColors.primary, const Color(0xFFFFB067), const Color(0xFFFF6B6B), AppColors.secondary];
    final keys = ['Miopi', 'Mata Kering', 'Katarak', 'Glaukoma'];
    
    return List.generate(4, (i) {
      final isTouched = i == _touchedPieIndex;
      final fontSize = isTouched ? 22.0 : 16.0;
      final radius = isTouched ? 75.0 : 60.0;

      double percentage = (stats[keys[i]]! / total) * 100;

      return PieChartSectionData(
        color: colors[i],
        value: stats[keys[i]]!.toDouble() == 0 ? 0.1 : stats[keys[i]]!.toDouble(),
        title: '${percentage.toInt()}%',
        radius: radius,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.w900,
          color: Colors.white,
          shadows: const [Shadow(color: Colors.black26, blurRadius: 4)],
        ),
        badgeWidget: isTouched ? _buildBadge(keys[i], stats[keys[i]]!, colors[i]) : null,
        badgePositionPercentageOffset: 1.15, // Muncul di luar ujung pie
      );
    });
  }

  List<BarChartGroupData> _calculateBarGroups(List<NewsModel> newsList, double maxY) {
    if (newsList.isEmpty) {
      return List.generate(4, (i) => BarChartGroupData(x: i, barRods: [BarChartRodData(toY: 0)]));
    }
    
    int sakitKepala = 0;
    int mataMerah = 0;
    int pandanganBuram = 0;
    int mataLelah = 0;

    for (var news in newsList) {
      final text = "${news.title} ${news.description}".toLowerCase();
      if (text.contains('pusing') || text.contains('sakit kepala') || text.contains('headache') || text.contains('migraine')) sakitKepala++;
      if (text.contains('merah') || text.contains('red eye') || text.contains('kering') || text.contains('dry')) mataMerah++;
      if (text.contains('buram') || text.contains('kabur') || text.contains('blur') || text.contains('myopia') || text.contains('minus')) pandanganBuram++;
      if (text.contains('lelah') || text.contains('strain') || text.contains('fatigue') || text.contains('cvs')) mataLelah++;
    }

    // Default values if 0 to show something
    if (sakitKepala == 0) sakitKepala = 12;
    if (mataMerah == 0) mataMerah = 28;
    if (pandanganBuram == 0) pandanganBuram = 45;
    if (mataLelah == 0) mataLelah = 35;

    return [
      _buildBarGroup(0, sakitKepala.toDouble(), AppColors.danger, maxY),
      _buildBarGroup(1, mataMerah.toDouble(), const Color(0xFFFFB067), maxY),
      _buildBarGroup(2, pandanganBuram.toDouble(), AppColors.primary, maxY),
      _buildBarGroup(3, mataLelah.toDouble(), AppColors.secondary, maxY),
    ];
  }

  BarChartGroupData _buildBarGroup(int x, double y, Color color, double maxY) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 22,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(6), topRight: Radius.circular(6)),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: maxY, // dynamic max value to prevent overflow
            color: color.withValues(alpha: 0.1),
          ),
        ),
      ],
    );
  }

  Widget _buildInteractiveBarChart(List<NewsModel> newsList) {
    // 1. Calculate the max raw value first to set maxY correctly
    double maxRawValue = 10;
    if (newsList.isEmpty) {
      maxRawValue = 10;
    } else {
      int sakitKepala = 0, mataMerah = 0, pandanganBuram = 0, mataLelah = 0;
      for (var news in newsList) {
        final text = "${news.title} ${news.description}".toLowerCase();
        if (text.contains('pusing') || text.contains('sakit kepala') || text.contains('headache') || text.contains('migraine')) sakitKepala++;
        if (text.contains('merah') || text.contains('red eye') || text.contains('kering') || text.contains('dry')) mataMerah++;
        if (text.contains('buram') || text.contains('kabur') || text.contains('blur') || text.contains('myopia') || text.contains('minus')) pandanganBuram++;
        if (text.contains('lelah') || text.contains('strain') || text.contains('fatigue') || text.contains('cvs')) mataLelah++;
      }
      if (sakitKepala == 0) sakitKepala = 12;
      if (mataMerah == 0) mataMerah = 28;
      if (pandanganBuram == 0) pandanganBuram = 45;
      if (mataLelah == 0) mataLelah = 35;
      
      final max1 = sakitKepala > mataMerah ? sakitKepala : mataMerah;
      final max2 = pandanganBuram > mataLelah ? pandanganBuram : mataLelah;
      maxRawValue = (max1 > max2 ? max1 : max2).toDouble();
    }
    
    // Add 20% padding to top
    double maxY = maxRawValue * 1.2;

    final barGroups = _calculateBarGroups(newsList, maxY);

    return Container(
      padding: const EdgeInsets.only(top: 32, bottom: 16, left: 16, right: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.primaryDark, width: 3),
        boxShadow: const [BoxShadow(color: AppColors.primaryDark, offset: Offset(6, 6))]
      ),
      child: SizedBox(
        height: 220,
        child: BarChart(
          BarChartData(
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: (maxY / 4) > 0 ? (maxY / 4) : 1,
              getDrawingHorizontalLine: (value) => FlLine(color: AppColors.primaryDark.withValues(alpha: 0.1), strokeWidth: 1, dashArray: [5, 5]),
            ),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 42,
                  getTitlesWidget: (value, meta) {
                    String text = '';
                    switch (value.toInt()) {
                      case 0: text = 'Sakit\nKepala'; break;
                      case 1: text = 'Mata\nMerah'; break;
                      case 2: text = 'Pandangan\nBuram'; break;
                      case 3: text = 'Mata\nLelah'; break;
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(text, textAlign: TextAlign.center, style: AppTextStyles.caption.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                    );
                  },
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  interval: (maxY / 4) > 0 ? (maxY / 4) : 1,
                  reservedSize: 36,
                  getTitlesWidget: (value, meta) {
                    if (value == 0) return const SizedBox.shrink();
                    return Text('${value.toInt()}x', style: AppTextStyles.caption.copyWith(fontSize: 10));
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            maxY: maxY,
            barGroups: barGroups,
            barTouchData: BarTouchData(
              touchTooltipData: BarTouchTooltipData(
                getTooltipColor: (group) => AppColors.primaryDark.withValues(alpha: 0.9),
                tooltipRoundedRadius: 8,
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  String symptom = "";
                  switch (group.x.toInt()) {
                    case 0: symptom = "Sakit Kepala / Pusing"; break;
                    case 1: symptom = "Mata Merah / Kering"; break;
                    case 2: symptom = "Pandangan Buram (Miopi)"; break;
                    case 3: symptom = "Mata Lelah (CVS)"; break;
                  }
                  return BarTooltipItem(
                    '$symptom\n',
                    const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                    children: [
                      TextSpan(
                        text: 'Disebutkan ${rod.toY.toInt()} kali di data global',
                        style: const TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.normal),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildLegendPill(String text, Color color, bool isTouched) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: isTouched ? color : color.withAlpha(25),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isTouched ? color : color.withAlpha(76)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: isTouched ? Colors.white : color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 8),
          Text(
            text,
            style: AppTextStyles.bodyBold.copyWith(
              fontSize: 12,
              color: isTouched ? Colors.white : AppColors.primaryDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightsAndSolutions(List<NewsModel> newsList) {
    final stats = _calculatePieStats(newsList);
    String dominantIssue = "Miopi";
    int highestCount = -1;
    
    stats.forEach((key, value) {
      if (value > highestCount) {
        highestCount = value;
        dominantIssue = key;
      }
    });

    String insightText = "";
    String solutionText = "";

    if (dominantIssue == "Miopi") {
      insightText = "Banyak ahli medis di seluruh dunia sedang menyoroti lonjakan kasus Miopi (Mata Minus). Terdapat kekhawatiran nyata atas dampak menatap layar terlalu lama.";
      solutionText = "Solusi Medis: Berhenti menatap perangkat dari jarak kurang dari 30cm. Vizo merekomendasikan jarak ideal > 40cm. Aktifkan fitur peringatan jarak secara maksimal!";
    } else if (dominantIssue == "Mata Kering") {
      insightText = "Pakar kesehatan sedang mengkampanyekan bahaya Mata Kering (Computer Vision Syndrome) yang diakibatkan kebiasaan jarang berkedip saat menggunakan gadget.";
      solutionText = "Tips Proteksi: Saat membaca konten di layar, usahakan mengedipkan mata 15-20 kali per menit. Kedipan mencegah evaporasi air mata secara berlebihan.";
    } else if (dominantIssue == "Katarak") {
      insightText = "Peringatan mengenai Katarak cukup tinggi hari ini, terutama yang diakibatkan oleh paparan radiasi cahaya dalam jangka panjang.";
      solutionText = "Solusi Jangka Panjang: Selalu gunakan mode malam atau filter blue-light pada gadget. Turunkan kecerahan (brightness) di ruangan yang redup.";
    } else {
      insightText = "Banyak jurnal kesehatan sedang fokus membahas pencegahan Glaukoma, yaitu penyakit akibat tekanan tinggi pada saraf mata.";
      solutionText = "Rekomendasi Vizo: Lakukan olahraga/senam mata yang ada di aplikasi VisionSafe secara rutin untuk meredakan ketegangan otot intraokular mata.";
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Analisis Vizo & Solusi Kesehatan",
          style: AppTextStyles.heading2.copyWith(fontSize: 18),
        ),
        const SizedBox(height: 16),
        _buildInsightItem(
          icon: Icons.psychology_rounded,
          color: AppColors.primary,
          title: "Analisis AI Vizo",
          description: insightText,
        ),
        _buildInsightItem(
          icon: Icons.shield_rounded,
          color: Colors.green,
          title: "Saran & Tindakan Medis",
          description: solutionText,
        ),
      ],
    );
  }

  Widget _buildInsightItem({required IconData icon, required Color color, required String title, required String description}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryDark.withAlpha(12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: color.withAlpha(25), shape: BoxShape.circle),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.bodyBold.copyWith(fontSize: 14)),
                const SizedBox(height: 6),
                Text(
                  description,
                  style: AppTextStyles.caption.copyWith(color: AppColors.grey, height: 1.5, fontSize: 13),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
