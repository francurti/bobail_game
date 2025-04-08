import 'package:bobail_mobile/board_model/visualization/board_state.dart';
import 'package:bobail_mobile/board_model/visualization/move_error_response.dart';

abstract class GameInterface {
  MoveResult makeMove(int from, int to, int? newBobailPosition);

  BoardState showBoardState();

  bool isGameOver();
}
