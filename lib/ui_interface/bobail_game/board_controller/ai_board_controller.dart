import 'package:bobail_mobile/board_model/visualization/move_error_response.dart';
import 'package:bobail_mobile/board_presentation/piece_indicators.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/board_controller/board_controller.dart';
import 'package:flutter/material.dart';

class AiBoardController extends BoardController {
  AiBoardController(super.boardSettings, this.isWhitePlayer);

  final bool isWhitePlayer;

  @override
  void handleTap(BuildContext context, int position) {
    final tappedBoardPosition = boardIndicators.piecesIndicator[position];

    final isEmptyPosition =
        (tappedBoardPosition == null) ||
        (tappedBoardPosition.isBobail && !_isMoveable(tappedBoardPosition));

    if (tappedBoardPosition != null && _isMoveable(tappedBoardPosition)) {
      _handlePieceSelection(tappedBoardPosition, position);
    } else if (isEmptyPosition && currentSelectedPiece != null) {
      _handleMove(context, currentSelectedPiece!, position);
    }
  }

  bool _isMoveable(PieceIndicator piece) {
    return piece.isMoveable &&
        ((piece.isWhite && isWhitePlayer) || (piece.isBlack && !isWhitePlayer));
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
      boardIndicators = game.getBoardIndicators();
    }
  }

  void _solveBobailSelection(int position) {
    if (currentSelectedPiece == position) {
      game.bobailPreview = null;
      currentSelectedPiece = null;
      highlightedPiecesIndex.clear();
      boardIndicators = game.getBoardIndicators();
    } else {
      currentSelectedPiece = position;
      highlightedPiecesIndex =
          boardIndicators.piecesIndicator[position]?.movablePreview ?? <int>{};
      boardIndicators = game.getBoardIndicators();
    }
  }

  void _handleMove(BuildContext context, int from, int to) {
    final piece = boardIndicators.piecesIndicator[from];

    if (piece != null && piece.isBobail) {
      game.bobailPreview = to;
    } else {
      MoveResult moveResult = game.makeMove(from, to);

      if (!moveResult.isOk) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${moveResult.error?.message}'),
            duration: const Duration(seconds: 2),
          ),
        );
      }

      game.bobailPreview = null;
    }

    _registerBoardMovement();
    notifyListeners();
  }

  void _registerBoardMovement() {
    highlightedPiecesIndex.clear();
    boardIndicators = game.getBoardIndicators();
  }
}
