import 'package:bobail_mobile/board_model/board_movement_rules/movement_manager.dart';
import 'package:bobail_mobile/bobail_ai/logger/log.dart';
import 'package:bobail_mobile/bobail_ai/movement.dart';
import 'package:bobail_mobile/bobail_ai/utils.dart/moves_calculator.dart';
import 'package:flutter/foundation.dart';

class BoardPosition {
  final Log log = kDebugMode ? BobailAiLogger() : SilentLogger();

  static const int rows = 5;
  static const int whiteLimit = 5;
  static const int blackLimit = 19;
  final Set<int> whitePieces;
  final Set<int> blackPieces;
  bool isWhitesTurn;
  int bobail;
  final Set<int> occupiedPositions = <int>{};
  final Movementmanager _mm = Movementmanager.instance;

  BoardPosition(
    this.bobail,
    this.whitePieces,
    this.blackPieces,
    this.isWhitesTurn,
  ) {
    occupiedPositions.add(bobail);
    occupiedPositions.addAll(whitePieces);
    occupiedPositions.addAll(blackPieces);
  }

  bool isTerminalState() {
    var winningPosition = {0, 1, 2, 3, 4, 20, 21, 22, 23, 24};
    return winningPosition.contains(bobail) ||
        _getFreeAdjacentSquares(bobail).isEmpty;
  }

  double evaluate() {
    const double bobailWeight = 3;
    const double mobilityWeight = 1.0;

    final double bobailScore = _getValueOfBobailPosition(bobail) * bobailWeight;
    final int whiteMobility = _countAdjacentAvailable(whitePieces);
    final int blackMobility = _countAdjacentAvailable(blackPieces);
    final double mobilityScore =
        (whiteMobility - blackMobility) * mobilityWeight;

    return bobailScore + mobilityScore;
  }

  // value based on position: f(x) = x.5 -10
  // White is positve, black is negative.
  double _getValueOfBobailPosition(int position) {
    if (position < whiteLimit) return double.negativeInfinity;
    if (position > blackLimit) return double.infinity;

    double moveability = _evalBobailMoveability();
    if (moveability != 0) return moveability;

    return (position ~/ rows) * 5 - 10;
  }

  double _evalBobailMoveability() {
    if (_getFreeAdjacentSquares(bobail).isNotEmpty) return 0;
    // If its whites turn and manages to block the bobail, it automatically wins.
    if (isWhitesTurn) {
      return double.infinity;
    } else {
      return double.negativeInfinity;
    }
  }

  int _countAdjacentAvailable(Set<int> collection) {
    return collection.fold(
      0,
      (value, position) => value + _getFreeAdjacentSquares(position).length,
    );
  }

  //TODO this should be inmutable to the class. So that it works every time.
  Iterable<Movement> availableMoves() sync* {
    var pieces = isWhitesTurn ? whitePieces.toList() : blackPieces.toList();
    List<int> bobailMoves = _getBobailMovesSorted(!isWhitesTurn);

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

  List<int> _getBobailMovesSorted(bool? ascendant) {
    var order = ascendant ?? false;
    int bobailSort(a, b) =>
        _getValueOfBobailPosition(a).compareTo(_getValueOfBobailPosition(b));

    var bobailMoves = _getFreeAdjacentSquares(bobail).toList();
    if (order) {
      bobailMoves.sort(bobailSort);
    } else {
      bobailMoves.sort((a, b) => bobailSort(b, a));
    }
    return bobailMoves;
  }

  Iterable<int> _getFreeAdjacentSquares(int position) =>
      _mm.getAdjacent(position).where((position) => !_isOccupied(position));

  bool _isOccupied(int position) {
    return occupiedPositions.contains(position);
  }

  void advance(Movement movement) {
    isWhitesTurn = !isWhitesTurn;

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

  void undo(Movement move) {
    isWhitesTurn = !isWhitesTurn;

    occupiedPositions.remove(move.pieceTo);
    occupiedPositions.remove(move.bobailTo);

    occupiedPositions.add(move.pieceFrom);
    occupiedPositions.add(move.bobailFrom);

    bobail = move.bobailFrom;

    if (whitePieces.remove(move.pieceTo)) {
      whitePieces.add(move.pieceFrom);
    } else if (blackPieces.remove(move.pieceTo)) {
      blackPieces.add(move.pieceFrom);
    } else {
      throw Exception('The intended piece to move was not there');
    }
  }
}
