import 'package:bobail_mobile/bobail_ai/ai_utils/movement.dart';
import 'package:bobail_mobile/bobail_ai/board_position.dart';
import 'package:bobail_mobile/bobail_ai/bobail_ai.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group("Bobail Ai", () {
    test('Bobail Ai should be able to identify finishing moves', () {
      final BoardPosition oneTurnToWinPosition = BoardPosition(
        16,
        {0, 1, 2, 3, 4},
        {20, 15, 22, 23, 24},
        false,
      );
      final bobailAi = BobailAi(oneTurnToWinPosition);
      final suggestedMovement = bobailAi.getBestMove(1);

      expect(suggestedMovement.bobailTo, 21);
      expect(suggestedMovement.bobailFrom, 16);
    });

    test(
      'Bobail Ai should be able to identify finishing move by blocking the bobail',
      () {
        final BoardPosition oneTurnToWinPosition = BoardPosition(
          11,
          {0, 1, 6, 3, 4},
          {10, 17, 22, 23, 24},
          false,
        );
        final bobailAi = BobailAi(oneTurnToWinPosition);
        final suggestedMovement = bobailAi.getBestMove(1);

        expect(suggestedMovement.bobailTo, 5);
        expect(suggestedMovement.bobailFrom, 11);
        expect(suggestedMovement.pieceFrom, 17);
        expect(suggestedMovement.pieceTo, 11);
      },
    );

    test('Test playing the game', () {
      final boardPosition = BoardPosition(
        12,
        {0, 1, 2, 3, 4},
        {20, 21, 22, 23, 24},
        false,
      );
      final bobailAi = BobailAi(boardPosition);
      // Log the initial board state
      //  0  1  2  3  4
      //  5  6  7  8  9
      // 10 11 12 13 14
      // 15 16 17 18 19
      // 20 21 22 23 24

      bobailAi.getBestMove(9);
    });

    test('second game should be with a fresh state', () {
      final BobailAi first = BobailAi.base();

      // Make a move in the first game
      first.trackingBoard.advance(Movement(12, 18, 1, 8));

      // Create a second BobailAi instance (representing a new game)
      final BobailAi second = BobailAi.base();

      // Verify that the occupied positions are different between the two games
      expect(
        first.trackingBoard.occupiedPositions,
        isNot(equals(second.trackingBoard.occupiedPositions)),
      );

      // Verify that the current turn is different (should be reset in second game)
      expect(
        first.trackingBoard.isWhitesTurn,
        isNot(equals(second.trackingBoard.isWhitesTurn)),
      );

      // Verify that the board hash value is different (indicating a new state)
      expect(
        first.trackingBoard.boardHashValue,
        isNot(equals(second.trackingBoard.boardHashValue)),
      );
    });
  });
}
