import 'package:bobail_mobile/board_presentation/piece_indicators.dart';
import 'package:bobail_mobile/bobail_ai/bobail_ai.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/board_controller/board_controller.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/board_controller/selectable_board_logic.dart';
import 'package:flutter/material.dart';

class AiBoardController extends BoardController with SelectableBoardLogic {
  AiBoardController(super.boardSettings, this.isWhitePlayer)
    : isAiTurn = !isWhitePlayer;

  final bool isWhitePlayer;
  BobailAi bobailAi = BobailAi.base();
  bool isAiTurn;

  @override
  Future<void> handleTap(BuildContext context, int position) async {
    if (isAiTurn) return;

    final tappedPiece = boardIndicators.piecesIndicator[position];

    if (_canSelectPiece(tappedPiece) || _canMoveTo(position)) {
      bool madeMove = handlePieceTap(context, position, tappedPiece);

      if (madeMove) {
        isAiTurn = true;
        notifyListeners();
        await Future.delayed(
          Duration(milliseconds: 100),
        ); // give time for spinner
        await _makeAiMove();
        await Future.delayed(
          Duration(milliseconds: 100),
        ); // give time for spinner
        isAiTurn = false;
        refreshBoard();
      }
    }
  }

  bool _canSelectPiece(PieceIndicator? piece) {
    if (isAiTurn) return false;
    if (piece == null) return false;
    if (piece.isBobail && !piece.isMoveable) return true;
    final isCorrectColor =
        (piece.isWhite && isWhitePlayer) ||
        (piece.isBlack && !isWhitePlayer) ||
        piece.isBobail;
    return piece.isMoveable && isCorrectColor;
  }

  bool _canMoveTo(int position) {
    var piece = boardIndicators.piecesIndicator[position];

    return piece == null && currentSelectedPiece != null;
  }

  Future<void> _makeAiMove() async {
    // Inform Ai of player move
    var lastMove = game.movements.last;
    bobailAi.trackingBoard.advance(lastMove);
    // Find a response for the board;
    var result = bobailAi.getBestMove(6);

    //Make complete move based on the result
    game.makeCompleteMove(result.pieceFrom, result.pieceTo, result.bobailTo);

    // if the ai messes it up I dont advance the board
    bobailAi.trackingBoard.advance(result);
  }

  @override
  void restartGame() {
    bobailAi = BobailAi.base();
    super.restartGame();
  }

  @override
  bool get blockBoard => isAiTurn;
}
