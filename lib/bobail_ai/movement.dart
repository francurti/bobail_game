class Movement {
  final int bobailTo;
  final int bobailFrom;
  final int pieceTo;
  final int pieceFrom;

  Movement(this.bobailFrom, this.bobailTo, this.pieceFrom, this.pieceTo);

  @override
  String toString() {
    return "Bobail ($bobailFrom -> $bobailTo) Piece ($pieceFrom -> $pieceTo)";
  }
}
