import 'dart:math';

import 'package:bobail_mobile/bobail_ai/board_position.dart';
import 'package:bobail_mobile/bobail_ai/logger/log.dart';
import 'package:bobail_mobile/bobail_ai/movement.dart';
import 'package:flutter/foundation.dart';

class BobailAi {
  final BoardPosition trackingBoard;
  final Log log = kDebugMode ? BobailAiLogger() : SilentLogger();
  int callsToMinimax = 0;

  BobailAi(this.trackingBoard);

  BobailAi.base()
    : trackingBoard = BoardPosition(
        12,
        {0, 1, 2, 3, 4},
        {20, 21, 22, 23, 24},
        true,
      );

  Movement getBestMove(int depth, bool isWhitesTurn) {
    log.i(
      'Init getBestMove with depth = $depth and its the whites turn: $isWhitesTurn ',
    );
    log.i(
      '${trackingBoard.availableMoves().map((e) => "${e.bobailFrom} -> ${e.bobailTo}\n").toList()}',
    );
    if (trackingBoard.isTerminalState()) {
      throw StateError('The board has already reached a final state');
    }
    callsToMinimax = 0;
    double bestScore = isWhitesTurn ? double.negativeInfinity : double.infinity;
    Movement? bestMove;

    alphaBetaMinimax(
      depth,
      double.negativeInfinity,
      double.infinity,
      isWhitesTurn,
      depth,
      (move, score) {
        //Best way to separate get best move logic with the what score has this move logic.
        if ((isWhitesTurn && score > bestScore) ||
            (!isWhitesTurn && score < bestScore)) {
          bestScore = score;
          bestMove = move;
          if ((isWhitesTurn && bestScore == double.infinity) ||
              (!isWhitesTurn && bestScore == double.negativeInfinity)) {
            return;
          }
        }
      },
    );

    assert(bestMove != null);
    log.i(
      'Bobail ai choose this move $bestMove with $callsToMinimax calls to minimax',
    );
    return bestMove!;
  }

  alphaBetaMinimax(
    int depth,
    double alpha,
    double beta,
    bool isWhitesTurn,
    int originalDepth, [
    void Function(Movement, double)? onRootMoveEvaluated,
  ]) {
    callsToMinimax++;
    if (depth == 0 || trackingBoard.isTerminalState()) {
      return trackingBoard.evaluate();
    }

    if (isWhitesTurn) {
      double bestScore = double.negativeInfinity;
      for (Movement move in trackingBoard.availableMoves()) {
        var eval = _simulateAndEvaluateMove(
          move,
          depth,
          alpha,
          beta,
          isWhitesTurn,
          originalDepth,
        );
        _savePositionIfRoot(
          onRootMoveEvaluated,
          depth,
          originalDepth,
          move,
          eval,
        );

        bestScore = max(bestScore, eval);
        alpha = max(alpha, eval);
        if (beta <= alpha || eval == double.infinity) {
          break;
        }
      }
      return bestScore;
    } else {
      double bestScore = double.infinity;
      for (Movement move in trackingBoard.availableMoves()) {
        trackingBoard.advance(move);
        var eval = _simulateAndEvaluateMove(
          move,
          depth,
          alpha,
          beta,
          isWhitesTurn,
          originalDepth,
        );
        _savePositionIfRoot(
          onRootMoveEvaluated,
          depth,
          originalDepth,
          move,
          eval,
        );

        bestScore = min(bestScore, eval);
        beta = min(beta, eval);
        if (beta >= alpha || eval == double.negativeInfinity) {
          break;
        }
      }
      return bestScore;
    }
  }

  void _savePositionIfRoot(
    void Function(Movement, double)? onRootMoveEvaluated,
    int depth,
    int originalDepth,
    Movement move,
    eval,
  ) {
    if (onRootMoveEvaluated != null && depth == originalDepth) {
      onRootMoveEvaluated(move, eval);
    }
  }

  _simulateAndEvaluateMove(
    Movement move,
    int depth,
    double alpha,
    double beta,
    bool isWhitesTurn,
    int originalDepth,
  ) {
    trackingBoard.advance(move);
    var eval = alphaBetaMinimax(
      depth - 1,
      alpha,
      beta,
      !isWhitesTurn,
      originalDepth,
    );
    trackingBoard.undo(move);
    return eval;
  }
}

class EvaluationResult {
  final double score;
  final Movement? move;
  EvaluationResult(this.score, this.move);
}
