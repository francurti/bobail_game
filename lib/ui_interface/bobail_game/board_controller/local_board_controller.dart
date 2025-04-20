import 'package:bobail_mobile/board_model/visualization/move_error_response.dart';
import 'package:bobail_mobile/board_presentation/piece_indicators.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/board_controller/board_controller.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/piece.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/utils/position_information.dart';
import 'package:flutter/material.dart';

class LocalBoardController extends BoardController {
  LocalBoardController(super.boardSettings);

  @override
  bool isWhiteOnTheTop() {
    if (!boardSettings.isReversedView) return true;

    return boardIndicators.turn.isOdd;
  }

  int _getCorrectIndex(int index) {
    if (!boardSettings.isReversedView) return index;

    return boardIndicators.turn.isEven ? (25 - 1 - index) : index;
  }

  @override
  void handleTap(BuildContext context, int position) {
    final int actualPosition = _getCorrectIndex(position);

    final tappedBoardPosition = boardIndicators.piecesIndicator[actualPosition];

    final isEmptyPosition =
        (tappedBoardPosition == null) ||
        (tappedBoardPosition.isBobail && !tappedBoardPosition.isMoveable);

    if (tappedBoardPosition != null && tappedBoardPosition.isMoveable) {
      _handlePieceSelection(tappedBoardPosition, actualPosition);
    } else if (isEmptyPosition && currentSelectedPiece != null) {
      _handleMove(context, currentSelectedPiece!, actualPosition);
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

  void _registerBoardMovement() {
    highlightedPiecesIndex.clear();
    boardIndicators = game.getBoardIndicators();
  }

  @override
  itemBuilder(context, index) {
    final int renderIndex = _getCorrectIndex(index);
    final PieceIndicator? piece = boardIndicators.piecesIndicator[renderIndex];

    final PositionInformation renderInformation = PositionInformation(
      highlightedPiecesIndex.contains(renderIndex),
      game.bobailPreview == renderIndex,
      currentSelectedPiece == renderIndex,
    );

    return Material(
      child: InkWell(
        onTap: () => handleTap(context, index),
        customBorder: const CircleBorder(),
        child: Piece(piece: piece, renderInformation: renderInformation),
      ),
    );
  }
}
