import 'package:project_0/api/GameApi.dart';
import 'package:project_0/models/GameModel.dart';

class GameDao {
  final GameApi _instance = GameApi();
  // Aggiungi supporto per paginazione
  Future<List<GameModel>> fetchGames(
      {
      int page = 1,
      int pageSize = 20,
      String? search,
      }
      ) async {
    final response = await _instance.getGames(page, pageSize);
    final List<dynamic> gamesJson = response.data['results'];
    return gamesJson.map((json) => GameModel.fromJson(json)).toList();
  }
}
