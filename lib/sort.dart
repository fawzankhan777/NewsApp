// sort.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'news_provider.dart';

class SortScreen extends StatelessWidget {
  const SortScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sort Options'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            _showSortPopup(context);
          },
          child: const Text('Sort By'),
        ),
      ),
    );
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
    // You need to update this part based on the actual logic you want to apply

    // For now, let's just print the selected options
    print('Sort by: $selectedOptions');
  }
}
