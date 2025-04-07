import 'package:bobail_mobile/board_model/pieces/bobail.dart';
import 'package:bobail_mobile/board_model/pieces/piece.dart';
import 'package:bobail_mobile/board_model/pieces/piece_kind.dart';

class PieceViewModel {
  final PieceKind kind;
  final int position;
  final bool isBobail;

  PieceViewModel(Piece piece)
    : kind = piece.pieceKind,
      position = piece.positionIndex,
      isBobail = piece is Bobail && piece.pieceKind == PieceKind.bobail;
}
