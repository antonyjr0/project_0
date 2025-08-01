import 'package:project_0/api/GameApi.dart';
import 'package:project_0/models/GameModel.dart';

class GameDao {

  Future<List<Gamemodel>> fetchGames() async {
    List<Gamemodel> result = [];
    final response = await GameApi.getGames();
    for (var game in response.data['results']) {
      result.add(Gamemodel.fromJson(game));
    }
    return result;
  }  
}