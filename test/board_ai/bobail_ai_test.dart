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
        true,
      );

      final bobailAi = BobailAi(oneTurnToWinPosition);
      final suggestedMovement = bobailAi.getBestMove(1, true);

      expect(suggestedMovement.bobailTo, 21);
      expect(suggestedMovement.bobailFrom, 16);
    });

    test('Bobail first move of the board', () {
      final bobailAi = BobailAi.base();

      final suggestedMovement = bobailAi.getBestMove(1, true);
    });
  });
}
