import 'package:flutter/material.dart';
import 'package:newsapp/news_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class BookmarkScreen extends StatelessWidget {
  const BookmarkScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookmarks'),
      ),
      body: ListView.builder(
        itemCount: newsProvider.bookmarks.length,
        itemBuilder: (context, index) {
          final bookmark = newsProvider.bookmarks[index];
          return GestureDetector(
            onTap: () {
              launchURL(bookmark.url);
            },
            child: ListTile(
              leading: bookmark.imageUrl != null
                  ? Image.network(
                bookmark.imageUrl!,
                width: 50,
                height: 50,
                fit: BoxFit.cover,
              )
                  : SizedBox.shrink(), // Don't show leading if imageUrl is null
              title: Text(bookmark.title),
              subtitle: Text(bookmark.description),
              // ... other details ...
            ),
          );
        },
      ),
    );
  }

  Future<void> launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
