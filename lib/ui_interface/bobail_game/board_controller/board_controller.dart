import 'package:bobail_mobile/board_presentation/board_indicators.dart';
import 'package:bobail_mobile/board_presentation/game_interface.dart';
import 'package:bobail_mobile/ui_interface/settings/board_settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class BoardState {
  final GameInterface game;
  final Set<int> highlightedPiecesIndex;
  final BoardIndicators boardIndicators;
  final int? currentSelectedPiece;
  final bool isWhitePlayer;
  final bool isAiTurn;

  BoardState({
    required this.game,
    required this.highlightedPiecesIndex,
    required this.boardIndicators,
    required this.currentSelectedPiece,
    this.isWhitePlayer = true,
    this.isAiTurn = false,
  });

  BoardState copyWith({
    GameInterface? game,
    Set<int>? highlightedPiecesIndex,
    BoardIndicators? boardIndicators,
    int? currentSelectedPiece,
    bool? isWhitePlayer,
    bool? isAiTurn,
  }) {
    return BoardState(
      game: game ?? this.game,
      highlightedPiecesIndex:
          highlightedPiecesIndex ?? this.highlightedPiecesIndex,
      boardIndicators: boardIndicators ?? this.boardIndicators,
      currentSelectedPiece: currentSelectedPiece ?? this.currentSelectedPiece,
      isWhitePlayer: isWhitePlayer ?? this.isWhitePlayer,
      isAiTurn: isAiTurn ?? this.isAiTurn,
    );
  }
}

abstract class BoardController extends Notifier<BoardState> {
  BoardSettings get boardSettings => ref.read(boardSettingsProvider);

  @override
  BoardState build() {
    final game = GameInterface.bobail();
    return BoardState(
      game: game,
      highlightedPiecesIndex: <int>{},
      boardIndicators: game.getBoardIndicators(),
      currentSelectedPiece: null,
    );
  }

  int? get lastPieceMoveFrom => state.game.bobailGame.lastPieceMoveFrom;
  String get playerTurnName => state.game.bobailPlayerTurn;
  bool get isGameOver => state.game.isGameOver();
  String get winner => state.game.winner();

  bool isWhiteOnTheTop() => true;
  int getCorrectIndex(index) => index;

  void restartGame() {
    final newGame = GameInterface.bobail();
    newGame.resetGame();
    state = state.copyWith(
      game: newGame,
      boardIndicators: newGame.getBoardIndicators(),
      highlightedPiecesIndex: {},
      currentSelectedPiece: null,
    );
  }

  // Abstract members to be implemented by subclasses
  bool get blockBoard;
  void handleTap(BuildContext context, int position);
}
