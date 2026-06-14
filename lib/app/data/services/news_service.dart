import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';
import 'package:visionsafe/app/data/models/news_model.dart';
import 'package:visionsafe/app/data/services/rss_parser.dart';

export 'package:visionsafe/app/data/models/news_model.dart';

class NewsService extends GetxService {
  final newsList = <NewsModel>[].obs;
  final isLoading = false.obs;
  final isOffline = false.obs;
  
  final _logger = Logger();
  final _supabase = Supabase.instance.client;
  final _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 8),
    receiveTimeout: const Duration(seconds: 8),
  ));
  late Box _newsBox;
  DateTime? _lastFetchTime;

  final List<Map<String, String>> _sources = [
    {'name': 'WHO', 'url': 'https://www.who.int/feeds/entity/mediacentre/news/en/rss.xml'},
    {'name': 'CDC', 'url': 'https://www.cdc.gov/xml/syndication.rss'},
    {'name': 'NIH', 'url': 'https://newsinhealth.nih.gov/feed'},
    {'name': 'Mayo Clinic', 'url': 'https://www.mayoclinic.org/rss/all-news-and-publications'},
    {'name': 'Cleveland Clinic', 'url': 'https://health.clevelandclinic.org/feed'},
    {'name': 'Harvard Health', 'url': 'https://www.health.harvard.edu/blog/feed'},
    {'name': 'Medical News Today', 'url': 'https://www.medicalnewstoday.com/feed'},
  ];

  Future<NewsService> init() async {
    _newsBox = await Hive.openBox('news_cache');
    _loadCachedNews();
    
    // Non-blocking background fetch
    // ignore: unawaited_futures
    fetchNews();
    
    return this;
  }

  void _loadCachedNews() {
    try {
      final cached = _newsBox.get('items');
      if (cached != null && cached is List) {
        final mapped = cached
            .map((e) => NewsModel.fromMap(Map<String, dynamic>.from(e as Map)))
            .toList();
        newsList.assignAll(mapped);
        _logger.i("Berita dimuat dari cache lokal: ${newsList.length} item.");
      }
    } catch (e) {
      _logger.w("Gagal memuat berita dari cache: $e");
    }
  }

  Future<void> fetchNews({bool force = false}) async {
    // Throttling: fetch maximum once per 1 minutes unless forced
    if (!force && _lastFetchTime != null && 
        DateTime.now().difference(_lastFetchTime!) < const Duration(minutes: 1)) {
      _logger.d("Fetch berita dilewati (throttled).");
      return;
    }

    isLoading.value = true;
    final List<NewsModel> allFetched = [];
    final Set<String> titles = {};
    final Set<String> urls = {};

    // 0. Add Elite VisionSafe Fallback Articles (Hero Originals)
    final fallbackNews = [
      NewsModel(
        id: 'vs_original_1',
        title: 'Mengenal Aturan 20-20-20 untuk Kesehatan Mata',
        description: 'Setiap 20 menit menatap layar, lihatlah objek sejauh 20 kaki (6 meter) selama 20 detik. Teknik ini sangat efektif mengurangi ketegangan mata digital.',
        category: 'TIPS HERO',
        url: 'https://www.aao.org/eye-health/tips-prevention/computer-usage',
        publishedAt: DateTime.now(),
        sourceName: 'VisionSafe HQ',
      ),
      NewsModel(
        id: 'vs_original_2',
        title: 'Jarak Aman Mata: Mengapa 30cm Sangat Penting?',
        description: 'Menjaga jarak minimal 30cm dari layar membantu otot mata bekerja lebih rileks dan mencegah perkembangan miopi (mata minus) secara dini.',
        category: 'EDUKASI',
        url: 'https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6020759/',
        publishedAt: DateTime.now().subtract(const Duration(hours: 1)),
        sourceName: 'VisionSafe HQ',
      ),
      NewsModel(
        id: 'vs_original_3',
        title: 'Pentingnya Kedipan Mata Saat Menatap Layar',
        description: 'Saat serius menatap layar, frekuensi berkedip manusia turun hingga 60%. Ini menyebabkan mata kering dan iritasi. Hero, jangan lupa berkedip!',
        category: 'EDUKASI',
        url: 'https://www.healthline.com/health/eye-health/how-often-do-you-blink',
        publishedAt: DateTime.now().subtract(const Duration(hours: 2)),
        sourceName: 'VisionSafe HQ',
      ),
    ];

    for (final news in fallbackNews) {
      titles.add(news.title.toLowerCase().trim());
      urls.add(news.url.trim());
      allFetched.add(news);
    }

    // 1. Fetch from Supabase
    try {
      final response = await _supabase
          .from('news')
          .select()
          .order('created_at', ascending: false)
          .limit(20);
      
      if (response.isNotEmpty) {
        final parsed = response.map((e) => NewsModel.fromMap(Map<String, dynamic>.from(e as Map))).toList();
        for (final item in parsed) {
          if (titles.add(item.title.toLowerCase().trim()) && urls.add(item.url.trim())) {
            allFetched.add(item);
          }
        }
      }
      isOffline.value = false;
    } catch (e) {
      _logger.w("Supabase news fetch failed: $e");
      isOffline.value = true;
    }

    // 1.5 Fetch from VisionSafe Big Data Pipeline (Firebase Firestore)
    try {
  
      const projectId = 'bigdata-visionsafe';
      final firebaseUrl = 'https://firestore.googleapis.com/v1/projects/$projectId/databases/(default)/documents/visionsafe_knowledge?pageSize=1000';
      
      final res = await _dio.get(firebaseUrl);
      if (res.statusCode == 200 && res.data != null) {
        final documents = res.data['documents'] as List?;
        if (documents != null) {
          for (final doc in documents) {
            final fields = doc['fields'];
            if (fields == null) continue;
            
            final title = fields['title']?['stringValue'] ?? '';
            final url = fields['url']?['stringValue'] ?? '';
            final content = fields['full_content']?['stringValue'] ?? '';
            final source = fields['source']?['stringValue'] ?? 'VisionSafe Big Data';
            final publishedStr = fields['published_raw']?['stringValue'];
            
            final news = NewsModel(
              id: doc['name'] ?? DateTime.now().millisecondsSinceEpoch.toString(),
              title: title,
              description: content,
              category: 'BIG DATA',
              url: url,
              publishedAt: publishedStr != null ? DateTime.tryParse(publishedStr) ?? DateTime.now() : DateTime.now(),
              sourceName: source,
            );
            
            if (titles.add(news.title.toLowerCase().trim()) && urls.add(news.url.trim())) {
              allFetched.add(news);
            }
          }
        }
      }
    } catch (e) {
      _logger.w("Firebase Big Data fetch failed: $e");
    }

    // 2. Fetch from RSS Feeds in parallel with higher resilience
    final List<Future<void>> rssFutures = _sources.map((src) async {
      try {
        final res = await _dio.get(src['url']!);
        if (res.statusCode == 200 && res.data != null) {
          final parsed = RssParser.parse(res.data.toString(), src['name']!);
          for (final item in parsed) {
            if (titles.add(item.title.toLowerCase().trim()) && urls.add(item.url.trim())) {
              allFetched.add(item);
            }
          }
        }
      } catch (e) {
        // Silent fail for individual RSS sources to keep it professional
      }
    }).toList();

    await Future.wait(rssFutures);

    if (allFetched.isNotEmpty) {
      // Sort: newest first
      allFetched.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
      
      // No limit on stored list to demonstrate limitless Big Data capacity
      final finalArticles = allFetched;
      newsList.assignAll(finalArticles);

      // Save to Hive cache
      final maps = finalArticles.map((e) => e.toMap()).toList();
      await _newsBox.put('items', maps);
      
      _lastFetchTime = DateTime.now();
      isOffline.value = false;
      _logger.i("News update completed: ${newsList.length} total items.");
    }
    
    isLoading.value = false;
  }
}

