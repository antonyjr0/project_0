
class PlatformModel {
  final int id;
  final String name;
  final String slug;
  final List<Map<String,dynamic>> platforms;

  PlatformModel({
    required this.id,
    required this.name,
    required this.slug,
    required this.platforms,
  });

  factory PlatformModel.fromJson(Map<String, dynamic> json) {
    return PlatformModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      platforms: json['platforms'] ?? [],
    );
  }
  
}