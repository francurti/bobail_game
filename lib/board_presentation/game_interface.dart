import 'package:bobail_mobile/board_model/bobail_game.dart';
import 'package:bobail_mobile/board_model/visualization/move_error_response.dart';
import 'package:bobail_mobile/board_presentation/board_indicators.dart';

class GameInterface {
  BobailGame bobailGame;
  int? bobailDestionationPosition;

  GameInterface.bobail() : bobailGame = BobailGame();

  MoveResult makeMove(int from, int to) {
    return bobailGame.move(from, to, bobailPreview);
  }

  BoardIndicators getBoardIndicators() {
    return BoardIndicators(
      bobailGame.showBoardState(),
      bobailDestionationPosition,
    );
  }

  bool isGameOver() {
    return bobailGame.isGameOver();
  }

  String winner() {
    try {
      return bobailGame.getWinner();
    } catch (e) {
      return 'no one yet';
    }
  }

  void resetGame() {
    bobailGame = BobailGame();
    bobailDestionationPosition = null;
  }

  int? get bobailPreview => bobailDestionationPosition;
  set bobailPreview(int? to) => bobailDestionationPosition = to;

  String get bobailPlayerTurn => bobailGame.isWhiteTurn ? "White's" : "Black's";
}
