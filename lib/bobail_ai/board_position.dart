import 'package:bobail_mobile/bobail_ai/board_hasher.dart';
import 'package:bobail_mobile/bobail_ai/constants.dart';
import 'package:bobail_mobile/bobail_ai/logger/log.dart';
import 'package:bobail_mobile/bobail_ai/movement.dart';
import 'package:bobail_mobile/bobail_ai/utils.dart/moves_calculator.dart';

class BoardPosition {
  static final BoardHasher boardHasher = BoardHasher();
  static BobailAiLogger log = BobailAiLogger();
  int bobail;
  final Set<int> whitePieces;
  final Set<int> blackPieces;
  final Set<int> occupiedPositions = <int>{};
  int boardHashValue;

  BoardPosition(this.bobail, this.whitePieces, this.blackPieces)
    : boardHashValue = boardHasher.computeHash(
        bobailPosition: bobail,
        whitePieces: whitePieces,
        blackPieces: blackPieces,
      ) {
    occupiedPositions.add(bobail);
    occupiedPositions.addAll(whitePieces);
    occupiedPositions.addAll(blackPieces);
  }

  bool isTerminalState() {
    var winningPosition = {...whitePositions, ...blackPositions};
    return winningPosition.contains(bobail) ||
        MovesCalculator.getBobailFreeAdjacentSquares(
          bobail,
          occupiedPositions,
        ).isEmpty;
  }

  double evaluate() {
    double bobailScoreCalculator(int bobailPosition) =>
        ((bobailPosition ~/ rowsInBoard) * -5) + 10;
    const double bobailWeight = 3;
    const double mobilityWeight = 1.0;

    final double bobailScore = bobailScoreCalculator(bobail);
    final int whiteMobility = _countAdjacentAvailable(whitePieces);
    final int blackMobility = _countAdjacentAvailable(blackPieces);
    final double mobilityScore =
        (whiteMobility - blackMobility) * mobilityWeight;

    return bobailScore * bobailWeight + mobilityScore;
  }

  int _countAdjacentAvailable(Set<int> collection) {
    return collection.fold(
      0,
      (value, position) =>
          value +
          MovesCalculator.getBobailFreeAdjacentSquares(
            position,
            occupiedPositions,
          ).length,
    );
  }

  Iterable<Movement> availableMoves(bool isWhitesTurn) sync* {
    var pieces = isWhitesTurn ? whitePieces.toList() : blackPieces.toList();
    List<int> bobailMoves = _getBobailMovesSorted(isWhitesTurn);

    for (int newBobailPosition in bobailMoves) {
      for (int pieceCurrentPosition in pieces) {
        var adjacentDirections = MovesCalculator.getFreeAdjacentSquares(
          pieceCurrentPosition,
          newBobailPosition,
          {...whitePieces, ...blackPieces},
        );
        for (var direction in adjacentDirections) {
          var finalPosition = MovesCalculator.getPieceTargetInDirection(
            pieceCurrentPosition,
            direction,
            newBobailPosition,
            {...whitePieces, ...blackPieces},
          );
          yield Movement(
            bobail,
            newBobailPosition,
            pieceCurrentPosition,
            finalPosition,
          );
        }
      }
    }
  }

  List<int> _getBobailMovesSorted(bool isWhitesTurn) {
    int bobailSort(a, b) => _getValueOfBobailPosition(
      a,
      isWhitesTurn,
    ).compareTo(_getValueOfBobailPosition(b, isWhitesTurn));

    var bobailMoves =
        MovesCalculator.getBobailFreeAdjacentSquares(
          bobail,
          occupiedPositions,
        ).toList();
    if (isWhitesTurn) {
      bobailMoves.sort(bobailSort);
    } else {
      bobailMoves.sort((a, b) => bobailSort(b, a));
    }
    return bobailMoves;
  }

  double _getValueOfBobailPosition(int position, bool isWhitesTurn) {
    if (whiteWon(bobailPosition)) return -100000;
    if (blackWon(bobailPosition)) return 100000;

    double moveability = _evalBobailMoveability(isWhitesTurn);
    if (moveability != 0) return moveability;

    return (position ~/ rowsInBoard) * 5 - 10;
  }

  double _evalBobailMoveability(bool isWhitesTurn) {
    var isAbleToMove =
        MovesCalculator.getBobailFreeAdjacentSquares(
          bobail,
          occupiedPositions,
        ).isNotEmpty;
    if (isAbleToMove) return 0;
    // If its whites turn and manages to block the bobail, it automatically wins.
    if (isWhitesTurn) {
      return -1000000;
    } else {
      return 1000000;
    }
  }

  void advance(Movement movement, bool isWhitesTurn) {
    _updateHashForAdvance(movement, isWhitesTurn);

    occupiedPositions.remove(movement.pieceFrom);
    occupiedPositions.remove(movement.bobailFrom);
    bobail = movement.bobailTo;
    occupiedPositions.add(movement.bobailTo);
    occupiedPositions.add(movement.pieceTo);

    if (whitePieces.remove(movement.pieceFrom)) {
      whitePieces.add(movement.pieceTo);
    } else if (blackPieces.remove(movement.pieceFrom)) {
      blackPieces.add(movement.pieceTo);
    }
  }

  void undo(Movement movement, bool isWhitesTurn) {
    _updateHashForUndo(movement, isWhitesTurn);
    occupiedPositions.remove(movement.pieceTo);
    occupiedPositions.remove(movement.bobailTo);
    occupiedPositions.add(movement.pieceFrom);
    occupiedPositions.add(movement.bobailFrom);

    bobail = movement.bobailFrom;

    if (whitePieces.remove(movement.pieceTo)) {
      whitePieces.add(movement.pieceFrom);
    } else if (blackPieces.remove(movement.pieceTo)) {
      blackPieces.add(movement.pieceFrom);
    } else {
      throw Exception('The intended piece to move was not there');
    }
  }

  void _updateHashForAdvance(Movement movement, bool isWhitesTurn) {
    final kind = isWhitesTurn ? PieceKind.white : PieceKind.black;

    // undo moves
    boardHashValue ^= boardHasher.pieceHash(
      PieceKind.bobail,
      movement.bobailFrom,
    );
    boardHashValue ^= boardHasher.pieceHash(kind, movement.pieceFrom);

    // apply new moves
    boardHashValue ^= boardHasher.pieceHash(
      PieceKind.bobail,
      movement.bobailTo,
    );
    boardHashValue ^= boardHasher.pieceHash(kind, movement.pieceTo);
  }

  void _updateHashForUndo(Movement movement, bool isWhitesTurn) {
    final pieceKind = isWhitesTurn ? PieceKind.white : PieceKind.black;

    // undo move
    boardHashValue ^= boardHasher.pieceHash(
      PieceKind.bobail,
      movement.bobailTo,
    );
    boardHashValue ^= boardHasher.pieceHash(pieceKind, movement.pieceTo);

    // Reverse hash update for the removed positions
    boardHashValue ^= boardHasher.pieceHash(
      PieceKind.bobail,
      movement.bobailFrom,
    );
    boardHashValue ^= boardHasher.pieceHash(pieceKind, movement.pieceFrom);
  }
}
