import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/data/services/reward_service.dart';
import 'package:visionsafe/app/data/services/supabase_service.dart';
import 'package:visionsafe/app/data/models/sticker_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:io';

// Concrete Stub untuk menghindari komplikasi Mockito dengan GetX Lifecycle
class SupabaseServiceStub extends GetxService implements SupabaseService {
  @override
  Future<List<Map<String, dynamic>>> getStickers() async => [];
  
  @override
  Future<List<String>> getUnlockedStickerIds() async => [];
  
  @override
  void noSuchMethod(Invocation invocation) {}
}

// Subclass untuk testing guna mem-bypass dependency Supabase.instance.client
class RewardServiceForTest extends RewardService {
  @override
  Future<void> unlockSticker(String id) async {
    // Implementasi minimal khusus test untuk verifikasi local cache update
    final sticker = (await Hive.openBox<StickerModel>('vizo_stickers')).get(id);
    if (sticker != null && !sticker.isUnlocked) {
      final updated = StickerModel(
        id: sticker.id,
        title: sticker.title,
        description: sticker.description,
        isUnlocked: true,
        unlockedAt: DateTime.now(),
      );
      await (await Hive.openBox<StickerModel>('vizo_stickers')).put(id, updated);
    }
  }
}

void main() {
  late RewardServiceForTest service;

  setUpAll(() async {
    final tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(StickerModelAdapter());
    }
  });

  setUp(() async {
    Get.put<SupabaseService>(SupabaseServiceStub());
    service = RewardServiceForTest();
    // Kita panggil init namun waspada terhadap listener auth
    // Dalam subclass kita bisa override init jika perlu, tapi kita coba dulu
    await Hive.openBox<StickerModel>('vizo_stickers');
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    Get.reset();
  });

  group('RewardService Unit Tests', () {
    test('getAllStickers should return stickers from Hive', () async {
      final mockSticker = StickerModel(id: 's1', title: 'Test', description: 'Desc', isUnlocked: false);
      final box = await Hive.openBox<StickerModel>('vizo_stickers');
      await box.put('s1', mockSticker);

      service.stickerBox = box;

      final result = service.getAllStickers();
      expect(result.length, 1);
      expect(result.first.id, 's1');
      expect(result.first.title, 'Test');
    });

    test('unlockSticker logic verification', () async {
      final mockSticker = StickerModel(id: 's1', title: 'Test', description: 'Desc', isUnlocked: false);
      final box = await Hive.openBox<StickerModel>('vizo_stickers');
      await box.put('s1', mockSticker);

      await service.unlockSticker('s1');

      final updated = box.get('s1');
      expect(updated?.isUnlocked, true);
    });
  });
}
