import 'package:bobail_mobile/board_model/board.dart';
import 'package:bobail_mobile/board_model/board_movement_rules/position.dart';
import 'package:bobail_mobile/board_model/pieces/ball.dart';
import 'package:bobail_mobile/board_model/pieces/piece_kind.dart';
import 'package:flutter_test/flutter_test.dart';

class _TestPiece extends Ball {
  _TestPiece(Board board, PieceKind pieceKind, int position)
    : super(board, position, pieceKind);

  @override
  void bind() {}

  @override
  int? move(int newPosition) {
    position = Position.fromLinear(newPosition);
    return newPosition;
  }
}

void main() {
  group('Piece', () {
    late Board board;
    late _TestPiece piece;
    late _TestPiece piece2;

    setUp(() {
      board = Board();
      piece = _TestPiece(board, PieceKind.white, 5);
      piece2 = _TestPiece(board, PieceKind.white, 6);
      board.addWhitePiece(piece);
      board.addWhitePiece(piece2);
    });

    test('can move function works as expected', () {
      expect(piece.canMove(0), isTrue);
      expect(piece.canMove(6), isFalse);
    });

    test('move updates position correctly', () {
      expect(piece.positionIndex, 5);
      piece.move(6);
      expect(piece.positionIndex, 6);
    });
  });
}
