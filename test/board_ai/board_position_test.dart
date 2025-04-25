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

    test(
      'Given one move for black to win. The first move should be the winning one',
      () {
        final BoardPosition oneTurnToWinPosition = BoardPosition(
          16,
          {0, 1, 2, 3, 4},
          {20, 15, 22, 23, 24},
          false,
        );
        var move = oneTurnToWinPosition.availableMoves().first;
        expect(move.bobailFrom, 16);
        expect(move.bobailTo, 21);
      },
    );

    test(
      'Given one move for white to win. The last move should be the winning one',
      () {
        final BoardPosition oneTurnToWinPosition = BoardPosition(
          5,
          {12, 1, 2, 3, 4},
          {20, 21, 22, 23, 24},
          false,
        );
        var move = oneTurnToWinPosition.availableMoves().last;
        expect(move.bobailFrom, 5);
        expect(move.bobailTo, 0);
      },
    );

    test('Evaluate function should be very negative in this case', () {
      final BoardPosition boardPositionEvaluate = BoardPosition(
        16,
        {0, 1, 2, 3, 4},
        {20, 15, 22, 23, 24},
        true,
      );
      var eval = boardPositionEvaluate.evaluate();
      expect(eval, lessThan(0));
    });

    test('Game is over test', () {
      final BoardPosition wonPosition = BoardPosition(
        0,
        {1, 2, 3, 4, 12},
        {20, 21, 22, 23, 24},
        true,
      );

      final BoardPosition wonPositionBlack = BoardPosition(
        21,
        {1, 2, 3, 4, 12},
        {20, 11, 22, 23, 24},
        true,
      );
      var isTerminalState = wonPosition.isTerminalState();
      var isTerminalState2 = wonPositionBlack.isTerminalState();

      expect(isTerminalState, isTrue);
      expect(isTerminalState2, isTrue);
    });

    test('Game is over test bobail no availablePositions', () {
      final BoardPosition wonPosition = BoardPosition(
        10,
        {5, 6, 11, 4, 12},
        {20, 15, 16, 23, 24},
        true,
      );
      var isTerminalState = wonPosition.isTerminalState();
      expect(isTerminalState, isTrue);
    });
  });
}
