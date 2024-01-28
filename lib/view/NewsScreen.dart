import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newsapp/service/NewsService.dart';

import '../controller/NewsController.dart';
import '../model/NewsArticle.dart';

class NewsScreen extends StatelessWidget {
  final NewsController newsController =
  Get.put(NewsController(NewsService("9b206d76ba714156bf43893b437a23c1")));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
      ),
      body: Obx(
            () {
          if (newsController.news.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return _buildNewsList(newsController.news );
          }
        },
      ),
    );
  }

  Widget _buildNewsList(List<NewsArticle> articles) {
    final validArticles = articles.where((article) => article.imageUrl.isNotEmpty).toList();

    return ListView.builder(
      itemCount: validArticles.length,
      itemBuilder: (context, index) {
        final article = validArticles[index];
        return ListTile(
          leading: Image.network(article.imageUrl),
          title: Text(article.title),
          subtitle: Text(article.description),
        );
      },
    );
  }

}