import 'dart:math';

import 'package:bobail_mobile/bobail_ai/ai_utils/alpha_beta.dart';
import 'package:bobail_mobile/bobail_ai/ai_utils/constants.dart';
import 'package:bobail_mobile/bobail_ai/ai_utils/evaluation_result.dart';
import 'package:bobail_mobile/bobail_ai/ai_utils/movement.dart';
import 'package:bobail_mobile/bobail_ai/board_position.dart';
import 'package:bobail_mobile/bobail_ai/logger/log.dart';
import 'package:flutter/foundation.dart';

class BobailAi {
  static final Log log = kDebugMode ? BobailAiLogger() : SilentLogger();
  final BoardPosition trackingBoard;
  int callsToMinimax = 0;
  int visitedSkipped = 0;
  final Set<int> visitedStates = {};

  BobailAi(this.trackingBoard);

  BobailAi.base()
    : trackingBoard = BoardPosition(
        bobailPosition,
        whitePositions.toSet(),
        blackPositions.toSet(),
        true,
      );

  Movement getBestMove(int depth) {
    log.i(
      'Init getBestMove with depth = $depth and its the whites turn: ${trackingBoard.isWhitesTurn} ',
    );
    if (trackingBoard.isTerminalState()) {
      throw StateError('The board has already reached a final state');
    }
    callsToMinimax = visitedSkipped = 0;
    visitedStates.clear();

    final result = alphaBetaMinimax(
      depth,
      AlphaBeta(double.negativeInfinity, double.infinity),
    );
    assert(result.move != null);
    log.i(
      'Bobail ai choose this move ${result.move} | ${result.score} with $callsToMinimax calls to minimax and $visitedSkipped skipped states',
    );
    return result.move!;
  }

  EvaluationResult alphaBetaMinimax(int depth, AlphaBeta alphaBeta) {
    callsToMinimax++;

    var key = trackingBoard.boardHashValue;
    var moves = trackingBoard.availableMoves();
    var initialValue =
        trackingBoard.isWhitesTurn ? double.negativeInfinity : double.infinity;

    if (visitedStates.contains(key) || depth == 0) {
      visitedSkipped++;
      return EvaluationResult(trackingBoard.evaluate(), null);
    }

    if (trackingBoard.isTerminalState() || moves.isEmpty) {
      return EvaluationResult(initialValue, null);
    }

    double bestScore = initialValue;
    Movement? bestMove;

    for (Movement move in moves) {
      var whitesTurn = trackingBoard.isWhitesTurn;
      var eval = _simulateAndEvaluateMove(move, depth, alphaBeta).score;

      if ((whitesTurn && eval > bestScore) ||
          (!whitesTurn && eval < bestScore)) {
        bestMove = move;
        bestScore = eval;
      }

      if (whitesTurn) {
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
  ) {
    trackingBoard.advance(move);
    var key = trackingBoard.boardHashValue;
    var eval = alphaBetaMinimax(depth - 1, AlphaBeta.copy(alphaBeta));
    trackingBoard.undo(move);
    visitedStates.add(key);
    return eval;
  }
}
