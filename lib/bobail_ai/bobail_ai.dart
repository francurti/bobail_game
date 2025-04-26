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
    if (trackingBoard.turn == 0 && trackingBoard.isWhitesTurn) {
      return Movement(12, 12, 1, 16);
    }

    final rootMoves = trackingBoard.availableMoves().toList();
    final nonSuicide =
        rootMoves.where((move) {
          trackingBoard.advance(move);
          // opponent *wins* if bobail is trapped immediately
          final bool oponentWon =
              (trackingBoard.isWhitesTurn
                  ? whiteWon(trackingBoard.bobail)
                  : blackWon(trackingBoard.bobail));
          trackingBoard.undo(move);

          return !oponentWon;
        }).toList();

    // if everything is suicide (rare), fall back to all moves
    final movesToSearch = nonSuicide.isNotEmpty ? nonSuicide : rootMoves;

    callsToMinimax = visitedSkipped = 0;
    visitedStates.clear();

    final result = alphaBetaMinimax(
      depth,
      AlphaBeta(double.negativeInfinity, double.infinity),
      rootMoves: movesToSearch,
    );

    assert(result.move != null);
    log.i(
      'Ai choose this move ${result.move} in $callsToMinimax with $visitedSkipped',
    );
    return result.move!;
  }

  EvaluationResult alphaBetaMinimax(
    int depth,
    AlphaBeta ab, {
    List<Movement>? rootMoves,
  }) {
    callsToMinimax++;

    var key = trackingBoard.boardHashValue;
    var moves = rootMoves ?? trackingBoard.availableMoves();
    var initialValue =
        trackingBoard.isWhitesTurn ? double.negativeInfinity : double.infinity;

    if (visitedStates.contains(key) || depth == 0) {
      visitedSkipped++;
      return EvaluationResult(trackingBoard.evaluate(), null, depth);
    }

    if (moves.isEmpty) {
      return EvaluationResult(initialValue, null, depth);
    }

    if (trackingBoard.isTerminalState()) {
      return EvaluationResult(
        trackingBoard.isWhitesTurn ? double.infinity : double.negativeInfinity,
        null,
        depth,
      );
    }

    double bestScore = initialValue;
    Movement? bestMove;
    int? bestDepth;

    for (Movement move in moves) {
      var whitesTurn = trackingBoard.isWhitesTurn;
      var eval = _simulateAndEvaluateMove(move, depth, ab);
      var evalScore = eval.score;
      var evalDepth = eval.depth;
      if ((whitesTurn && evalScore > bestScore) ||
          (!whitesTurn && evalScore < bestScore)) {
        bestMove = move;
        bestScore = evalScore;
        bestDepth = evalDepth;
      } else if (evalScore == bestScore) {
        if (bestDepth == null ||
            _shouldPreferMoveByDepth(
              whitesTurn,
              evalScore,
              evalDepth,
              bestDepth,
            )) {
          bestMove = move;
          bestDepth = depth;
        }
      }

      if (whitesTurn) {
        ab.alpha = max(ab.alpha, evalScore);
        if (ab.alpha > ab.beta) {
          break;
        }
      } else {
        ab.beta = min(ab.beta, evalScore);
        if (ab.beta < ab.alpha) {
          break;
        }
      }
    }
    return EvaluationResult(bestScore, bestMove, depth);
  }

  bool _shouldPreferMoveByDepth(
    bool whitesTurn,
    double score,
    int evalDepth,
    int bestDepth,
  ) {
    final isWinning = (whitesTurn && score > 0) || (!whitesTurn && score < 0);

    if (isWinning) {
      return evalDepth < bestDepth; // Prefer quicker wins
    } else {
      return evalDepth > bestDepth; // Prefer slower losses
    }
  }

  EvaluationResult _simulateAndEvaluateMove(
    Movement move,
    int depth,
    AlphaBeta alphaBeta,
  ) {
    trackingBoard.advance(move);

    if (trackingBoard.availableMoves().isEmpty) {
      trackingBoard.undo(move);
      return EvaluationResult(
        trackingBoard.isWhitesTurn ? double.infinity : double.negativeInfinity,
        move,
        depth,
      );
    }

    var key = trackingBoard.boardHashValue;
    var eval = alphaBetaMinimax(depth - 1, AlphaBeta.copy(alphaBeta));
    trackingBoard.undo(move);
    visitedStates.add(key);
    return eval;
  }

  void dispose() {
    trackingBoard.dispose();
    visitedStates.clear();
  }
}
