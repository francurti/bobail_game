import 'package:bobail_mobile/board_presentation/board_indicators.dart';
import 'package:bobail_mobile/board_presentation/game_interface.dart';
import 'package:bobail_mobile/ui_interface/settings/board_view_settings.dart';
import 'package:flutter/material.dart';

abstract class BoardController extends ChangeNotifier {
  late final GameInterface _game;
  final BoardSettings boardSettings;
  late Set<int> highlightedPiecesIndex;
  late BoardIndicators boardIndicators;
  int? currentSelectedPiece;

  BoardController(this.boardSettings) {
    _game = GameInterface.bobail();
    highlightedPiecesIndex = <int>{};
    boardIndicators = _game.getBoardIndicators();
    boardSettings.addListener(notifyListeners);
  }

  GameInterface get game => _game;
  int? get lastPieceMoveFrom => _game.bobailGame.lastPieceMoveFrom;
  String get playerTurnName => _game.bobailPlayerTurn;
  bool get isGameOver => _game.isGameOver();
  String get winner => _game.winner();
  bool get blockBoard;

  void restartGame() {
    _game.resetGame();
    boardIndicators = _game.getBoardIndicators();
    notifyListeners();
  }

  bool isWhiteOnTheTop() => true;
  int getCorrectIndex(index) => index;

  void handleTap(BuildContext context, int position);
}
