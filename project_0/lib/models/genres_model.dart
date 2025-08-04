// id, name, slug, games_count, image_background,games

class GenresModel {
  final int id;
  final String name;
  final String slug;
  final int gamesCount;
  final String imageBackground;
  final List<Map<String, dynamic>> games;

  GenresModel(
      {required this.id,
      required this.name,
      required this.slug,
      required this.gamesCount,
      required this.imageBackground,
      required this.games});
  
  GenresModel.fromJson(Map<String, dynamic> json)
      : id = json['id'] ?? 0,
        name = json['name'] ?? '',
        slug = json['slug'] ?? '',
        gamesCount = json['games_count'] ?? 0,
        imageBackground = json['image_background'] ?? '',
        games = List<Map<String, dynamic>>.from(json['games'] ?? []);
}
