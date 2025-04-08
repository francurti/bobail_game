import 'package:bobail_mobile/board_model/bobail_game.dart';
import 'package:flutter/material.dart';

import 'piece.dart';

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  late BobailGame _game;

  @override
  void initState() {
    super.initState();
    _game = BobailGame();
  }

  void _handleTap(int? position) {
    // For now just log tapped position
    print('Tapped on $position');
    if (position != null) {
      // Example move (P1 moves from 0,0 to 1,1)
      setState(() {
        _game.move(0, position, null);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    const int boardSize = 5;

    return AspectRatio(
      aspectRatio: 1,
      child: GridView.builder(
        itemCount: boardSize * boardSize,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: boardSize,
        ),
        itemBuilder: (context, index) {
          final piece = _game.showBoardState().boardViewModel[index];

          return GestureDetector(
            onTap: () => _handleTap(index),
            child: Piece(piece: piece),
          );
        },
      ),
    );
  }
}
