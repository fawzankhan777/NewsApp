import 'package:flutter/material.dart';
import 'package:newsapp/bookmark/bookmark_screen.dart';
import 'package:provider/provider.dart';
import 'news_detail_screen.dart';
import 'news_provider.dart';
import 'sort.dart'; // Import the SortScreen
import 'package:intl/intl.dart';
import 'sort.dart'; // Import the SortScreen
import 'saved_searches_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              _showSearchDialog(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SavedSearchesScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Custom Top Bar
          Container(
            color: Colors.lightBlue[50],
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      _showCategoryDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text('Add Category'),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      _showCategoryPopup(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text('Category'),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      _showSortPopup(context);
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text('Sort by'),
                  ),
                  const SizedBox(width: 10.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => BookmarkScreen()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    child: const Text('Bookmarks'),
                  ),

                ],
              ),
            ),
          ),
          Expanded(
            child: Consumer<NewsProvider>(
              builder: (context, newsProvider, _) {
                return ListView.builder(
                  itemCount: newsProvider.news.length,
                  itemBuilder: (context, index) {
                    final news = newsProvider.news[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.all(8),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Image.network(
                                news.imageUrl ?? 'assets/no_image_placeholder.png',
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                              ListTile(
                                title: Text(news.title),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Author: ${news.author ?? 'Unknown'}',
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    Text(
                                      'Date: ${_formatDate(news.date)}',
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(news.description),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => NewsDetailScreen(news: news),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          // Add the bookmark icon here
                          Positioned(
                            bottom: 8.0,
                            right: 8.0,
                            child: IconButton(
                              icon: Icon(
                                newsProvider.isBookmarked(news) ? Icons.bookmark : Icons.bookmark_border,
                                color: newsProvider.isBookmarked(news) ? Colors.blue : null,
                              ),
                              onPressed: () {
                                // Toggle bookmark status
                                newsProvider.toggleBookmark(news);
                              },
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Provider.of<NewsProvider>(context, listen: false).loadPreviousPage();
                  },
                  child: const Text('Previous Page'),
                ),
                const SizedBox(width: 16.0),
                Consumer<NewsProvider>(
                  builder: (context, newsProvider, _) {
                    return Text('Page ${newsProvider.currentPage}');
                  },
                ),
                const SizedBox(width: 16.0),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<NewsProvider>(context, listen: false).loadNextPage();
                  },
                  child: const Text('Next Page'),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.only(right: 5, bottom: 75), // Adjust the margins as needed
        child: FloatingActionButton(
          onPressed: () {
            Provider.of<NewsProvider>(context, listen: false).fetchNewsByCategory('General');
          },
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat.yMMMMd().add_jm().format(date);
  }





  Widget _buildCategoryButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        _showCategoryPopup(context);
      },
      child: const Text('Select Category'),
    );
  }

  void _showCategoryPopup(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);

    // Ensure "Search Results" is added only if it doesn't exist in _additionalCategories
    if (!newsProvider.additionalCategories.contains('Search Results')) {
      newsProvider.additionalCategories.add('Search Results');
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        // Remove duplicates from the list
        List<String> uniqueCategories = newsProvider.additionalCategories.toSet().toList();

        return AlertDialog(
          title: const Text('Select Category'),
          content: DropdownButton<String>(
            value: newsProvider.currentCategory,
            onChanged: (String? newValue) {
              // Fetch news for the selected category
              newsProvider.fetchNewsByCategory(newValue ?? 'General');
              Navigator.of(context).pop(); // Close the popup after selecting a category
            },
            items: uniqueCategories
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            })
                .toList(),
          ),
        );
      },
    );
  }



  void _showCategoryDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _newCategoryController = TextEditingController();

        return AlertDialog(
          title: const Text('Add New Category'),
          content: TextField(
            controller: _newCategoryController,
            decoration: const InputDecoration(labelText: 'Category Name'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final String newCategory = _newCategoryController.text.trim();
                if (newCategory.isNotEmpty) {
                  Provider.of<NewsProvider>(context, listen: false).addCategory(newCategory);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }

  void _showSearchDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final TextEditingController _searchController = TextEditingController();

        return AlertDialog(
          title: const Text('Search News'),
          content: TextField(
            controller: _searchController,
            decoration: const InputDecoration(labelText: 'Enter search keyword'),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final String searchKeyword = _searchController.text.trim();
                if (searchKeyword.isNotEmpty) {
                  Provider.of<NewsProvider>(context, listen: false).fetchNewsBySearch(searchKeyword);
                  Navigator.of(context).pop();
                }
              },
              child: const Text('Search'),
            ),
          ],
        );
      },
    );
  }
}

void _showSortPopup(BuildContext context) {
  final newsProvider = Provider.of<NewsProvider>(context, listen: false);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Sort By'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildSortOptionCheckbox(context, SortOption.latest),
            _buildSortOptionCheckbox(context, SortOption.moreThan7Days),
            _buildSortOptionCheckbox(context, SortOption.oneMonthAgo),
            _buildSortOptionCheckbox(context, SortOption.nameAZ),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              // Implement sorting logic based on selected options
              _sortNews(context);
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}

Widget _buildSortOptionCheckbox(BuildContext context, SortOption option) {
  final newsProvider = Provider.of<NewsProvider>(context);
  final bool isSelected = newsProvider.isSortOptionSelected(option);

  return CheckboxListTile(
    title: Text(_getSortOptionText(option)),
    value: isSelected,
    onChanged: (bool? selected) {
      if (selected != null) {
        // Set the selected sorting option
        newsProvider.setSortOption(option, selected);
      }
    },
  );
}

String _getSortOptionText(SortOption option) {
  switch (option) {
    case SortOption.latest:
      return 'Latest';
    case SortOption.moreThan7Days:
      return 'More than 7 Days Ago';
    case SortOption.oneMonthAgo:
      return 'One Month Ago';
    case SortOption.nameAZ:
      return 'Name (A-Z)';
  }
}

void _sortNews(BuildContext context) {
  final newsProvider = Provider.of<NewsProvider>(context, listen: false);

  // Retrieve selected sort options
  final selectedOptions = newsProvider.selectedSortOptions;

  // Implement sorting logic based on selected options
  if (selectedOptions.contains(SortOption.latest)) {
    // Fetch news sorted by latest
    newsProvider.fetchNewsByLatest('latest');
  } else {
    // If "Latest" is not selected, you can handle other sorting options here
    // For now, let's just print the selected options
    print('Sort by: $selectedOptions');
  }
}



