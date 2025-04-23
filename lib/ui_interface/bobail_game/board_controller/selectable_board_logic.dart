import 'package:bobail_mobile/board_presentation/piece_indicators.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/board_controller/board_controller.dart';
import 'package:flutter/material.dart';

mixin SelectableBoardLogic on BoardController {
  bool handlePieceTap(
    BuildContext context,
    int position,
    PieceIndicator? tappedPiece,
  ) {
    final isEmpty =
        tappedPiece == null ||
        (tappedPiece.isBobail && !(tappedPiece.isMoveable));

    if (tappedPiece?.isMoveable ?? false) {
      _selectPiece(tappedPiece!, position);
      return false;
    } else if (isEmpty && currentSelectedPiece != null) {
      return _tryMove(context, currentSelectedPiece!, position);
    }
    return false;
  }

  bool _tryMove(BuildContext context, int from, int to) {
    bool moveSuceeded = false;
    final piece = boardIndicators.piecesIndicator[from];

    if (piece?.isBobail ?? false) {
      game.bobailPreview = to;
    } else {
      final result = game.makeMove(from, to);
      if (!result.isOk) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(result.error?.message ?? 'Invalid move'),
            duration: const Duration(seconds: 2),
          ),
        );
      } else {
        moveSuceeded = true;
      }
      game.bobailPreview = null;
    }

    refreshBoard();
    return moveSuceeded;
  }

  void _selectPiece(PieceIndicator piece, int position) {
    if (piece.isBobail) {
      _handleBobailSelection(position);
    } else {
      _handleStandardSelection(position);
    }
    notifyListeners();
  }

  void _handleStandardSelection(int position) {
    if (currentSelectedPiece == position) {
      refreshBoard();
    } else {
      highlightedPiecesIndex =
          boardIndicators.piecesIndicator[position]?.movablePreview ?? {};
      currentSelectedPiece = position;
      boardIndicators = game.getBoardIndicators();
    }
  }

  void _handleBobailSelection(int position) {
    if (currentSelectedPiece == position) {
      game.bobailPreview = null;
      refreshBoard();
    } else {
      currentSelectedPiece = position;
      highlightedPiecesIndex =
          boardIndicators.piecesIndicator[position]?.movablePreview ?? {};
      boardIndicators = game.getBoardIndicators();
    }
  }

  void refreshBoard() {
    currentSelectedPiece = null;
    highlightedPiecesIndex.clear();
    boardIndicators = game.getBoardIndicators();
    notifyListeners();
  }
}
