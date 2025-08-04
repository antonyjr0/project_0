import 'package:flutter/material.dart';
import 'package:project_0/api/GameApi.dart';
import 'package:project_0/database/game_hive_service.dart';
import 'package:project_0/models/GameModel.dart';

class GameDao {
  final GameApi _instance = GameApi();
  
  Future<Map<String, dynamic>> fetchGames({
    int page = 1,
    int pageSize = 20,
    String? search,
  }) async {
    try {
      // Prova a caricare dall'API
      final responseData = await _instance.getGames(page, pageSize);
      final List<dynamic> gamesJson = responseData['results'];
      final games = gamesJson.map((json) => GameModel.fromJson(json)).toList();
      
      // Merge con i dati locali per mantenere le preferenze
      final mergedGames = await GameHiveService.mergeWithApiData(games);
      
      return {
        'games': mergedGames,
        'hasNext': responseData['next'] != null,
        'totalCount': responseData['count'],
      };
    } catch (e) {
      debugPrint('❌ Errore API, carico dati offline: $e');
      
      // Se l'API fallisce, carica solo i dati locali
      final offlineGames = GameHiveService.getAllGames();
      
      // Simula paginazione sui dati offline
      final startIndex = (page - 1) * pageSize;
      final endIndex = startIndex + pageSize;
      
      final paginatedGames = offlineGames.length > startIndex
          ? offlineGames.sublist(
              startIndex,
              endIndex > offlineGames.length ? offlineGames.length : endIndex,
            )
          : <GameModel>[];
      
      return {
        'games': paginatedGames,
        'hasNext': endIndex < offlineGames.length,
        'totalCount': offlineGames.length,
      };
    }
  }
  
  Future<Map<String, dynamic>> fetchAnnouncedGames({
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final responseData = await _instance.getAnnouncedGames(page, pageSize);
      final List<dynamic> gamesJson = responseData['results'];
      final games = gamesJson.map((json) => GameModel.fromJson(json)).toList();
      
      // Merge con i dati locali per mantenere le preferenze
      final mergedGames = await GameHiveService.mergeWithApiData(games);
      
      return {
        'games': mergedGames,
        'hasNext': responseData['next'] != null,
        'totalCount': responseData['count'],
      };
    } catch (e) {
      debugPrint('❌ Errore API, carico dati offline: $e');
      
      // Se l'API fallisce, carica solo i dati locali
      final offlineGames = GameHiveService.getAllGames();
      
      // Simula paginazione sui dati offline
      final startIndex = (page - 1) * pageSize;
      final endIndex = startIndex + pageSize;
      
      final paginatedGames = offlineGames.length > startIndex
          ? offlineGames.sublist(
              startIndex,
              endIndex > offlineGames.length ? offlineGames.length : endIndex,
            )
          : <GameModel>[];
      
      return {
        'games': paginatedGames,
        'hasNext': endIndex < offlineGames.length,
        'totalCount': offlineGames.length,
      };
    }
  }
  // Metodo per salvare/rimuovere dai preferiti
  Future<void> toggleFavorite(GameModel game) async {
    if (game.saved) {
      await GameHiveService.removeFromFavorites(game.id);
    } else {
      await GameHiveService.saveAsFavorite(game);
    }
  }
  
  // Metodo per ottenere solo i giochi salvati
  List<GameModel> getSavedGames() {
    return GameHiveService.getSavedGames();
  }
  
  // Metodo per ottenere statistiche
  Map<String, dynamic> getStatistics() {
    return GameHiveService.getGamesStatistics();
  }
}