import 'dart:math';

import 'package:bobail_mobile/bobail_ai/board_position.dart';
import 'package:bobail_mobile/bobail_ai/constants.dart';
import 'package:bobail_mobile/bobail_ai/logger/log.dart';
import 'package:bobail_mobile/bobail_ai/movement.dart';
import 'package:flutter/foundation.dart';

class BobailAi {
  static final Log log = kDebugMode ? BobailAiLogger() : SilentLogger();
  final BoardPosition trackingBoard;
  int callsToMinimax = 0;

  BobailAi(this.trackingBoard);

  BobailAi.base()
    : trackingBoard = BoardPosition(
        bobailPosition,
        whitePositions.toSet(),
        blackPositions.toSet(),
      );

  Movement getBestMove(int depth, bool isWhitesTurn) {
    log.i(
      'Init getBestMove with depth = $depth and its the whites turn: $isWhitesTurn ',
    );
    if (trackingBoard.isTerminalState()) {
      throw StateError('The board has already reached a final state');
    }
    callsToMinimax = 0;

    final result = alphaBetaMinimax(
      depth,
      AlphaBeta(double.negativeInfinity, double.infinity),
      isWhitesTurn,
    );

    assert(result.move != null);
    log.i(
      'Bobail ai choose this move ${result.move} | ${result.score} with $callsToMinimax calls to minimax',
    );
    return result.move!;
  }

  //TODO add hashing to avoid evaluating same position twice.
  EvaluationResult alphaBetaMinimax(
    int depth,
    AlphaBeta alphaBeta,
    bool isWhitesTurn,
  ) {
    callsToMinimax++;

    var moves = trackingBoard.availableMoves(isWhitesTurn).toList();
    var initialValue = isWhitesTurn ? double.negativeInfinity : double.infinity;

    if (trackingBoard.isTerminalState() || moves.isEmpty) {
      return EvaluationResult(initialValue, null);
    }

    if (depth == 0) {
      return EvaluationResult(trackingBoard.evaluate(), null);
    }

    double bestScore = initialValue;
    Movement? bestMove;

    for (Movement move in moves) {
      var eval =
          _simulateAndEvaluateMove(move, depth, alphaBeta, isWhitesTurn).score;

      if ((isWhitesTurn && eval > bestScore) ||
          (!isWhitesTurn && eval < bestScore)) {
        bestMove = move;
        bestScore = eval;
      }

      if (isWhitesTurn) {
        alphaBeta.alpha = max(alphaBeta.alpha, eval);
        if (alphaBeta.alpha >= alphaBeta.beta) {
          break;
        }
      } else {
        alphaBeta.beta = min(alphaBeta.beta, eval);
        if (alphaBeta.beta <= alphaBeta.alpha) {
          break;
        }
      }
    }
    return EvaluationResult(bestScore, bestMove);
  }

  EvaluationResult _simulateAndEvaluateMove(
    Movement move,
    int depth,
    AlphaBeta alphaBeta,
    bool isWhitesTurn,
  ) {
    trackingBoard.advance(move, isWhitesTurn);
    var eval = alphaBetaMinimax(
      depth - 1,
      AlphaBeta.copy(alphaBeta),
      !isWhitesTurn,
    );
    trackingBoard.undo(move, isWhitesTurn);
    return eval;
  }
}

class EvaluationResult {
  final double score;
  final Movement? move;
  EvaluationResult(this.score, this.move);
}

class AlphaBeta {
  double alpha;
  double beta;
  AlphaBeta(this.alpha, this.beta);
  AlphaBeta.copy(AlphaBeta alphaBeta)
    : alpha = alphaBeta.alpha,
      beta = alphaBeta.beta;
}
