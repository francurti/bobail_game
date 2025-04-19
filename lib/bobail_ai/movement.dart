class Movement {
  final int bobailTo;
  final int bobailFrom;
  final int pieceTo;
  final int pieceFrom;

  Movement(this.bobailFrom, this.bobailTo, this.pieceFrom, this.pieceTo);
  Movement.named({
    required this.bobailFrom,
    required this.bobailTo,
    required this.pieceFrom,
    required this.pieceTo,
  });

  @override
  String toString() {
    return "Bobail ($bobailFrom -> $bobailTo) Piece ($pieceFrom -> $pieceTo)";
  }
}
