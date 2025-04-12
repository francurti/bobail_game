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

  void _setNewPositionTo(int newPosition) {
    super.savePosition();
    Position newCurrentPosition = mc.getPosition(newPosition);
    super.board.notifyPieceMovement(this, super.positionIndex, newPosition);
    super.position = newCurrentPosition;
  }

  @override
  bool canMove(int newPosition) {
    Set<int> adjacentAvailable = super.getAdjacentAvailable();
    bool isAdjacent = adjacentAvailable.contains(newPosition);

    return isAdjacent || _isPositionReachable(adjacentAvailable, newPosition);
  }

  bool _isPositionReachable(Set<int> adjacent, int newPosition) {
    //From every adjacent, get the reachability line (not calculated with board yet)
    List<int> line = _getReachableLine(adjacent, newPosition);

    return line.isNotEmpty && _availablePositions(line).contains(newPosition);
  }

  @override
  void move(int newPosition) {
    List<int> positions = mc.getLine(super.positionIndex, newPosition);

    if (positions.isEmpty) {
      positions = _getReachableLine(super.getAdjacentAvailable(), newPosition);
    }

    if (_isFirstAvailable(positions)) {
      int lastPosition = _availablePositions(positions).last;
      _setNewPositionTo(lastPosition);
    }
  }

  List<int> _getReachableLine(Set<int> adjacent, int newPosition) {
    //From every adjacent, get the reachability line (not calculated with board yet)
    Iterable<List<int>> positions = adjacent.map(
      (position) => mc.getLine(super.positionIndex, position),
    );

    //Find a line that contains the intended position. If it does not exist returns false
    List<int> line = positions.singleWhere(
      (line) => line.contains(newPosition),
      orElse: () => [],
    );
    return line;
  }

  bool _isFirstAvailable(List<int> positions) {
    return positions.isNotEmpty && board.isAvailable(positions.first);
  }

  Iterable<int> _availablePositions(List<int> positions) {
    return positions.takeWhile((position) => board.isAvailable(position));
  }
}
