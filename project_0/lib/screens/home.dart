import 'package:flutter/material.dart';
import 'package:project_0/dao/GameDAO.dart';
import 'package:project_0/models/GameModel.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GameDao _gameDao = GameDao();
  final ScrollController _scrollController = ScrollController();
  
  List<GameModel> _games = [];
  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMore = true;
  int _currentPage = 1;
  
  // Ottimizzazioni performance
  static const double _scrollThreshold = 0.8;
  static const int _pageSize = 20;
  bool _isNearBottom = false;
  
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    
    // Carica prima pagina con delay per evitare build durante build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGames();
    });
  }
  
  void _onScroll() {
    final position = _scrollController.position;
    final isNearBottom = position.pixels >= position.maxScrollExtent * _scrollThreshold;
    
    // Trigger solo quando attraversiamo la soglia
    if (isNearBottom && !_isNearBottom) {
      _isNearBottom = true;
      _loadMoreGames();
    } else if (!isNearBottom) {
      _isNearBottom = false;
    }
  }
  
  Future<void> _loadGames() async {
    if (_isLoading) return;
    
    setState(() {
      _isLoading = true;
      _games.clear();
      _currentPage = 1;
      _hasMore = true;
      _isNearBottom = false;
    });
    
    try {
      final newGames = await _gameDao.fetchGames(
        page: _currentPage,
        pageSize: _pageSize,
      );
      
      if (mounted) {
        setState(() {
          _games = newGames;
          _hasMore = newGames.length >= _pageSize;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError('Failed to load games: $e');
      }
    }
  }
  
  Future<void> _loadMoreGames() async {
    if (_isLoadingMore || !_hasMore || _isLoading) return;
    
    setState(() => _isLoadingMore = true);
    
    try {
      final newGames = await _gameDao.fetchGames(
        page: _currentPage + 1,
        pageSize: _pageSize,
      );
      
      if (mounted) {
        setState(() {
          _games.addAll(newGames);
          _currentPage++;
          _hasMore = newGames.length >= _pageSize;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingMore = false);
      }
    }
  }
  
  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(
          label: 'Retry',
          onPressed: _loadGames,
        ),
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Game Discovery'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _loadGames,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }
  
  Widget _buildBody() {
    if (_isLoading && _games.isEmpty) {
      return _buildLoadingState();
    }
    
    if (_games.isEmpty) {
      return _buildEmptyState();
    }
    
    return RefreshIndicator(
      onRefresh: _loadGames,
      child: ListView.builder(
        controller: _scrollController,
        itemCount: _games.length + (_hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index < _games.length) {
            return GameCard(
              key: ValueKey(_games[index].id), // Per performance
              game: _games[index],
            );
          }
          
          return LoadingMoreIndicator(isLoading: _isLoadingMore);
        },
      ),
    );
  }
  
  Widget _buildLoadingState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(),
          SizedBox(height: 16),
          Text('Loading awesome games...'),
        ],
      ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.videogame_asset_off, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text('No games found'),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadGames,
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
class GameCard extends StatelessWidget {
  final GameModel game;
  
  const GameCard({Key? key, required this.game}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: game.backgroundImage != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  game.backgroundImage!,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      color: Colors.grey[300],
                      child: Icon(Icons.games),
                    );
                  },
                ),
              )
            : Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.games),
              ),
        title: Text(
          game.name,
          style: TextStyle(fontWeight: FontWeight.bold),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, size: 16, color: Colors.amber),
                SizedBox(width: 4),
                Text('${game.rating}'),
                Spacer(),
                  Text(
                    game.released,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
              ],
            ),
            if (game.announced)
              Padding(
                padding: EdgeInsets.only(top: 4),
                child: Chip(
                  label: Text('Coming Soon'),
                  backgroundColor: Colors.orange[100],
                  labelStyle: TextStyle(fontSize: 12),
                ),
              ),
          ],
        ),
        onTap: () {
          // Navigazione ai dettagli
          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => GameDetailScreen(game: game),
          //   ),
          // );
        },
      ),
    );
  }
}

// Widget per loading indicator
class LoadingMoreIndicator extends StatelessWidget {
  final bool isLoading;
  
  const LoadingMoreIndicator({Key? key, required this.isLoading}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Padding(
        padding: EdgeInsets.all(16),
        child: Center(
          child: Column(
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 8),
              Text('Loading more games...'),
            ],
          ),
        ),
      );
    }
    
    return Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: Text(
          'No more games to load',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }
}