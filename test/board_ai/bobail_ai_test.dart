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

    test('Test playing the game', () {
      final boardPosition = BoardPosition(
        12,
        {15, 1, 2, 3, 4},
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

      bobailAi.getBestMove(4);
    });
  });
}
