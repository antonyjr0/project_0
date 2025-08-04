import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:project_0/models/GameModel.dart';

class GameHiveService {
  // Nomi dei box
  static const String _allGamesBox = 'all_games';
  static const String _savedGamesBox = 'saved_games';
  static const String _settingsBox = 'settings';
  
  // Box references
  static Box<GameModel>? _allGames;
  static Box<GameModel>? _savedGames;
  static Box? _settings;
  
  // Flag di inizializzazione
  static bool _initialized = false;
  
  /// Inizializza Hive e apre i box
  static Future<void> init() async {
    if (_initialized) return;
    
    try {
      // Inizializza Hive
      await Hive.initFlutter();
      
      // Registra l'adapter del GameModel
      if (!Hive.isAdapterRegistered(0)) {
        Hive.registerAdapter(GameModelAdapter());
      }
      
      // Apri i box
      _allGames = await Hive.openBox<GameModel>(_allGamesBox);
      _savedGames = await Hive.openBox<GameModel>(_savedGamesBox);
      _settings = await Hive.openBox(_settingsBox);
      
      _initialized = true;
      debugPrint('hive inizializzato con successo');
      
    } catch (e) {
      debugPrint('❌ Errore nell\'inizializzazione di Hive: $e');
      rethrow;
    }
  }
  
  /// Verifica se Hive è inizializzato
  static void _checkInitialization() {
    if (!_initialized) {
      throw Exception('Hive non è stato inizializzato. Chiama GameHiveService.init() prima.');
    }
  }
  
  // GESTIONE GIOCHI GENERALI
  
  /// Salva un gioco nel box generale
  static Future<void> saveGame(GameModel game) async {
    _checkInitialization();
    try {
      await _allGames?.put(game.id, game);
      debugPrint('💾 Gioco salvato: ${game.name}');
    } catch (e) {
      debugPrint('❌ Errore nel salvare il gioco: $e');
    }
  }
  
  /// Salva più giochi contemporaneamente
  static Future<void> saveGames(List<GameModel> games) async {
    _checkInitialization();
    try {
      final Map<int, GameModel> gamesMap = {
        for (var game in games) game.id: game
      };
      await _allGames?.putAll(gamesMap);
      debugPrint('💾 Salvati ${games.length} giochi');
    } catch (e) {
      debugPrint('❌ Errore nel salvare i giochi: $e');
    }
  }
  
  /// Recupera un gioco specifico
  static GameModel? getGame(int id) {
    _checkInitialization();
    return _allGames?.get(id) ?? _savedGames?.get(id);
  }
  
  /// Recupera tutti i giochi
  static List<GameModel> getAllGames() {
    _checkInitialization();
    return _allGames?.values.toList() ?? [];
  }
  
  // GESTIONE GIOCHI SALVATI/PREFERITI
  
  /// Marca un gioco come salvato
  static Future<void> saveAsFavorite(GameModel game) async {
    _checkInitialization();
    try {
      game.saved = true;
      
      // Salva in entrambi i box
      await _allGames?.put(game.id, game);
      await _savedGames?.put(game.id, game);
      
      debugPrint('⭐ Gioco aggiunto ai preferiti: ${game.name}');
    } catch (e) {
      debugPrint('❌ Errore nell\'aggiungere ai preferiti: $e');
    }
  }
  
  /// Rimuove un gioco dai salvati
  static Future<void> removeFromFavorites(int gameId) async {
    _checkInitialization();
    try {
      // Aggiorna nel box principale
      final game = _allGames?.get(gameId);
      if (game != null) {
        game.saved = false;
        await _allGames?.put(gameId, game);
      }
      
      // Rimuovi dal box dei salvati
      await _savedGames?.delete(gameId);
      
      debugPrint('🗑️ Gioco rimosso dai preferiti: ID $gameId');
    } catch (e) {
      debugPrint('❌ Errore nella rimozione dai preferiti: $e');
    }
  }
  
  /// Recupera tutti i giochi salvati
  static List<GameModel> getSavedGames() {
    _checkInitialization();
    return _savedGames?.values.toList() ?? [];
  }
  
  /// Verifica se un gioco è salvato
  static bool isGameSaved(int gameId) {
    _checkInitialization();
    return _savedGames?.containsKey(gameId) ?? false;
  }
  
  // RICERCA E FILTRI
  
  /// Cerca giochi per nome
  static List<GameModel> searchGamesByName(String query) {
    _checkInitialization();
    final allGames = getAllGames();
    final queryLower = query.toLowerCase();
    
    return allGames.where((game) =>
        game.name.toLowerCase().contains(queryLower)
    ).toList();
  }
  
