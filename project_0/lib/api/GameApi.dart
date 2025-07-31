import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GameApi {
  static const String baseUrl = 'https://api.rawg.io/api';
  final Dio _dio = Dio();

  Future getGames() async{
    final rersponse =_dio.get('$baseUrl/games', queryParameters: {'key': dotenv.env['API_KEY'], 'page_size': '10'})
      .then((response) {
        if (response.statusCode == 200) {
          debugPrint('Games fetched successfully: ${response.data}');
        } else {
          debugPrint('Failed to fetch games: ${response.statusCode}');
        }
      })
      .catchError((error) {
        debugPrint('Error fetching games: $error');
        throw error;
      });
      return rersponse;
  }
}
