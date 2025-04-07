import 'package:bobail_mobile/board_model/board.dart';
import 'package:bobail_mobile/board_model/board_movement_rules/movement_manager.dart';
import 'package:bobail_mobile/board_model/board_movement_rules/position.dart';
import 'package:bobail_mobile/board_model/pieces/piece.dart';
import 'package:bobail_mobile/board_model/pieces/piece_kind.dart';

class Ball extends Piece {
  static final Movementmanager mc = Movementmanager.instance;

  Ball(Board board, int position, PieceKind pieceKind)
    : super(board, pieceKind, mc.getPosition(position)) {
    if (pieceKind == PieceKind.bobail) {
      throw ArgumentError("Ball cannot be of type Bobail");
    }
  }

  @override
  void bind() {
    if (pieceKind == PieceKind.white) {
      board.addWhitePiece(this);
    } else if (pieceKind == PieceKind.black) {
      board.addBlackPiece(this);
    } else {
      throw Exception('Invalid kind for Ball');
    }
  }

  bool _isFirstAvailable(List<int> positions) {
    return positions.isNotEmpty && board.isAvailable(positions.first);
  }

  void _setNewPositionTo(int newPosition) {
    Position newCurrentPosition = mc.getPosition(newPosition);
    super.board.notifyPieceMovement(this, super.positionIndex, newPosition);
    super.position = newCurrentPosition;
  }

  @override
  void move(int newPosition) {
    List<int> positions = mc.getLine(super.positionIndex, newPosition);

    if (_isFirstAvailable(positions)) {
      int lastPosition =
          positions.takeWhile((position) => board.isAvailable(position)).last;
      _setNewPositionTo(lastPosition);
    }
  }
}
