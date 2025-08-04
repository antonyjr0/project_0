import 'package:flutter/material.dart';
import 'package:project_0/components/game_card.dart';
import 'package:project_0/components/load_indicator.dart';
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
  int? _totalCount;

  static const double _scrollThreshold = 0.8;
  static const int _pageSize = 20;
  bool _isNearBottom = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadGames();
    });
  }

  void _onScroll() {
    final position = _scrollController.position;
    final isNearBottom =
        position.pixels >= position.maxScrollExtent * _scrollThreshold;

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
      _totalCount = null;
    });

    try {
      final result = await _gameDao.fetchGames(
        page: _currentPage,
        pageSize: _pageSize,
      );

      if (mounted) {
        setState(() {
          _games = result['games'];
          _hasMore = result['hasNext'];
          _totalCount = result['totalCount'];
          _isLoading = false;
        });

        debugPrint(
            'Caricati ${_games.length} giochi. HasMore: $_hasMore. Total: $_totalCount');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        _showError('Failed to load games: $e');
      }
    }
  }

  Future<void> _loadMoreGames() async {
    if (_isLoadingMore || !_hasMore || _isLoading) {
      debugPrint(
          'Skip loadMore: loading=$_isLoadingMore, hasMore=$_hasMore, isLoading=$_isLoading');
      return;
    }

    setState(() => _isLoadingMore = true);

    try {
      final result = await _gameDao.fetchGames(
        page: _currentPage + 1,
        pageSize: _pageSize,
      );

      if (mounted) {
        final newGames = result['games'] as List<GameModel>;

        setState(() {
          _games.addAll(newGames);
          _currentPage++;
          _hasMore = result['hasNext'];
          _isLoadingMore = false;
        });

        debugPrint(
            'Caricata pagina $_currentPage. Nuovi giochi: ${newGames.length}. Totale: ${_games.length}. HasMore: $_hasMore');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingMore = false);
        _showError('Failed to load more games: $e');
      }
      debugPrint('Errore nel caricamento pagina ${_currentPage + 1}: $e');
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
      //drawer: ,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Game Discovery'),
            if (_totalCount != null)
              Text(
                '${_games.length} of $_totalCount games',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
          ],
        ),
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
