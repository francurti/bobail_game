import 'package:bobail_mobile/board_presentation/piece_indicators.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/board_controller/board_controller.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/board_controller/selectable_board_logic.dart';
import 'package:flutter/material.dart';

class AiBoardController extends BoardController with SelectableBoardLogic {
  AiBoardController(super.boardSettings, this.isWhitePlayer);

  final bool isWhitePlayer;

  @override
  void handleTap(BuildContext context, int position) {
    final tappedPiece = boardIndicators.piecesIndicator[position];

    if (_canSelectPiece(tappedPiece) || _canMoveTo(position)) {
      handlePieceTap(context, position, tappedPiece);
    }
  }

  bool _canSelectPiece(PieceIndicator? piece) {
    if (piece == null) return false;
    final isCorrectColor =
        (piece.isWhite && isWhitePlayer) || (piece.isBlack && !isWhitePlayer);
    return piece.isMoveable && isCorrectColor;
  }

  bool _canMoveTo(int position) {
    return boardIndicators.piecesIndicator[position] == null &&
        currentSelectedPiece != null;
  }
}
