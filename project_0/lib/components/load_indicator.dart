import 'package:flutter/material.dart';

class LoadingMoreIndicator extends StatelessWidget {
  final bool isLoading;
  
  const LoadingMoreIndicator({super.key, required this.isLoading});
  
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
