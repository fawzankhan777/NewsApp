import 'package:flutter/material.dart';
import 'package:newsapp/news_provider.dart';
import 'package:provider/provider.dart';

class SavedSearchesScreen extends StatelessWidget {
  const SavedSearchesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context);
    final searchHistory = newsProvider.searchHistory;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Saved Searches'),
      ),
      body: ListView.builder(
        itemCount: searchHistory.length,
        itemBuilder: (context, index) {
          final keyword = searchHistory[index];
          return ListTile(
            title: Text(keyword),
            onTap: () {
              // Handle tapping on a saved search item, e.g., perform a new search
              // with the selected keyword
            },
          );
        },
      ),
    );
  }
}

