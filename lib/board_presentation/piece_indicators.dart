import 'package:bobail_mobile/board_model/visualization/piece_view_model.dart';

class PieceIndicator {
  late final PieceViewModel _pieceViewModel;
  late final bool isMoveable;

  PieceIndicator(this._pieceViewModel, this.isMoveable);

  @override
  String toString() {
    return "isMoveAble: ${isMoveable}, position: ${_pieceViewModel.position}";
  }

  bool get isBobail => _pieceViewModel.isBobail;
  bool get isWhite => _pieceViewModel.isWhite;
  bool get isBlack => _pieceViewModel.isBlack;
  Set<int> get movablePreview => _pieceViewModel.movablePreview;
}
