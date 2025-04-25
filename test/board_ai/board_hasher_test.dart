import 'package:bobail_mobile/bobail_ai/ai_utils/movement.dart'; // assuming you have this
import 'package:bobail_mobile/bobail_ai/board_position.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Zobrist hash changes when pieces move', () {
    final original = BoardPosition(12, {1, 2, 3}, {20, 21}, true);
    final movedWhite = BoardPosition(
      12,
      {1, 2, 4},
      {20, 21},
      true,
    ); // moved 3 -> 4
    final movedBobail = BoardPosition(13, {1, 2, 3}, {20, 21}, true);

    expect(original.boardHashValue, isNot(equals(movedWhite.boardHashValue)));
    expect(original.boardHashValue, isNot(equals(movedBobail.boardHashValue)));
  });

  test('Zobrist hash updates correctly after advance and undo', () {
    final position = BoardPosition(12, {1, 2, 3}, {20, 21}, true);
    final originalHash = position.boardHashValue;

    final move = Movement.named(
      pieceFrom: 3,
      pieceTo: 4,
      bobailFrom: 12,
      bobailTo: 13,
    );
    position.advance(move); // white's turn
    final hashAfterAdvance = position.boardHashValue;
    expect(hashAfterAdvance, isNot(equals(originalHash)));

    position.undo(move); // undo white's move
    final hashAfterUndo = position.boardHashValue;
    expect(hashAfterUndo, equals(originalHash));
  });

  test('Zobrist hash handles multiple sequential moves and undos', () {
    final position = BoardPosition(12, {1, 2, 3}, {20, 21}, true);
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

    position.advance(move1); // white move
    final middleHashAdvance = position.boardHashValue;
    position.advance(move2); // black move
    final hashAfterMoves = position.boardHashValue;
    expect(hashAfterMoves, isNot(equals(originalHash)));
    position.undo(move2);
    final middleHashUndo = position.boardHashValue;
    position.undo(move1);
    final hashAfterUndos = position.boardHashValue;
    expect(hashAfterUndos, equals(originalHash));
    expect(middleHashUndo, equals(middleHashAdvance));
  });

  test('Zobrist hash changes with turn', () {
    final whiteTurn = BoardPosition(12, {1, 2, 3}, {20, 21}, true);
    final blackTurn = BoardPosition(12, {1, 2, 3}, {20, 21}, false);

    expect(
      whiteTurn.boardHashValue,
      isNot(equals(blackTurn.boardHashValue)),
      reason:
          'Board state is the same but turn is different, so hashes should differ',
    );
  });
}
