import 'package:flutter/material.dart';

class GameOverOverlay extends StatelessWidget {
  final VoidCallback onRestart;
  final String winner;

  const GameOverOverlay({
    super.key,
    required this.winner,
    required this.onRestart,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned.fill(
      child: Container(
        color: Colors.black54,
        alignment: Alignment.center,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    "Game Over! $winner won the game!",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.celebration_rounded, color: Colors.white),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRestart, child: Text("Restart game")),
          ],
        ),
      ),
    );
  }
}
