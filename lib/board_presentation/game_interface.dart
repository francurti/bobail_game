import 'package:bobail_mobile/board_model/bobail_game.dart';
import 'package:bobail_mobile/board_model/visualization/move_error_response.dart';
import 'package:bobail_mobile/board_presentation/board_indicators.dart';

class GameInterface {
  final BobailGame bobailGame;
  int? bobailDestionationPosition;

  GameInterface.bobail() : bobailGame = BobailGame();

  MoveResult makeMove(int from, int to) {
    print('making move $from towards $to and bobail moves to $bobailPreview');
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

  int? get bobailPreview => bobailDestionationPosition;
  set bobailPreview(int? to) => bobailDestionationPosition = to;
}
