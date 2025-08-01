import 'package:flutter/material.dart';
import 'package:project_0/dao/GameDAO.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GameDao _instance = GameDao();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _instance.fetchGames(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return Scaffold(
            appBar: AppBar(
              title: Text('Flutter Riverpod Example'),
            ),
            body: Center(
              child: ListView.builder(
                itemCount: snapshot.data?.length ?? 0,
                itemBuilder: (context, index) {
                  final game = snapshot.data![index];
                  return ListTile(
                    title: Text(game.name),
                    subtitle: Text('Rating: ${game.rating}'),
                  );
                },
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }
}
