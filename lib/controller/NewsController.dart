import 'package:get/get.dart';

import '../model/NewsArticle.dart';
import '../service/NewsService.dart';

class NewsController extends GetxController {
  final NewsService newsService;

  NewsController(this.newsService);

  final RxList<NewsArticle> news = <NewsArticle>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchNews();
  }

  void fetchNews() async {
    try {
      news.assignAll(await newsService.getNews());
    } catch (e) {
      print('Error fetching news: $e');
    }
  }
}