import 'dart:math';

enum PieceKind { white, black, bobail }

class BoardHasher {
  final int whiteToMoveHash = _random64(); // no longer static

  final Map<PieceKind, List<int>> _zobristTable = {
    for (var kind in PieceKind.values)
      kind: List.generate(25, (_) => _random64()),
  };

  static int _random64() {
    final rng = Random(); // avoid shared RNG
    final hi = rng.nextInt(1 << 32);
    final lo = rng.nextInt(1 << 32);
    return ((hi << 32) | lo) & 0xFFFFFFFFFFFFFFFF;
  }

  int computeHash({
    required int bobailPosition,
    required Set<int> whitePieces,
    required Set<int> blackPieces,
    required bool isWhitesTurn,
  }) {
    int hash = 0;

    hash ^= _zobristTable[PieceKind.bobail]![bobailPosition];

    for (final pos in whitePieces) {
      hash ^= _zobristTable[PieceKind.white]![pos];
    }

    for (final pos in blackPieces) {
      hash ^= _zobristTable[PieceKind.black]![pos];
    }

    if (isWhitesTurn) {
      hash ^= whiteToMoveHash;
    }

    return hash;
  }

  int pieceHash(PieceKind kind, int position) => _zobristTable[kind]![position];
}
