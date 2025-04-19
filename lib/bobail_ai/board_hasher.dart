import 'dart:math';

enum PieceKind { white, black, bobail }

class BoardHasher {
  static final Random _rng = Random();

  final Map<PieceKind, List<int>> _zobristTable = {
    for (var kind in PieceKind.values)
      kind: List.generate(25, (_) => _random64()),
  };

  static int _random64() {
    final hi = _rng.nextInt(1 << 32);
    final lo = _rng.nextInt(1 << 32);
    return ((hi << 32) | lo) & 0xFFFFFFFFFFFFFFFF;
  }

  int computeHash({
    required int bobailPosition,
    required Set<int> whitePieces,
    required Set<int> blackPieces,
  }) {
    int hash = 0;

    // Bobail
    hash ^= _zobristTable[PieceKind.bobail]![bobailPosition];

    // White pieces
    for (final pos in whitePieces) {
      hash ^= _zobristTable[PieceKind.white]![pos];
    }

    // Black pieces
    for (final pos in blackPieces) {
      hash ^= _zobristTable[PieceKind.black]![pos];
    }

    return hash;
  }

  int pieceHash(PieceKind kind, int position) => _zobristTable[kind]![position];
}
