import 'package:hive/hive.dart';

part 'GameModel.g.dart';

@HiveType(typeId: 0)
class GameModel extends HiveObject {
  @HiveField(0)
  int _id;
  
  @HiveField(1)
  String _name;
  
  @HiveField(2)
  String _released;
  
  @HiveField(3)
  bool _announced;
  
  @HiveField(4)
  String _backgroundImage;
  
  @HiveField(5)
  double _rating;
  
  @HiveField(6)
  List<Map<String, dynamic>> _ratings;
  
  @HiveField(7)
  int _ratingsCount;
  
  @HiveField(8)
  int _added;
  
  @HiveField(9)
  Map<String, int> _addedByStatus;
  
  @HiveField(10)
  int _metacritic;
  
  @HiveField(11)
  int _playtime;
  
  @HiveField(12)
  int _suggestionsCount;
  
  @HiveField(13)
  String _updated;
  
  @HiveField(14)
  int _reviewsCount;
  
  @HiveField(15)
  List<Map<String, dynamic>> _platforms;
  
  @HiveField(16)
  List<Map<String, dynamic>> _parentPlatforms;
  
  @HiveField(17)
  List<Map<String, dynamic>> _genres;
  
  @HiveField(18)
  List<Map<String, dynamic>> _stores;
  
  @HiveField(19)
  List<Map<String, dynamic>> _tags;
  
  @HiveField(20)
  bool _saved;

  // ⚠️ COSTRUTTORE VUOTO RICHIESTO DA HIVE
  GameModel({
    int? id,
    String? name,
    String? released,
    bool? announced,
    String? backgroundImage,
    double? rating,
    List<Map<String, dynamic>>? ratings,
    int? ratingsCount,
    int? added,
    Map<String, int>? addedByStatus,
    int? metacritic,
    int? playtime,
    int? suggestionsCount,
    String? updated,
    int? reviewsCount,
    List<Map<String, dynamic>>? platforms,
    List<Map<String, dynamic>>? parentPlatforms,
    List<Map<String, dynamic>>? genres,
    List<Map<String, dynamic>>? stores,
    List<Map<String, dynamic>>? tags,
    bool? saved,
  }) : _id = id ?? 0,
       _name = name ?? '',
       _released = released ?? '',
       _announced = announced ?? false,
       _backgroundImage = backgroundImage ?? '',
       _rating = rating ?? 0.0,
       _ratings = ratings ?? [],
       _ratingsCount = ratingsCount ?? 0,
       _added = added ?? 0,
       _addedByStatus = addedByStatus ?? {},
       _metacritic = metacritic ?? 0,
       _playtime = playtime ?? 0,
       _suggestionsCount = suggestionsCount ?? 0,
       _updated = updated ?? '',
       _reviewsCount = reviewsCount ?? 0,
       _platforms = platforms ?? [],
       _parentPlatforms = parentPlatforms ?? [],
       _genres = genres ?? [],
       _stores = stores ?? [],
       _tags = tags ?? [],
       _saved = saved ?? false;

  // Getters and Setters
  int get id => _id;

  String get name => _name;

  String get released => _released;

  bool get announced => _announced;

  String get backgroundImage => _backgroundImage;

  double get rating => _rating;

  List<Map<String, dynamic>> get ratings => List.from(_ratings);

  int get ratingsCount => _ratingsCount;

  int get added => _added;
  
  Map<String, int> get addedByStatus => Map.from(_addedByStatus);

  int get metacritic => _metacritic;

  int get playtime => _playtime;

  int get suggestionsCount => _suggestionsCount;

  String get updated => _updated;

  int get reviewsCount => _reviewsCount;

  List<Map<String, dynamic>> get platforms => List.from(_platforms);

  List<Map<String, dynamic>> get parentPlatforms => List.from(_parentPlatforms);

  List<Map<String, dynamic>> get genres => List.from(_genres);

  List<Map<String, dynamic>> get stores => List.from(_stores);

  List<Map<String, dynamic>> get tags => List.from(_tags);

  bool get saved => _saved;
  set saved(bool value) {
    _saved = value;
    save();
  }

  // Computed getters
  bool get hasRating => _rating > 0.0;
  bool get hasMetacriticScore => _metacritic > 0;
  bool get isRecentlyUpdated {
    if (_updated.isEmpty) return false;
    try {
      final updatedDate = DateTime.parse(_updated);
      final now = DateTime.now();
      final difference = now.difference(updatedDate);
      return difference.inDays <= 30;
    } catch (e) {
      return false;
    }
  }

  String get ratingCategory {
    if (_rating >= 4.5) return 'Exceptional';
    if (_rating >= 4.0) return 'Recommended';
    if (_rating >= 3.0) return 'Meh';
    if (_rating >= 2.0) return 'Skip';
    return 'Unrated';
  }

  // Utility methods
  void addRating(Map<String, dynamic> rating) {
    _ratings.add(rating);
    save();
  }

  void removeRating(int index) {
    if (index >= 0 && index < _ratings.length) {
      _ratings.removeAt(index);
      save();
    }
  }

  void addPlatform(Map<String, dynamic> platform) {
    _platforms.add(platform);
    save();
  }

  void addGenre(Map<String, dynamic> genre) {
    _genres.add(genre);
    save();
  }

  void addStore(Map<String, dynamic> store) {
    _stores.add(store);
    save();
  }

  void addTag(Map<String, dynamic> tag) {
    _tags.add(tag);
    save();
  }

  // Factory constructor per creare da JSON
  factory GameModel.fromJson(Map<String, dynamic> json) {
    return GameModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      released: json['released'] ?? "",
      announced: json['tba'] ?? false,
      backgroundImage: json["background_image"] ?? "",
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      ratings: List<Map<String, dynamic>>.from(json['ratings'] ?? []),
      ratingsCount: json['ratings_count'] ?? 0,
      added: json['added'] ?? 0,
      addedByStatus: Map<String, int>.from(json['added_by_status'] ?? {}),
      metacritic: json['metacritic'] ?? 0,
      playtime: json['playtime'] ?? 0,
      suggestionsCount: json['suggestions_count'] ?? 0,
      updated: json['updated'] ?? "",
      reviewsCount: json['reviews_count'] ?? 0,
      platforms: List<Map<String, dynamic>>.from(json['platforms'] ?? []),
      parentPlatforms: List<Map<String, dynamic>>.from(json['parent_platforms'] ?? []),
      genres: List<Map<String, dynamic>>.from(json['genres'] ?? []),
      stores: List<Map<String, dynamic>>.from(json['stores'] ?? []),
      tags: List<Map<String, dynamic>>.from(json['tags'] ?? []),
      saved: json['saved'] ?? false,
    );
  }

  // toJson method
  Map<String, dynamic> toJson() {
    return {
      'id': _id,
      'name': _name,
      'released': _released,
      'tba': _announced,
      'background_image': _backgroundImage,
      'rating': _rating,
      'ratings': _ratings,
      'ratings_count': _ratingsCount,
      'added': _added,
      'added_by_status': _addedByStatus,
      'metacritic': _metacritic,
      'playtime': _playtime,
      'suggestions_count': _suggestionsCount,
      'updated': _updated,
      'reviews_count': _reviewsCount,
      'platforms': _platforms,
      'parent_platforms': _parentPlatforms,
      'genres': _genres,
      'stores': _stores,
      'tags': _tags,
      'saved': _saved,
    };
  }

  @override
  String toString() {
    return 'GameModel(id: $_id, name: $_name, rating: $_rating, saved: $_saved)';
  }
}