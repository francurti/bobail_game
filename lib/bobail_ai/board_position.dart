import 'package:bobail_mobile/bobail_ai/ai_utils/constants.dart';
import 'package:bobail_mobile/bobail_ai/ai_utils/movement.dart';
import 'package:bobail_mobile/bobail_ai/ai_utils/moves_calculator.dart';
import 'package:bobail_mobile/bobail_ai/board_hasher.dart';
import 'package:bobail_mobile/bobail_ai/logger/log.dart';

class BoardPosition {
  static final BoardHasher boardHasher = BoardHasher();
  int boardHashValue;

  static BobailAiLogger log = BobailAiLogger();

  int bobail;
  final Set<int> whitePieces;
  final Set<int> blackPieces;
  final Set<int> occupiedPositions = <int>{};
  late bool isWhitesTurn;

  BoardPosition(
    this.bobail,
    this.whitePieces,
    this.blackPieces,
    this.isWhitesTurn,
  ) : boardHashValue = boardHasher.computeHash(
        bobailPosition: bobail,
        whitePieces: whitePieces,
        blackPieces: blackPieces,
        isWhitesTurn: isWhitesTurn,
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

  Iterable<Movement> availableMoves() sync* {
    List<int> pieces =
        isWhitesTurn
            ? whitePieces.toList(growable: false)
            : blackPieces.toList(growable: false);
    List<int> bobailMoves = _getBobailMovesSorted();
    // TODO: this sort would work on the early game but fall off when pieces are scattered.
    pieces.sort((a, b) => isWhitesTurn ? a.compareTo(b) : b.compareTo(a));

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

  List<int> _getBobailMovesSorted() {
    int compare(a, b) {
      final aValue = _getValueOfBobailPosition(a);
      final bValue = _getValueOfBobailPosition(b);
      return isWhitesTurn ? aValue.compareTo(bValue) : bValue.compareTo(aValue);
    }

    final bobailMoves =
        MovesCalculator.getBobailFreeAdjacentSquares(
            bobail,
            occupiedPositions,
          ).toList()
          ..sort(compare);

    return bobailMoves;
  }

  double _getValueOfBobailPosition(int position) {
    if (_whiteHasWon) return -100000;
    if (_blackHasWon) return 100000;
    if (_bobailIsTrapped) return isWhitesTurn ? -100000 : 100000;

    return (position ~/ rowsInBoard) * 5 - 10;
  }

  late final bool _whiteHasWon = whiteWon(bobailPosition);
  late final bool _blackHasWon = blackWon(bobailPosition);
  late final bool _bobailIsTrapped =
      MovesCalculator.getBobailFreeAdjacentSquares(
        bobail,
        occupiedPositions,
      ).isEmpty;

  void advance(Movement movement) {
    _updateHashForAdvance(movement);

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

    isWhitesTurn = !isWhitesTurn;
  }

  void undo(Movement movement) {
    isWhitesTurn = !isWhitesTurn;
    _updateHashForUndo(movement);
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

  void _updateHashForAdvance(Movement movement) {
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

  void _updateHashForUndo(Movement movement) {
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
