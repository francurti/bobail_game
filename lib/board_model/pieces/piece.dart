import 'package:bobail_mobile/board_model/board.dart';
import 'package:bobail_mobile/board_model/board_movement_rules/movement_manager.dart';
import 'package:bobail_mobile/board_model/board_movement_rules/position.dart';
import 'package:bobail_mobile/board_model/pieces/piece_kind.dart';

abstract class Piece {
  final Board board;
  final PieceKind pieceKind;
  Position _currentPosition;
  Position _previousPosition;

  Piece(this.board, this.pieceKind, Position position)
    : _currentPosition = position,
      _previousPosition = position {
    bind();
  }

  Set<int> getAvailableMovesPreview();
  void bind();
  void move(int newPosition);

  void undoMove() {
    if (board.allowsToUndoMoveOf(this)) {
      board.notifyPieceMovement(
        this,
        _currentPosition.linearPosition,
        _previousPosition.linearPosition,
      );
      _currentPosition = _previousPosition;
    }
  }

  void savePosition() {
    _previousPosition = _currentPosition;
  }

  Set<int> getAdjacentAvailable() {
    return Movementmanager.instance
        .getAdjacent(_currentPosition.position)
        .where((adyacent) => board.isAvailable(adyacent))
        .toSet();
  }

  bool canMove(int newPosition) {
    return getAdjacentAvailable().contains(newPosition);
  }

  set position(Position position) => _currentPosition = position;
  int get positionIndex => _currentPosition.position;
}
