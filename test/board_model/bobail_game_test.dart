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

    test("Bobail does not interfer with normal piece movement", () {
      final result = game.move(2, 7, null);
      // W  W  v   W  W
      // 5  6  W   8  9
      // 10 11 Bo 13 14
      // 15 16 17 18 19
      // B  B  B  B  B

      final result2 = game.move(22, 18, 8);
      // W  W  2   W  W
      // 5  6  W   Bo  9
      // 10 11 12 13  B
      // 15 16 17 18 19
      // B  B  22  B  B

      final result3 = game.move(3, 8, 9);
      // W  W  2   3  W
      // 5  6  W   8  Bo
      // 10 11 Bo 13 14
      // 15 16 17 W  19
      // B  B  B  B  B

      expect(result.isOk, true);
      expect(result2.isOk, true);
      expect(result3.isOk, true);
    });

    test('Ball movement to pieces beyond adjacent', () {
      final result = game.move(0, 15, null);
      expect(result.isOk, true);
      expect(game.showBoardState().boardViewModel[15], isNotNull);
      expect(game.showBoardState().boardViewModel[10], isNull);
    });

    test('Ball movement to invalid position should give an error', () {
      final result = game.move(0, 18, null);
      expect(result.isOk, false);
      expect(result.error, equals(MoveErrorResponse.invalidMovement));
    });

    test(
      'Complex movement where piece can only move where bobail has left',
      () {
        final normalMove = game.move(4, 19, null);
        final normalMove2 = game.move(20, 15, 6);
        final difficultMove = game.move(0, 6, 7);

        expect(normalMove.isOk, true);
        expect(normalMove2.isOk, true);
        expect(difficultMove.isOk, true);
      },
    );
  });
}
