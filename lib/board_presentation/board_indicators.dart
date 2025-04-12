import 'package:bobail_mobile/board_model/visualization/board_state.dart';
import 'package:bobail_mobile/board_model/visualization/piece_view_model.dart';
import 'package:bobail_mobile/board_presentation/piece_indicators.dart';

class BoardIndicators {
  final BoardState boardState;
  int? bobailDestionationPosition;

  BoardIndicators(this.boardState, this.bobailDestionationPosition);

  bool get bobailMovePreselected => (bobailDestionationPosition != null);
  int get turn => boardState.turn;

  bool _isBobailMoveable(PieceViewModel piece) {
    return !boardState.isFirstTurn;
  }

  bool _isBallMoveable(PieceViewModel piece) {
    return (boardState.isFirstTurn || bobailMovePreselected) &&
        boardState.isThatPieceTurn(piece);
  }

  bool _isMoveable(PieceViewModel piece) {
    if (piece.isBobail) {
      return _isBobailMoveable(piece);
    }
    return _isBallMoveable(piece);
  }

  PieceIndicator? _assignPieceIndicator(PieceViewModel? piece) {
    if (piece == null) {
      return null;
    }
    if (piece.isBobail && bobailMovePreselected) {
      return PieceIndicator(this, piece, false);
    }
    return PieceIndicator(this, piece, _isMoveable(piece));
  }

  List<PieceIndicator?> get piecesIndicator =>
      boardState.boardViewModel
          .map((piece) => _assignPieceIndicator(piece))
          .toList();
}
