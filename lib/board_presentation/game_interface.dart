import 'package:bobail_mobile/board_model/bobail_game.dart';
import 'package:bobail_mobile/board_model/visualization/move_error_response.dart';
import 'package:bobail_mobile/board_presentation/board_indicators.dart';
import 'package:bobail_mobile/bobail_ai/ai_utils/movement.dart';

class GameInterface {
  List<Movement> movements = [];
  BobailGame bobailGame;
  int? bobailDestionationPosition;

  GameInterface.bobail() : bobailGame = BobailGame();

  MoveResult makeMove(int from, int to) {
    var bobail = bobailGame.bobail.positionIndex;
    var result = bobailGame.move(from, to, bobailPreview);

    if (result.isOk) {
      movements.add(
        Movement(
          bobail,
          bobailGame.lastBobailMove ??
              12, //In the first move the bobail does not move. This is easier to handle.
          bobailGame.lastPieceMoveFrom,
          bobailGame.lastPieceMoveTo,
        ),
      );
    }
    return result;
  }

  MoveResult makeCompleteMove(int from, int to, int bobailDestination) {
    var bobail = bobailGame.bobail.positionIndex;
    var result = bobailGame.move(from, to, bobailDestination);

    if (result.isOk) {
      movements.add(
        Movement(
          bobail,
          bobailGame.lastBobailMove,
          bobailGame.lastPieceMoveFrom,
          bobailGame.lastPieceMoveTo,
        ),
      );
    }
    return result;
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
