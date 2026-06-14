import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/presentation/modules/play/controllers/play_controller.dart';
import 'package:visionsafe/app/presentation/modules/play/views/play_view.dart';
import 'package:visionsafe/app/presentation/modules/play/views/widgets/play_card.dart';

void main() {
  late PlayController controller;

  setUp(() {
    controller = PlayController();
    Get.put<PlayController>(controller);
  });

  tearDown(() {
    Get.reset();
  });

  testWidgets('PlayView renders game grid cards and navigates on tap', (WidgetTester tester) async {
    await tester.pumpWidget(GetMaterialApp(
      initialRoute: '/play',
      getPages: [
        GetPage(name: '/play', page: () => const PlayView()),
        GetPage(name: '/eye-exercise', page: () => const Scaffold(body: Text('Eye Exercise Screen'))),
      ],
    ));

    // 1. Verify Grid header and card titles are displayed
    expect(find.text('DUNIA BERMAIN'), findsOneWidget);
    expect(find.text('PILIH PETUALANGANMU'), findsOneWidget);
    
    expect(find.text('SENAM MATA'), findsOneWidget);
    expect(find.text('KUIS SEHAT'), findsOneWidget);
    expect(find.text('CARI VIZO'), findsOneWidget);
    expect(find.text('TIPS SERU'), findsOneWidget);

    expect(find.byType(PlayCard), findsNWidgets(4));

    // 2. Tap on "Senam Mata" to trigger navigation
    await tester.tap(find.text('SENAM MATA'));
    await tester.pumpAndSettle();

    // 3. Verify route navigated to Eye Exercise screen
    expect(find.text('Eye Exercise Screen'), findsOneWidget);
  });
}
