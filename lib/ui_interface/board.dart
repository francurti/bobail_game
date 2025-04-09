import 'package:bobail_mobile/board_model/visualization/move_error_response.dart';
import 'package:bobail_mobile/board_presentation/board_indicators.dart';
import 'package:bobail_mobile/board_presentation/game_interface.dart';
import 'package:bobail_mobile/board_presentation/piece_indicators.dart';
import 'package:flutter/material.dart';

import 'piece.dart';

class Board extends StatefulWidget {
  const Board({super.key});

  @override
  State<Board> createState() => _BoardState();
}

class _BoardState extends State<Board> {
  late GameInterface _game;
  late Set<int> _highlithedPiecesIndex;
  late BoardIndicators _boardIndicators;
  int? _currentSelectedPiece;

  @override
  void initState() {
    super.initState();
    _game = GameInterface.bobail();
    _highlithedPiecesIndex = <int>{};
    _boardIndicators = _game.getBoardIndicators();
  }

  void _handleTap(int position) {
    final boardPosition = _boardIndicators.piecesIndicator[position];
    final isEmptyPosition =
        (boardPosition == null) ||
        (boardPosition.isBobail && !boardPosition.isMoveable);
    print('Tapped on $position, bobail: ${_game.bobailDestionationPosition}');

    if (boardPosition != null && boardPosition.isMoveable) {
      print('Handle piece selection');
      _handlePieceSelection(boardPosition, position);
    } else if (isEmptyPosition && _currentSelectedPiece != null) {
      print('handle move currentSelectedPiece is not null');
      _handleMove(_currentSelectedPiece!, position);
    }
  }

  void _handleMove(int from, int to) {
    final piece = _boardIndicators.piecesIndicator[from];

    if (piece != null && piece.isBobail) {
      setState(() {
        _game.bobailPreview = to;
      });
    } else {
      MoveResult moveResult = _game.makeMove(from, to);

      if (!moveResult.isOk) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${moveResult.error}'),
            duration: Duration(seconds: 2),
          ),
        );
      }

      setState(() {
        _game.bobailPreview = null;
      });
    }

    _registerBoardMovement();
  }

  void _handlePieceSelection(PieceIndicator piece, int position) {
    if (!piece.isBobail) {
      _selectNewPiece(position);
    } else {
      _solveBobailSelection(position);
    }
  }

  void _selectNewPiece(int position) {
    if (_currentSelectedPiece == position) {
      setState(() {
        _highlithedPiecesIndex.clear();
        _currentSelectedPiece = null;
      });
    } else {
      setState(() {
        _highlithedPiecesIndex =
            _boardIndicators.piecesIndicator[position]?.movablePreview ??
            <int>{};
        _currentSelectedPiece = position;
        _boardIndicators = _game.getBoardIndicators();
      });
    }
  }

  void _solveBobailSelection(int position) {
    if (_currentSelectedPiece == position) {
      // Tapped again → unselect Bobail
      setState(() {
        _game.bobailPreview = null;
        _currentSelectedPiece = null;
        _highlithedPiecesIndex.clear();
        _boardIndicators = _game.getBoardIndicators();
      });
    } else {
      // Select Bobail and show movable preview
      setState(() {
        _currentSelectedPiece = position;
        _highlithedPiecesIndex =
            _boardIndicators.piecesIndicator[position]?.movablePreview ??
            <int>{};
        _boardIndicators = _game.getBoardIndicators();
      });
    }
  }

  void _registerBoardMovement() {
    setState(() {
      _highlithedPiecesIndex.clear(); // clear highlights if needed
      _boardIndicators = _game.getBoardIndicators(); // re-fetch updated board
    });
  }

  @override
  Widget build(BuildContext context) {
    const int boardSize = 5;

    return AspectRatio(
      aspectRatio: 1,
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Text(
              'Turn ${_boardIndicators.turn}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: GridView.builder(
              itemCount: boardSize * boardSize,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: boardSize,
              ),
              itemBuilder: (context, index) {
                final PieceIndicator? piece =
                    _boardIndicators.piecesIndicator[index];

                return InkWell(
                  onTap: () => _handleTap(index),
                  customBorder: const CircleBorder(),
                  focusColor: Colors.amber,
                  child: Piece(
                    piece: piece,
                    isBobailPreview: _game.bobailPreview == index,
                    isHighligthed: _highlithedPiecesIndex.contains(index),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
