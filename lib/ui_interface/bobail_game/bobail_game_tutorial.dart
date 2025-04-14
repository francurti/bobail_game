import 'package:flutter/material.dart';

class BobailTutorial extends StatelessWidget {
  final VoidCallback onClose;

  const BobailTutorial({super.key, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: Colors.black.withOpacity(0.7),
      child: Stack(
        children: [
          Center(
            child: Container(
              margin: const EdgeInsets.all(24),
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.cardColor,
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Welcome to Bobail: How to Play',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'In this game you have two kinds of piece:'
                      ' First is the bobail (middle piece), The second is the player piece, each player'
                      ' has 5 pieces of its own color.',
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "The objective of the game is to move the bobail to your own side of the board, or make the other player unable to move the bobail on it's next turn",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "The movement rules are as follow:\n"
                      "- First Turn: White must move any of its own pieces\n"
                      "- After the first turn: The player must first move the bobail to then be able to move any of their own pieces"
                      "The piece movement rules are as follow\n"
                      "- The bobail can only move one square at a time in any direction\n"
                      "- The pieces can move in any direction but must move the maximun distance that they can get in that direction before colliding with another piece",
                      style: TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Use your movement to bring the bobail closer and also block your oponent. Good Luck!',
                      style: TextStyle(color: Colors.white),
                    ),

                    ElevatedButton(
                      onPressed: onClose,
                      child: const Text('Got it! Let’s play'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
