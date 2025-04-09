import 'package:bobail_mobile/board_model/pieces/piece.dart';
import 'package:bobail_mobile/board_model/pieces/piece_kind.dart';

class PieceViewModel {
  final PieceKind _kind;
  final int position;
  final Set<int> movablePreview;

  get isWhite => _kind == PieceKind.white;
  get isBlack => _kind == PieceKind.black;
  get isBobail => _kind == PieceKind.bobail;

  PieceViewModel(Piece piece)
    : _kind = piece.pieceKind,
      position = piece.positionIndex,
      movablePreview = piece.getAvailableMovesPreview();

  @override
  String toString() {
    final type =
        isBobail ? 'Bobail' : (_kind == PieceKind.white ? 'White' : 'Black');
    final moves = movablePreview.isEmpty ? 'No moves' : movablePreview.toList();

    return '$type piece at $position → Movable to: $moves';
  }
}
