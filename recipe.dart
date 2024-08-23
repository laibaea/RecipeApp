class Recipe {
  final String id;
  final String title;
  final String imageUrl;

  Recipe({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      id: json['id'] ?? 'Unknown ID',
      title: json['title'] ?? 'Untitled Recipe',
      imageUrl: json['imageUrl'] ?? 'https://example.com/default_image.png',
    );
  }
}
