import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GameApi {
  static const String baseUrl = 'https://api.rawg.io/api';
  static final Dio _dio = Dio();

  Future<Response> getGames(int page, int pagesSize) async {
    final response = await _dio.get('$baseUrl/games',
        queryParameters: {'key': dotenv.env['API_KEY'], 'page_size': pagesSize});
    if (response.statusCode != 200) {
      throw Exception('Failed to load games');
    }
    return response;
  }
}
