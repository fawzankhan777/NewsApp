class NewsModel {
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final String author; // New property for author
  final DateTime date; // New property for date

  NewsModel({
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.author,
    required this.date,
  });
}
