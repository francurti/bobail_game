import 'package:bobail_mobile/board_model/bobail_game.dart';
import 'package:bobail_mobile/board_model/visualization/move_error_response.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('BobailGame', () {
    late BobailGame game;

    setUp(() {
      game = BobailGame();
    });

    test('Initial game state is correct', () {
      final state = game.showBoardState();
      expect(state.turn, 0);
      expect(state.isWhiteTurn, true);
      expect(state.boardViewModel.length, 25); // assuming 25 total positions
    });

    test('Valid first move with bobail in center', () {
      final result = game.move(0, 5, null);
      expect(result.isOk, true);
      expect(game.turnCounter, 1);
      expect(game.isWhiteTurn, false);
    });

    test('InValid first move with bobail', () {
      final result = game.move(0, 5, 12);
      expect(result.isOk, false);
      expect(game.turnCounter, 0);
      expect(game.isWhiteTurn, true);
      expect(result.error, MoveErrorResponse.invalidBobailMovement);
    });

    test('Invalid move with non-adjacent piece', () {
      final result = game.move(0, 14, null); // invalid adjacent index
      expect(result.isOk, false);
      expect(result.error, MoveErrorResponse.invalidMovement);
    });

    test('Cannot move opponent piece', () {
      final result = game.move(
        20,
        21,
        null,
      ); // trying to move black when white turn
      expect(result.isOk, false);
      expect(result.error, MoveErrorResponse.wrongPiece);
    });

    test("Bobail can't move to invalid position", () {
      final result = game.move(0, 1, 99); // assuming 99 is invalid
      expect(result.isOk, false);
      expect(result.error, MoveErrorResponse.invalidBobailMovement);
    });

    test('Bobail Preview', () {
      final gameState = game.showBoardState();
      expect(gameState.isWhiteTurn, true);
      expect(gameState.turn, 0);
      expect(gameState.boardViewModel.length, 25);
      expect(
        gameState.boardViewModel.first?.movablePreview,
        equals({5, 10, 15, 6}),
      );
    });
  });
}
