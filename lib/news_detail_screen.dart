import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Import the intl package for date formatting
import 'news_model.dart';
import 'full_article_screen.dart'; // Import the FullArticleScreen

class NewsDetailScreen extends StatelessWidget {
  final NewsModel news;

  const NewsDetailScreen({Key? key, required this.news}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(news.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              news.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            // Display author and date information
            Text('Author: ${news.author}'),
            Text('Date: ${_formatDate(news.date)}'),
            const SizedBox(height: 8),
            Text(news.description),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Navigate to FullArticleScreen when the button is pressed
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FullArticleScreen(articleUrl: news.url),
                  ),
                );
              },
              child: const Text('View Full Article'),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat.yMMMMd().add_jm().format(date);
  }
}
