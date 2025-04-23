import 'package:bobail_mobile/ui_interface/bobail_game/board_controller/board_controller.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/board_controller/selectable_board_logic.dart';
import 'package:flutter/material.dart';

class LocalBoardController extends BoardController with SelectableBoardLogic {
  LocalBoardController(super.boardSettings);

  @override
  bool isWhiteOnTheTop() {
    return !boardSettings.isReversedView || boardIndicators.turn.isOdd;
  }

  @override
  int getCorrectIndex(index) => _correctedIndex(index);

  @override
  void handleTap(BuildContext context, int position) {
    final actualPos = _correctedIndex(position);
    final tappedPiece = boardIndicators.piecesIndicator[actualPos];

    handlePieceTap(context, actualPos, tappedPiece);
  }

  int _correctedIndex(int index) {
    if (!boardSettings.isReversedView) return index;
    return boardIndicators.turn.isEven ? (25 - 1 - index) : index;
  }

  @override
  bool get blockBoard => false;
}
