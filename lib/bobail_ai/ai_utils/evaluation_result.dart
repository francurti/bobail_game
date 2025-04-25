import 'package:bobail_mobile/bobail_ai/ai_utils/movement.dart';

class EvaluationResult {
  final double score;
  final Movement? move;
  final int depth;
  EvaluationResult(this.score, this.move, this.depth);
}
