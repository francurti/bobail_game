import 'package:bobail_mobile/bobail_ai/board_position.dart';
import 'package:bobail_mobile/bobail_ai/movement.dart'; // assuming you have this
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Zobrist hash is consistent for identical board positions', () {
    final position1 = BoardPosition(12, {1, 2, 3}, {20, 21});
    final position2 = BoardPosition(12, {1, 2, 3}, {20, 21});

    expect(position1.boardHashValue, equals(position2.boardHashValue));
  });

  test('Zobrist hash changes when pieces move', () {
    final original = BoardPosition(12, {1, 2, 3}, {20, 21});
    final movedWhite = BoardPosition(12, {1, 2, 4}, {20, 21}); // moved 3 -> 4
    final movedBobail = BoardPosition(13, {1, 2, 3}, {20, 21});

    expect(original.boardHashValue, isNot(equals(movedWhite.boardHashValue)));
    expect(original.boardHashValue, isNot(equals(movedBobail.boardHashValue)));
  });

  test('Zobrist hash updates correctly after advance and undo', () {
    final position = BoardPosition(12, {1, 2, 3}, {20, 21});
    final originalHash = position.boardHashValue;

    final move = Movement.named(
      pieceFrom: 3,
      pieceTo: 4,
      bobailFrom: 12,
      bobailTo: 13,
    );

    position.advance(move, true); // white's turn
    final hashAfterAdvance = position.boardHashValue;
    expect(hashAfterAdvance, isNot(equals(originalHash)));

    position.undo(move, true); // undo white's move
    final hashAfterUndo = position.boardHashValue;
    expect(hashAfterUndo, equals(originalHash));
  });

  test('Zobrist hash handles multiple sequential moves and undos', () {
    final position = BoardPosition(12, {1, 2, 3}, {20, 21});
    final originalHash = position.boardHashValue;

    final move1 = Movement.named(
      pieceFrom: 3,
      pieceTo: 4,
      bobailFrom: 12,
      bobailTo: 13,
    );
    final move2 = Movement.named(
      pieceFrom: 20,
      pieceTo: 19,
      bobailFrom: 13,
      bobailTo: 14,
    );

    position.advance(move1, true); // white move
    final middleHashAdvance = position.boardHashValue;
    position.advance(move2, false); // black move
    final hashAfterMoves = position.boardHashValue;
    expect(hashAfterMoves, isNot(equals(originalHash)));
    position.undo(move2, false);
    final middleHashUndo = position.boardHashValue;
    position.undo(move1, true);
    final hashAfterUndos = position.boardHashValue;
    expect(hashAfterUndos, equals(originalHash));
    expect(middleHashUndo, equals(middleHashAdvance));
  });
}