  /// Filtra giochi per rating minimo
  static List<GameModel> getGamesByMinRating(double minRating) {
    _checkInitialization();
    final allGames = getAllGames();
    
    return allGames.where((game) => game.rating >= minRating).toList();
  }
  
  /// Filtra giochi per metacritic minimo
  static List<GameModel> getGamesByMinMetacritic(int minScore) {
    _checkInitialization();
    final allGames = getAllGames();
    
    return allGames.where((game) => game.metacritic >= minScore).toList();
  }
  
  // STATISTICHE
  
  /// Ottieni statistiche sui giochi
  static Map<String, dynamic> getGamesStatistics() {
    _checkInitialization();
    final allGames = getAllGames();
    final savedGames = getSavedGames();
    
    if (allGames.isEmpty) {
      return {
        'total_games': 0,
        'saved_games': 0,
        'average_rating': 0.0,
        'highest_rated': null,
      };
    }
    
    final totalRating = allGames.fold<double>(0, (sum, game) => sum + game.rating);
    final averageRating = totalRating / allGames.length;
    
    final highestRated = allGames.reduce((a, b) => a.rating > b.rating ? a : b);
    
    return {
      'total_games': allGames.length,
      'saved_games': savedGames.length,
      'average_rating': averageRating,
      'highest_rated': highestRated,
      'games_with_rating': allGames.where((g) => g.rating > 0).length,
      'games_with_metacritic': allGames.where((g) => g.metacritic > 0).length,
    };
  }
  
  // GESTIONE SETTINGS
  
  /// Salva un'impostazione
  static Future<void> saveSetting(String key, dynamic value) async {
    _checkInitialization();
    await _settings?.put(key, value);
  }
  
  /// Recupera un'impostazione
  static T? getSetting<T>(String key, [T? defaultValue]) {
    _checkInitialization();
    return _settings?.get(key, defaultValue: defaultValue) as T?;
  }
  
  // SINCRONIZZAZIONE CON API
  
  /// Merge dei dati API con quelli locali
  static Future<List<GameModel>> mergeWithApiData(List<GameModel> apiGames) async {
    _checkInitialization();
    
    final List<GameModel> mergedGames = [];
    
    for (var apiGame in apiGames) {
      // Cerca se il gioco esiste già localmente
      final localGame = getGame(apiGame.id);
      
      if (localGame != null) {
        // Mantieni le preferenze locali ma aggiorna i dati dall'API
        apiGame.saved = localGame.saved;
        // Puoi mantenere altre modifiche locali qui se necessario
      }
      
      mergedGames.add(apiGame);
      
      // Salva il gioco aggiornato
      await saveGame(apiGame);
    }
    
    return mergedGames;
  }
  
  // BACKUP E RIPRISTINO
  
  /// Esporta tutti i giochi salvati
  static Map<String, dynamic> exportSavedGames() {
    _checkInitialization();
    final savedGames = getSavedGames();
    
    return {
      'games': savedGames.map((game) => game.toJson()).toList(),
      'export_date': DateTime.now().toIso8601String(),
      'version': '1.0',
    };
  }
  
  /// Importa giochi salvati
  static Future<void> importSavedGames(Map<String, dynamic> backup) async {
    _checkInitialization();
    
    try {
      final gamesList = backup['games'] as List;
      
      for (var gameJson in gamesList) {
        final game = GameModel.fromJson(gameJson);
        await saveAsFavorite(game);
      }
      
      debugPrint('📥 Importati ${gamesList.length} giochi');
    } catch (e) {
      debugPrint('❌ Errore nell\'importazione: $e');
    }
  }
  
  // PULIZIA E MANUTENZIONE
  
  /// Pulisce la cache (mantiene solo i salvati)
  static Future<void> clearCache() async {
    _checkInitialization();
    await _allGames?.clear();
    debugPrint('🧹 Cache pulita');
  }
  
  /// Pulisce tutti i dati
  static Future<void> clearAllData() async {
    _checkInitialization();
    await _allGames?.clear();
    await _savedGames?.clear();
    await _settings?.clear();
    debugPrint('🧹 Tutti i dati puliti');
  }
  
  /// Compatta il database
  static Future<void> compact() async {
    _checkInitialization();
    await _allGames?.compact();
    await _savedGames?.compact();
    await _settings?.compact();
    debugPrint('🗜️ Database compattato');
  }
  
  /// Chiude tutti i box (da chiamare quando l'app si chiude)
  static Future<void> close() async {
    if (_initialized) {
      await _allGames?.close();
      await _savedGames?.close();
      await _settings?.close();
      _initialized = false;
      debugPrint('🔒 Hive chiuso');
    }
  }
}