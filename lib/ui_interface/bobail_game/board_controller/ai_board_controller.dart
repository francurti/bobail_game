import 'package:bobail_mobile/board_presentation/piece_indicators.dart';
import 'package:bobail_mobile/bobail_ai/isolate_implementation/isolate_ai_manager.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/board_controller/board_controller.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/board_controller/selectable_board_logic.dart';
import 'package:flutter/material.dart';

class AiBoardController extends BoardController with SelectableBoardLogic {
  AiBoardController(super.boardSettings, this.isWhitePlayer) {
    // Set up the AI turn after start() completes.
    isolateAiManager.start().then((value) {
      isAiTurn = !isWhitePlayer;

      if (isAiTurn) {
        makeFirstMove();
      }
    });
  }

  static const int depth = 6;
  final bool isWhitePlayer;
  final IsolateAiManager isolateAiManager = IsolateAiManager();
  bool isAiTurn = false;

  @override
  Future<void> handleTap(BuildContext context, int position) async {
    if (isAiTurn) return;

    final tappedPiece = boardIndicators.piecesIndicator[position];

    if (_canSelectPiece(tappedPiece) || _canMoveTo(position)) {
      bool madeMove = handlePieceTap(context, position, tappedPiece);

      if (madeMove) {
        isAiTurn = true;
        notifyListeners();
        await _makeAiMove();
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

    isolateAiManager.advanceBoard(lastMove);
    // Find a response for the board;
    var result = await isolateAiManager.getBestMove(depth);
    //Make complete move based on the result
    game.makeCompleteMove(result.pieceFrom, result.pieceTo, result.bobailTo);

    isolateAiManager.advanceBoard(result);
    isAiTurn = false;
    refreshBoard();
  }

  Future<void> makeFirstMove() async {
    await Future.delayed(Duration(milliseconds: 250));
    var result = await isolateAiManager.getBestMove(depth);
    game.makeMove(result.pieceFrom, result.pieceTo);
    isolateAiManager.advanceBoard(result);
    isAiTurn = false;
    refreshBoard();
  }

  @override
  void restartGame() {
    isolateAiManager.restart().then((_) => super.restartGame());
  }

  @override
  bool get blockBoard => isAiTurn;
}
