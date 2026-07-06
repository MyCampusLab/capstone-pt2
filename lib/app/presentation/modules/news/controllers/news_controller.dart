import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:visionsafe/app/data/services/news_service.dart';

class NewsController extends GetxController {
  final newsService = Get.find<NewsService>();
  final scrollController = ScrollController();

  final selectedCategory = "Semua".obs;
  final displayedArticles = <NewsModel>[].obs;
  
  // Infinite Scroll / Lazy Loading variables
  final int _pageSize = 8;
  final _currentPage = 1.obs;
  final isLoadingMore = false.obs;
  final hasMore = true.obs;

  final categories = [
    "Semua",
    "Mata",
    "Postur",
    "Layar",
    "Tidur",
    "Edukasi",
  ];

  @override
  void onInit() {
    super.onInit();
    
    // Bind scroll controller to trigger lazy loading when reaching near bottom
    scrollController.addListener(_onScroll);
    
    // Re-load articles when category changes or background service articles update
    ever(selectedCategory, (_) => _resetAndLoad());
    ever(newsService.newsList, (_) => _loadMore(isInitial: true));
    
    _loadMore(isInitial: true);
  }

  bool _isDisposed = false;

  @override
  void onClose() {
    _isDisposed = true;
    scrollController.dispose();
    super.onClose();
  }

  void _onScroll() {
    if (scrollController.position.pixels >= scrollController.position.maxScrollExtent - 150) {
      if (!isLoadingMore.value && hasMore.value && !newsService.isLoading.value) {
        _loadMore();
      }
    }
  }

  void _resetAndLoad() {
    _currentPage.value = 1;
    displayedArticles.clear();
    hasMore.value = true;
    _loadMore(isInitial: true);
  }

  /// Filters articles by selected category and appends the next page
  Future<void> _loadMore({bool isInitial = false}) async {
    if (newsService.newsList.isEmpty) {
      displayedArticles.clear();
      hasMore.value = false;
      return;
    }

    if (isInitial) {
      _currentPage.value = 1;
      isLoadingMore.value = false;
    } else {
      isLoadingMore.value = true;
      // Soft artificial delay for premium shimmers/smooth visual transitions
      await Future.delayed(const Duration(milliseconds: 400));
      if (_isDisposed) return;
    }

    final filtered = _getFilteredArticles();
    final totalAvailable = filtered.length;
    final int targetLength = _currentPage.value * _pageSize;

    if (targetLength >= totalAvailable) {
      displayedArticles.assignAll(filtered);
      hasMore.value = false;
    } else {
      displayedArticles.assignAll(filtered.sublist(0, targetLength));
      hasMore.value = true;
      _currentPage.value++;
    }

    isLoadingMore.value = false;
  }

  List<NewsModel> _getFilteredArticles() {
    final cat = selectedCategory.value;
    if (cat == "Semua") return newsService.newsList;

    final lowerCat = cat.toLowerCase();
    
    // Custom keyword matching dictionary for categorizing articles intelligently
    final Map<String, List<String>> keywordMap = {
      "mata": ["eye", "mata", "myopia", "miopi", "strain", "vision", "penglihatan", "cataract", "glaucoma", "dry eye"],
      "postur": ["posture", "postur", "duduk", "sit", "back", "spine", "ergonomic", "ergonomi"],
      "layar": ["screen", "layar", "gadget", "gawai", "device", "time", "addiction", "addict", "hp"],
      "tidur": ["sleep", "tidur", "night", "circadian", "insomnia", "melatonin"],
      "edukasi": ["tips", "exercise", "education", "edukasi", "healthy", "wellness", "habit"],
    };

    final keywords = keywordMap[lowerCat] ?? [lowerCat];

    return newsService.newsList.where((article) {
      // Check category tag match first
      if (article.category.toLowerCase() == lowerCat) return true;
      
      // Fallback: search in title or summary text
      final searchText = "${article.title} ${article.description}".toLowerCase();
      return keywords.any((kw) => searchText.contains(kw));
    }).toList();
  }

  /// Refreshes content from the network
  Future<void> refreshContent() async {
    await newsService.fetchNews(force: true);
    _resetAndLoad();
  }
}
