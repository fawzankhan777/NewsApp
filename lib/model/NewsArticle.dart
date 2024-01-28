class NewsArticle {
  final String title;
  final String description;
  final String imageUrl; // Add this line

  NewsArticle({
    required this.title,
    required this.description,
    required this.imageUrl, // Add this line
  });

  factory NewsArticle.fromJson(Map<String, dynamic>? json) {
    return NewsArticle(
      title: json?['title'] ?? '',
      description: json?['description'] ?? '',
      imageUrl: json?['urlToImage'] ?? '',
    );
  }

}