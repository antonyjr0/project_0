import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GameApi {
  static const String baseUrl = 'https://api.rawg.io/api';
  static final Dio _dio = Dio();

  Future<Map<String, dynamic>> getGames(int page, int pageSize) async {
    final response = await _dio.get('$baseUrl/games', queryParameters: {
      'key': dotenv.env['API_KEY'],
      'page_size': pageSize,
      'page': page,
      'ordering': '-released' // Cambiato da 'released' a '-released'
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