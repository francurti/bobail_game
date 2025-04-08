import 'package:bobail_mobile/board_model/pieces/ball.dart';
import 'package:bobail_mobile/board_model/pieces/bobail.dart';
import 'package:bobail_mobile/board_model/pieces/piece.dart';
import 'package:bobail_mobile/board_model/pieces/piece_kind.dart';
import 'package:bobail_mobile/board_model/visualization/piece_view_model.dart';

class Board {
  late final Bobail _bobail;
  final List<Ball> _whitePieces = [];
  final List<Ball> _blackPieces = [];
  final Map<int, Piece> occupiedPositions = {};

  Board();

  bool isAvailable(int position) {
    return !occupiedPositions.containsKey(position);
  }

  Piece? getPieceByPosition(int position) {
    return occupiedPositions[position];
  }

  void assignBobail(Bobail bobail) {
    _bobail = bobail;
    _bindPieceToBoard(bobail);
  }

  void addWhitePiece(Ball piece) {
    _whitePieces.add(piece);
    _bindPieceToBoard(piece);
  }

  void addBlackPiece(Ball piece) {
    _blackPieces.add(piece);
    _bindPieceToBoard(piece);
  }

  void _bindPieceToBoard(Piece piece) {
    occupiedPositions[piece.positionIndex] = piece;
  }

  void notifyPieceMovement(Piece piece, int currentPosition, int newPosition) {
    occupiedPositions.remove(currentPosition);
    occupiedPositions[newPosition] = piece;
  }

  List<PieceViewModel?> getVisualBoard() {
    List<PieceViewModel?> visualBoard = List.filled(25, null);

    visualBoard[_bobail.positionIndex] = PieceViewModel(_bobail);

    for (final piece in _whitePieces.followedBy(_blackPieces)) {
      visualBoard[piece.positionIndex] = PieceViewModel(piece);
    }

    return visualBoard;
  }

  List<PieceViewModel> getVisualPieces(PieceKind kind) {
    switch (kind) {
      case PieceKind.bobail:
        return [PieceViewModel(_bobail)];
      case PieceKind.white:
        return _whitePieces.map((piece) => PieceViewModel(piece)).toList();
      case PieceKind.black:
        return _blackPieces.map((piece) => PieceViewModel(piece)).toList();
    }
  }
}
