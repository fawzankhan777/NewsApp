import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:newsapp/bookmark/bookmark_model.dart';
import 'dart:convert';

import 'news_model.dart';

enum SortOption {
  latest,
  moreThan7Days,
  oneMonthAgo,
  nameAZ,
}

class NewsProvider extends ChangeNotifier {
  List<NewsModel> _news = [];
  int _currentPage = 1;
  final int _pageSize = 10;
  List<String> _additionalCategories = ['General', 'Space', 'Technology'];

  List<NewsModel> get news => _news;
  int get currentPage => _currentPage;
  List<String> get additionalCategories => _additionalCategories;

  String _currentCategory = 'General';
  String get currentCategory => _currentCategory;

  List<SortOption> _selectedSortOptions = [];

  List<SortOption> get selectedSortOptions => _selectedSortOptions;
  List<String> _savedSearches = [];
  List<String> _searchHistory = [];
  List<String> get savedSearches => _savedSearches;
  List<String> get searchHistory => _searchHistory;
  List<BookmarkModel> _bookmarks = [];

  List<BookmarkModel> get bookmarks => _bookmarks;

  bool isBookmarked(NewsModel news) {
    return _bookmarks.any((bookmark) => bookmark.url == news.url);
  }
  void toggleBookmark(NewsModel news) {
    if (isBookmarked(news)) {
      // Remove from bookmarks
      _bookmarks.removeWhere((bookmark) => bookmark.url == news.url);
    } else {
      // Add to bookmarks
      _bookmarks.add(BookmarkModel(
        title: news.title,
        description: news.description,
        url: news.url,
        imageUrl: news.imageUrl,
      ));
    }

    notifyListeners();
  }


  void addSavedSearch(String search) {
    if (!_savedSearches.contains(search)) {
      _savedSearches.add(search);
      notifyListeners();
    }
  }
  void saveSearch(String searchKeyword) {
    if (!_savedSearches.contains(searchKeyword)) {
      _savedSearches.add(searchKeyword);
      notifyListeners(); // Notify listeners that the data has changed
    }
  }
  void removeSavedSearch(String search) {
    _savedSearches.remove(search);
    notifyListeners();
  }
  void addToSearchHistory(String keyword) {
    _searchHistory.insert(0, keyword);
    // You may want to limit the size of the search history to a certain number, e.g., 10
    if (_searchHistory.length > 10) {
      _searchHistory.removeLast();
    }
    notifyListeners();
  }

  bool isSortOptionSelected(SortOption option) {
    return _selectedSortOptions.contains(option);
  }

  void setSortOption(SortOption option, bool selected) {
    if (selected) {
      _selectedSortOptions.add(option);
    } else {
      _selectedSortOptions.remove(option);
    }
    notifyListeners();
  }

  Future<void> fetchNewsByCategory(String category) async {
    const apiKey = '3a7dcf53c2e648d9bbfe0172ae2b9472';
    final apiUrl =
        'https://newsapi.org/v2/everything?q=$category&apiKey=$apiKey&page=$_currentPage&pageSize=$_pageSize';

    await _fetchNews(apiUrl, category);
  }

  Future<void> fetchNewsBySearch(String keyword) async {
    const apiKey = '3a7dcf53c2e648d9bbfe0172ae2b9472';
    final apiUrl =
        'https://newsapi.org/v2/everything?q=$keyword&apiKey=$apiKey&page=$_currentPage&pageSize=$_pageSize';

    await _fetchNews(apiUrl, 'Search Results');
  }

  Future<void> fetchNewsByLatest(String keyword) async {
    const apiKey = '3a7dcf53c2e648d9bbfe0172ae2b9472';
    final apiUrl =
        'https://newsapi.org/v2/top-headlines?sortBy=publishedAt&page=$_currentPage&pageSize=$_pageSize';

    await _fetchNews(apiUrl, 'Search Results');
  }



  Future<void> fetchNewsByWeek() async {
    const apiUrl =
        'https://newsapi.org/v2/everything?q=your_query&from=2023-01-01&to=2023-01-07&sortBy=publishedAt&apiKey=3a7dcf53c2e648d9bbfe0172ae2b9472';

    await _fetchNews(apiUrl, 'Search Results');
  }



  Future<void> _fetchNews(String apiUrl, String category, {String? keyword}) async {
    try {
      final response = await http.get(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body)['articles'];

        if (_currentPage == 1) {
          _news = data.map((article) => NewsModel(
            title: article['title'] ?? 'No Title',
            description: article['description'] ?? 'No Description',
            url: article['url'] ?? 'No URL',
            imageUrl: article['urlToImage'] ?? 'No Image',
            author: article['author'] ?? 'Unknown Author',
            date: DateTime.parse(article['publishedAt'] ?? DateTime.now().toString()),
          )).toList();

          // Add the keyword to the search history
          if (keyword != null && !_searchHistory.contains(keyword)) {
            _searchHistory.add(keyword);
          }
        } else {
          _news += data.map((article) => NewsModel(
            title: article['title'] ?? 'No Title',
            description: article['description'] ?? 'No Description',
            url: article['url'] ?? 'No URL',
            imageUrl: article['urlToImage'] ?? 'No Image',
            author: article['author'] ?? 'Unknown Author',
            date: DateTime.parse(article['publishedAt'] ?? DateTime.now().toString()),
          )).toList();

          if (_news.length > _pageSize) {
            _news = _news.sublist(_news.length - _pageSize);
          }
        }

        _currentCategory = category;
        print('Fetched ${data.length} articles for category: $category, page: $_currentPage');

        notifyListeners();
      } else {
        print('Failed to load news: ${response.statusCode}');
        throw Exception('Failed to load news: ${response.statusCode}');
      }
    } catch (error) {
      print('Error: $error');
      throw error.toString();
    }
  }



  void loadMoreArticles() {
    _currentPage++;
    fetchNewsByCategory(_currentCategory);
  }

  void loadPreviousPage() {
    if (_currentPage > 1) {
      _currentPage--;
      fetchNewsByCategory(_currentCategory);
    }
  }

  void loadNextPage() {
    _currentPage++;
    fetchNewsByCategory(_currentCategory);
  }

  void addCategory(String category) {
    _additionalCategories.add(category);
    notifyListeners();
  }
}
