import 'package:bobail_mobile/board_model/board_movement_rules/movement_manager.dart';
import 'package:bobail_mobile/board_model/visualization/piece_view_model.dart';
import 'package:bobail_mobile/board_presentation/board_indicators.dart';

class PieceIndicator {
  static final Movementmanager mc = Movementmanager.instance;
  late final PieceViewModel _pieceViewModel;
  late final bool isMoveable;
  late final bool hasBobailMoved;
  late Set<int> movablePreview;

  PieceIndicator(
    BoardIndicators boardIndicators,
    this._pieceViewModel,
    this.isMoveable,
  ) : hasBobailMoved = boardIndicators.bobailMovePreselected {
    movablePreview = _getMovablePreview(boardIndicators);
  }

  bool get isBobail => _pieceViewModel.isBobail;
  bool get isWhite => _pieceViewModel.isWhite;
  bool get isBlack => _pieceViewModel.isBlack;

  Set<int> _getMovablePreview(BoardIndicators boardIndicators) {
    var currentPosition = _pieceViewModel.position;

    Set<int> allAdjacentMoves = mc.getAdjacent(currentPosition).toSet();
    if (isBobail) {
      return _getAvailablePositionsForBobail(
        allAdjacentMoves,
        boardIndicators.boardState.boardViewModel,
      );
    }
    return _getAvailablePositionsForPiece(allAdjacentMoves, boardIndicators);
  }

  Set<int> _getAvailablePositionsForBobail(
    Set<int> allAdjacentMoves,
    List<PieceViewModel?> boardViewModel,
  ) {
    return allAdjacentMoves
        .where((position) => boardViewModel[position] == null)
        .toSet();
  }

  Set<int> _getAvailablePositionsForPiece(
    Set<int> allAdjacentMoves,
    BoardIndicators boardIndicators,
  ) {
    var currentPosition = _pieceViewModel.position;

    var allDirections = allAdjacentMoves
        .map((direction) => mc.getLine(currentPosition, direction))
        .map((e) => _getAvailablePositionsForLine(e, boardIndicators))
        .fold<Set<int>>(<int>{}, (acc, element) => acc..addAll(element));

    return allDirections;
  }

  Set<int> _getAvailablePositionsForLine(
    List<int> positions,
    BoardIndicators boardIndicators,
  ) {
    var boardViewModel = boardIndicators.boardState.boardViewModel;
    var currentBobailPosition =
        boardIndicators.bobailDestionationPosition ?? -1;
    var lastPosition =
        positions
            .takeWhile(
              (position) => _positionIsAvailable(
                boardViewModel[position],
                position,
                currentBobailPosition,
              ),
            )
            .lastOrNull;
    return lastPosition != null ? {lastPosition} : {};
  }

  bool _positionIsAvailable(
    PieceViewModel? piece,
    int position,
    int currentBobailPosition,
  ) {
    return (piece == null || piece.isBobail && currentBobailPosition != -1) &&
        position != currentBobailPosition;
  }
}
