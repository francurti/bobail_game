import 'package:bobail_mobile/bobail_ai/board_position.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Board position", () {
    test('Board initial position should be equal for both', () {
      final BoardPosition boardPosition = BoardPosition(
        12,
        {0, 1, 2, 3, 4},
        {20, 21, 22, 23, 24},
        true,
      );

      expect(boardPosition.evaluate(), 0);
    });

    test('Bobail on ending square should give infinite or -infinite', () {
      final BoardPosition blackWinning = BoardPosition(
        0,
        {0, 1, 2, 3, 4},
        {20, 21, 22, 23, 24},
        false,
      );
      final BoardPosition whiteWinning = BoardPosition(
        22,
        {0, 1, 2, 3, 4},
        {20, 21, 22, 23, 24},
        true,
      );

      expect(blackWinning.evaluate(), double.negativeInfinity);
      expect(whiteWinning.evaluate(), double.infinity);
    });

    test(
      'Given one move for white to win. The first move should be the winning one',
      () {
        final BoardPosition oneTurnToWinPosition = BoardPosition(
          16,
          {0, 1, 2, 3, 4},
          {20, 15, 22, 23, 24},
          true,
        );
        var move = oneTurnToWinPosition.availableMoves().first;
        expect(move.bobailFrom, 16);
        expect(move.bobailTo, 21);
      },
    );

    test(
      'Given one move for black to win. The last move should be the winning one',
      () {
        final BoardPosition oneTurnToWinPosition = BoardPosition(
          5,
          {12, 1, 2, 3, 4},
          {20, 21, 22, 23, 24},
          true,
        );
        var move = oneTurnToWinPosition.availableMoves().last;
        expect(move.bobailFrom, 5);
        expect(move.bobailTo, 0);
      },
    );
  });
}
