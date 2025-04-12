import 'package:bobail_mobile/board_model/board.dart';
import 'package:bobail_mobile/board_model/board_movement_rules/movement_manager.dart';
import 'package:bobail_mobile/board_model/board_movement_rules/position.dart';
import 'package:bobail_mobile/board_model/pieces/piece.dart';
import 'package:bobail_mobile/board_model/pieces/piece_kind.dart';

class Bobail extends Piece {
  static const Set<int> winningPositions = {0, 1, 2, 3, 4, 20, 21, 22, 23, 24};
  static final mc = Movementmanager.instance;

  Bobail(Board board)
    : super(board, PieceKind.bobail, mc.getPosition(Position.middle));

  bool isAbleToMove() {
    return super.getAdjacentAvailable().isNotEmpty;
  }

  bool isInDefinitePosition() {
    return winningPositions.contains(super.positionIndex);
  }

  @override
  void move(int newPosition) {
    bool isMoveAvailable = super.getAdjacentAvailable().any(
      (position) => newPosition == position,
    );

    if (isMoveAvailable) {
      super.savePosition();
      Position newCurrentPosition = mc.getPosition(newPosition);
      super.board.notifyPieceMovement(this, super.positionIndex, newPosition);
      super.position = newCurrentPosition;
    }
  }

  @override
  void bind() {
    board.assignBobail(this);
  }
}
