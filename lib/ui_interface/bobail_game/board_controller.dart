import 'package:bobail_mobile/board_model/visualization/move_error_response.dart';
import 'package:bobail_mobile/board_presentation/board_indicators.dart';
import 'package:bobail_mobile/board_presentation/game_interface.dart';
import 'package:bobail_mobile/board_presentation/piece_indicators.dart';
import 'package:flutter/material.dart';

class BoardController extends ChangeNotifier {
  late GameInterface _game;
  late Set<int> highlightedPiecesIndex;
  late BoardIndicators boardIndicators;
  int? currentSelectedPiece;

  BoardController() {
    _game = GameInterface.bobail();
    highlightedPiecesIndex = <int>{};
    boardIndicators = _game.getBoardIndicators();
  }

  GameInterface get game => _game;
  String get playerTurnName => _game.bobailPlayerTurn;
  bool get isGameOver => _game.isGameOver();
  String get winner => _game.winner();

  void restartGame() {
    _game.resetGame();
    boardIndicators = _game.getBoardIndicators();
    notifyListeners();
  }

  void handleTap(BuildContext context, int position) {
    final tappedBoardPosition = boardIndicators.piecesIndicator[position];

    final isEmptyPosition =
        (tappedBoardPosition == null) ||
        (tappedBoardPosition.isBobail && !tappedBoardPosition.isMoveable);

    if (tappedBoardPosition != null && tappedBoardPosition.isMoveable) {
      _handlePieceSelection(tappedBoardPosition, position);
    } else if (isEmptyPosition && currentSelectedPiece != null) {
      _handleMove(context, currentSelectedPiece!, position);
    }
  }

  void _handleMove(BuildContext context, int from, int to) {
    final piece = boardIndicators.piecesIndicator[from];

    if (piece != null && piece.isBobail) {
      _game.bobailPreview = to;
    } else {
      MoveResult moveResult = _game.makeMove(from, to);

      if (!moveResult.isOk) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${moveResult.error?.message}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }

      _game.bobailPreview = null;
    }

    _registerBoardMovement();
    notifyListeners();
  }

  void _handlePieceSelection(PieceIndicator piece, int position) {
    if (!piece.isBobail) {
      _selectNewPiece(position);
    } else {
      _solveBobailSelection(position);
    }
    notifyListeners();
  }

  void _selectNewPiece(int position) {
    if (currentSelectedPiece == position) {
      highlightedPiecesIndex.clear();
      currentSelectedPiece = null;
    } else {
      highlightedPiecesIndex =
          boardIndicators.piecesIndicator[position]?.movablePreview ?? <int>{};
      currentSelectedPiece = position;
      boardIndicators = _game.getBoardIndicators();
    }
  }

  void _solveBobailSelection(int position) {
    if (currentSelectedPiece == position) {
      _game.bobailPreview = null;
      currentSelectedPiece = null;
      highlightedPiecesIndex.clear();
      boardIndicators = _game.getBoardIndicators();
    } else {
      currentSelectedPiece = position;
      highlightedPiecesIndex =
          boardIndicators.piecesIndicator[position]?.movablePreview ?? <int>{};
      boardIndicators = _game.getBoardIndicators();
    }
  }

  void _registerBoardMovement() {
    highlightedPiecesIndex.clear();
    boardIndicators = _game.getBoardIndicators();
  }
}
