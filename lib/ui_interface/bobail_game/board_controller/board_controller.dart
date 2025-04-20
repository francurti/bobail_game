import 'package:bobail_mobile/board_presentation/board_indicators.dart';
import 'package:bobail_mobile/board_presentation/game_interface.dart';
import 'package:bobail_mobile/board_presentation/piece_indicators.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/piece.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/utils/position_information.dart';
import 'package:bobail_mobile/ui_interface/settings/board_view_settings.dart';
import 'package:flutter/material.dart';

abstract class BoardController extends ChangeNotifier {
  late GameInterface _game;
  final BoardSettings boardSettings;
  late Set<int> highlightedPiecesIndex;
  late BoardIndicators boardIndicators;
  int? currentSelectedPiece;

  BoardController(this.boardSettings) {
    _game = GameInterface.bobail();
    highlightedPiecesIndex = <int>{};
    boardIndicators = _game.getBoardIndicators();
    boardSettings.addListener(() => notifyListeners());
  }

  GameInterface get game => _game;
  String get playerTurnName => _game.bobailPlayerTurn;
  bool get isGameOver => _game.isGameOver();
  String get winner => _game.winner();

  void restartGame() {
    _game.resetGame();
    boardIndicators = _game.getBoardIndicators();
    notifyListeners();
  }

  bool isWhiteOnTheTop() {
    return true;
  }

  void handleTap(BuildContext context, int position);

  itemBuilder(context, index) {
    final int renderIndex = index;
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
