class AlphaBeta {
  double alpha;
  double beta;
  AlphaBeta(this.alpha, this.beta);
  AlphaBeta.copy(AlphaBeta alphaBeta)
    : alpha = alphaBeta.alpha,
      beta = alphaBeta.beta;
}
