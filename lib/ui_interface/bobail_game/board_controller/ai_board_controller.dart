import 'package:bobail_mobile/board_presentation/piece_indicators.dart';
import 'package:bobail_mobile/bobail_ai/isolate_implementation/isolate_ai_manager.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/board_controller/board_controller.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/board_controller/selectable_board_logic.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final aiBoardControllerProvider =
    NotifierProvider<AiBoardController, BoardState>(() {
      final controller = AiBoardController();
      controller.init();
      return controller;
    });

class AiBoardController extends BoardController with SelectableBoardLogic {
  static const int depth = 6;
  final IsolateAiManager isolateAiManager = IsolateAiManager();

  @override
  BoardState build() {
    // Initialize the board with the proper player color
    return super.build().copyWith(
      isWhitePlayer: boardSettings.isWhitePlayer,
      isAiTurn: !boardSettings.isWhitePlayer,
    );
  }

  Future<void> init() async {
    await isolateAiManager.start();

    // Make first move if AI is white
    if (state.isAiTurn) {
      await makeFirstMove();
    }
  }

  @override
  Future<void> handleTap(BuildContext context, int position) async {
    if (state.isAiTurn) return;

    final tappedPiece = state.boardIndicators.piecesIndicator[position];

    if (_canSelectPiece(tappedPiece) || _canMoveTo(position)) {
      bool madeMove = handlePieceTap(context, position, tappedPiece);

      if (madeMove) {
        state = state.copyWith(isAiTurn: true);
        await _makeAiMove();
      }
    }
  }

  bool _canSelectPiece(PieceIndicator? piece) {
    if (state.isAiTurn) return false;
    if (piece == null) return false;
    if (piece.isBobail && !piece.isMoveable) return true;

    final isCorrectColor =
        (piece.isWhite && state.isWhitePlayer) ||
        (piece.isBlack && !state.isWhitePlayer) ||
        piece.isBobail;

    return piece.isMoveable && isCorrectColor;
  }

  bool _canMoveTo(int position) {
    final piece = state.boardIndicators.piecesIndicator[position];
    return piece == null && state.currentSelectedPiece != null;
  }

  Future<void> _makeAiMove() async {
    final lastMove = state.game.movements.last;
    isolateAiManager.advanceBoard(lastMove);

    final result = await isolateAiManager.getBestMove(depth);

    state.game.makeCompleteMove(
      result.pieceFrom,
      result.pieceTo,
      result.bobailTo,
    );

    isolateAiManager.advanceBoard(result);
    state = state.copyWith(isAiTurn: false);
    refreshBoard();
  }

  Future<void> makeFirstMove() async {
    await Future.delayed(const Duration(milliseconds: 250));
    final result = await isolateAiManager.getBestMove(depth);

    state.game.makeMove(result.pieceFrom, result.pieceTo);
    isolateAiManager.advanceBoard(result);

    state = state.copyWith(isAiTurn: false);
    refreshBoard();
  }

  @override
  void restartGame() {
    isolateAiManager.restart().then((_) => super.restartGame());
  }

  @override
  bool get blockBoard => state.isAiTurn;
}
