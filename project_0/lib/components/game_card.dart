import 'package:flutter/material.dart';
import 'package:project_0/models/GameModel.dart';

class GameCard extends StatelessWidget {
  final GameModel game;
  
  const GameCard({super.key, required this.game});
  
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        leading: game.backgroundImage != ""
            ? ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  game.backgroundImage,
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
        },
      ),
    );
  }
}
