import 'package:bobail_mobile/board_model/board_movement_rules/movement_manager.dart';

class MovesCalculator {
  static final Movementmanager _mm = Movementmanager.instance;

  static int getPieceTargetInDirection(
    int currentPosition,
    int direction,
    int bobailPosition,
    Set<int> occupied,
  ) {
    return _mm
        .getLine(currentPosition, direction)
        .takeWhile(
          (position) => !_isOccupied(position, bobailPosition, occupied),
        )
        .last;
  }

  static Iterable<int> getBobailFreeAdjacentSquares(
    int bobailPosition,
    Set<int> occupied,
  ) => _mm
      .getAdjacent(bobailPosition)
      .where((position) => !_isOccupied(position, bobailPosition, occupied));

  static Iterable<int> getFreeAdjacentSquares(
    int position,
    int bobailPosition,
    Set<int> occupied,
  ) => _mm
      .getAdjacent(position)
      .where((position) => !_isOccupied(position, bobailPosition, occupied));

  static bool _isOccupied(int position, int bobailPosition, Set<int> occupied) {
    return bobailPosition == position || occupied.contains(position);
  }
}
