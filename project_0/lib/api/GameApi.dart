import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GameApi {
  static const String baseUrl = 'https://api.rawg.io/api';
  static final Dio _dio = Dio();

  Future<Map<String, dynamic>> getGames(int page, int pageSize) async {
    final now = DateTime.now();
    final today =
        "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";

    final response = await _dio.get('$baseUrl/games', queryParameters: {
      'key': dotenv.env['API_KEY'],
      'page_size': pageSize,
      'page': page,
      'ordering': '-released',
      'dates': '1970-01-01,$today', // Dalla prima data possibile fino ad oggi
    });
    if (response.statusCode != 200) {
      throw Exception('Failed to load games');
    }
    return {
      'results': response.data['results'],
      'count': response.data['count'],
      'next': response.data['next'],
      'previous': response.data['previous'],
    };
  }
}
