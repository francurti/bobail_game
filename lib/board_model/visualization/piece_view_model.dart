import 'package:bobail_mobile/board_model/pieces/bobail.dart';
import 'package:bobail_mobile/board_model/pieces/piece.dart';
import 'package:bobail_mobile/board_model/pieces/piece_kind.dart';

class PieceViewModel {
  final PieceKind kind;
  final int position;
  final bool isBobail;
  final Set<int> movablePreview;

  PieceViewModel(Piece piece)
    : kind = piece.pieceKind,
      position = piece.positionIndex,
      isBobail = piece is Bobail && piece.pieceKind == PieceKind.bobail,
      movablePreview = piece.getAvailableMovesPreview();

  @override
  String toString() {
    final type =
        isBobail ? 'Bobail' : (kind == PieceKind.white ? 'White' : 'Black');
    final moves = movablePreview.isEmpty ? 'No moves' : movablePreview.toList();

    return '$type piece at $position → Movable to: $moves';
  }
}
