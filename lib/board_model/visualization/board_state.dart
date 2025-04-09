import 'package:bobail_mobile/board_model/visualization/piece_view_model.dart';

class BoardState {
  final int turn;
  final List<PieceViewModel?> boardViewModel;
  final bool isWhiteTurn;

  BoardState(this.turn, this.boardViewModel, this.isWhiteTurn);

  bool get isFirstTurn => turn == 0;

  bool isThatPieceTurn(PieceViewModel piece) {
    return (piece.isBobail) ||
        (piece.isWhite && isWhiteTurn) ||
        (piece.isBlack && !isWhiteTurn);
  }

  @override
  String toString() {
    String isWhite = isWhiteTurn ? "White's turn" : "Black's turn";
    final boardStr = boardViewModel
        .asMap()
        .entries
        .map(
          (entry) =>
              '[${entry.key.toString().padLeft(2, '0')}]: ${entry.value?.toString() ?? "empty"}',
        )
        .join('\n');

    return '''
Turn: $turn
$isWhite
Board:
$boardStr
''';
  }
}
