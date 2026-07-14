import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:visionsafe/app/presentation/modules/stats/controllers/stats_controller.dart';
import 'package:get/get.dart';

class PdfExportService extends GetxService {
  Future<void> generateAndPrintReport(StatsController stats) async {
    final pdf = pw.Document(
      title: 'Laporan Kesehatan Mata - VisionSafe',
      author: 'EyeGuardian',
    );
    
    final targetName = stats.targetName ?? "Pengguna";
    final dateStr = "${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}";

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return pw.Padding(
            padding: const pw.EdgeInsets.all(24),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Header(
                  level: 0,
                  text: 'VISIONSAFE MEDICAL REPORT',
                  textStyle: pw.TextStyle(
                    fontSize: 28,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.blue900,
                  ),
                ),
                pw.SizedBox(height: 20),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text('Nama Pasien: $targetName', style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold)),
                    pw.Text('Tanggal Cetak: $dateStr', style: const pw.TextStyle(fontSize: 14)),
                  ],
                ),
                pw.Divider(thickness: 2),
                pw.SizedBox(height: 20),
                
                // Ringkasan Utama
                pw.Text('1. RINGKASAN KESEHATAN (HARI INI)', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                pw.SizedBox(height: 10),
                pw.TableHelper.fromTextArray(
                  context: context,
                  data: <List<String>>[
                    ['Indikator', 'Nilai', 'Status'],
                    ['Health Score', '${stats.healthScore.value}%', stats.healthScore.value >= 80 ? 'SANGAT BAIK' : 'PERLU PERHATIAN'],
                    ['Rata-rata Jarak', '${stats.averageDistance.value.toStringAsFixed(1)} cm', stats.averageDistance.value >= 30 ? 'AMAN' : 'BERBAHAYA'],
                    ['Total Pelanggaran', '${stats.totalViolationsCount.value} kali', stats.totalViolationsCount.value < 10 ? 'AMAN' : 'TINGGI'],
                  ],
                  headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                  headerDecoration: const pw.BoxDecoration(color: PdfColors.blue900),
                  cellHeight: 30,
                  cellAlignments: {
                    0: pw.Alignment.centerLeft,
                    1: pw.Alignment.center,
                    2: pw.Alignment.center,
                  },
                ),
                
                pw.SizedBox(height: 30),
                
                // Keseimbangan Waktu
                pw.Text('2. KESEIMBANGAN WAKTU LAYAR', style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold, color: PdfColors.blue800)),
                pw.SizedBox(height: 10),
                pw.Text('Screen Time Aktif: ${stats.screenTimeHours.value.toStringAsFixed(1)} Jam', style: const pw.TextStyle(fontSize: 14)),
                pw.Text('Estimasi Waktu Istirahat: ${stats.restTimeHours.value.toStringAsFixed(1)} Jam', style: const pw.TextStyle(fontSize: 14)),
                
                pw.SizedBox(height: 30),
                
                // Rekomendasi
                pw.Container(
                  padding: const pw.EdgeInsets.all(16),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.red900, width: 2),
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                    color: PdfColors.red50,
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('REKOMENDASI DOKTER / SISTEM:', style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold, color: PdfColors.red900)),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        stats.healthScore.value >= 80 
                          ? 'Kesehatan mata sangat baik. Pertahankan kebiasaan menjaga jarak lebih dari 30cm dan terapkan aturan 20-20-20.' 
                          : 'Peringatan! Waktu layar terlalu dekat. Segera hentikan aktivitas gawai, istirahatkan mata dengan melihat objek jauh (6 meter) selama 20 detik.',
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                    ]
                  )
                ),
                
                pw.Spacer(),
                pw.Divider(),
                pw.Align(
                  alignment: pw.Alignment.center,
                  child: pw.Text('Dokumen ini digenerate secara otomatis oleh Sistem VisionSafe - Capstone Project Universitas Harkat Negeri', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                ),
              ],
            ),
          );
        },
      ),
    );

    // Halaman 2+: Log Detail (Menggunakan MultiPage agar mendukung pagination otomatis jika log ribuan)
    if (stats.detailedLogs.isNotEmpty) {
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return [
              pw.Header(
                level: 1,
                text: 'LAMPIRAN: LOG PELANGGARAN DETIK',
                textStyle: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blue900,
                ),
              ),
              pw.SizedBox(height: 10),
              pw.TableHelper.fromTextArray(
                context: context,
                data: <List<String>>[
                  ['No', 'Tanggal', 'Waktu (Jam:Menit:Detik)', 'Jarak Terdeteksi'],
                  ...stats.detailedLogs.asMap().entries.map((entry) {
                    final index = entry.key + 1;
                    final log = entry.value;
                    final time = log['time'] as DateTime;
                    final distance = (log['distance'] as num).toDouble();
                    
                    final dateStr = "${time.day}-${time.month}-${time.year}";
                    final timeStr = "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}:${time.second.toString().padLeft(2, '0')}";
                    
                    return [
                      index.toString(),
                      dateStr,
                      timeStr,
                      distance <= 0.1 ? "TAMPERED / BLOCKED" : "${distance.toStringAsFixed(1)} cm"
                    ];
                  }),
                ],
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold, color: PdfColors.white),
                headerDecoration: const pw.BoxDecoration(color: PdfColors.red900),
                cellHeight: 25,
                cellAlignments: {
                  0: pw.Alignment.center,
                  1: pw.Alignment.center,
                  2: pw.Alignment.center,
                  3: pw.Alignment.center,
                },
              ),
            ];
          },
        ),
      );
    }

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'VisionSafe_Report_${targetName}_$dateStr.pdf',
    );
  }
}
