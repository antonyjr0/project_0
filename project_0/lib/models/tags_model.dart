class TagsModel {

  final int id;
  final String name;
  final int gamesCount;
  final String imageBackground;
  final List<Map<String,dynamic>> games;

  TagsModel({
    required this.id,
    required this.name,
    required this.gamesCount,
    required this.imageBackground,
    required this.games,
  });

  factory TagsModel.fromJson(Map<String, dynamic> json) {
    return TagsModel(
      id: json['id'],
      name: json['name'],
      gamesCount: json['games_count'],
      imageBackground: json['image_background'],
      games: json['games'] ?? [],
    );
  }
  
}