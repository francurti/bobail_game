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
    } else if (isEmpty && state.currentSelectedPiece != null) {
      return _tryMove(context, state.currentSelectedPiece!, position);
    }
    return false;
  }

  bool _tryMove(BuildContext context, int from, int to) {
    bool moveSuceeded = false;
    final piece = state.boardIndicators.piecesIndicator[from];

    if (piece?.isBobail ?? false) {
      state.game.bobailPreview = to;
    } else {
      final result = state.game.makeMove(from, to);
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
      state.game.bobailPreview = null;
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
  }

  void _handleStandardSelection(int position) {
    final currentSelectedPiece = state.currentSelectedPiece;
    final boardIndicators = state.boardIndicators;
    if (currentSelectedPiece == position) {
      refreshBoard();
    } else {
      state = state.copyWith(
        highlightedPiecesIndex:
            boardIndicators.piecesIndicator[position]?.movablePreview ?? {},
        currentSelectedPiece: position,
        boardIndicators: state.game.getBoardIndicators(),
      );
    }
  }

  void _handleBobailSelection(int position) {
    if (state.currentSelectedPiece == position) {
      state.game.bobailPreview = null;
      refreshBoard();
    } else {
      state = state.copyWith(
        currentSelectedPiece: position,
        highlightedPiecesIndex:
            state.boardIndicators.piecesIndicator[position]?.movablePreview ??
            {},
        boardIndicators: state.game.getBoardIndicators(),
      );
    }
  }

  void refreshBoard() {
    state = state.copyWith(
      currentSelectedPiece: null,
      highlightedPiecesIndex: {},
      boardIndicators: state.game.getBoardIndicators(),
    );
  }
}
