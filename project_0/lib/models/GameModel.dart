class Gamemodel {

  int id;
  String name;
  String released;
  bool announced;
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

  Gamemodel({
    required this.id,
    required this.name,
    required this.released,
    required this.announced,
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
}