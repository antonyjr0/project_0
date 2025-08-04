class GameModel {

  int id;
  String name;
  String released;
  bool announced;
  String backgroundImage;
  double rating;
  List<Map<String, dynamic>> ratings;
  int ratingsCount;
  int added;
  Map<String, int> addedByStatus;
  int metacritic;
  int playtime;
  int suggestionsCount;
  String updated;
  int reviewsCount;
  List<Map<String, dynamic>> platforms;
  List<Map<String, dynamic>> parentPlatforms;
  List<Map<String, dynamic>> genres;
  List<Map<String, dynamic>> stores;
  List<Map<String, dynamic>> tags;
  bool saved;

  GameModel({
    required this.id,
    required this.name,
    required this.released,
    required this.announced,
    required this.backgroundImage,
    required this.rating,
    required this.ratings,
    required this.ratingsCount,
    required this.added,
    required this.addedByStatus,
    required this.metacritic,
    required this.playtime,
    required this.suggestionsCount,
    required this.updated,
    required this.reviewsCount,
    required this.platforms,
    required this.parentPlatforms,
    required this.genres,
    required this.stores,
    required this.tags,
    this.saved = false, // Default value for saved
  });
  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'],
      name: json['name'],
      released: json['released']?? "",
      announced: json['tba'] ?? false,
      backgroundImage: json["background_image"] ?? "",
      rating: (json['rating'] as num).toDouble(),
      ratings: List<Map<String, dynamic>>.from(json['ratings']),
      ratingsCount: json['ratings_count'],
      added: json['added'],
      addedByStatus: Map<String, int>.from(json['added_by_status'] ?? {}),
      metacritic: json['metacritic'] ?? 0,
      playtime: json['playtime'] ?? 0,
      suggestionsCount: json['suggestions_count'] ?? 0,
      updated: json['updated'],
      reviewsCount: json['reviews_count'] ?? 0,
      platforms: List<Map<String, dynamic>>.from(json['platforms']),
      parentPlatforms: List<Map<String, dynamic>>.from(json['parent_platforms']),
      genres: List<Map<String, dynamic>>.from(json['genres']),
      stores: List<Map<String, dynamic>>.from(json['stores']),
      tags: List<Map<String, dynamic>>.from(json['tags']),
      saved: false,
    );
  }
}