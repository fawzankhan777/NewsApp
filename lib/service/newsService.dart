import 'dart:convert';

import 'package:http/http.dart' as http;

import '../model/NewsArticle.dart';

class NewsService {

  final String apiKey;
  NewsService(this.apiKey);

  Future<List<NewsArticle>> getNews() async {
    final response = await http.get(
      Uri.parse(
          'https://newsapi.org/v2/top-headlines?country=us&apiKey=$apiKey'),
    );

    if (response.statusCode == 200) {
      print(response.body);
      final parsedData = json.decode(response.body);
      final List<NewsArticle> articles = List.from(parsedData['articles'])
          .map((article) => NewsArticle.fromJson(article))
          .toList();
      return articles;
    } else {
      throw Exception('Failed to load news');
    }
  }

}