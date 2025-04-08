import 'package:bobail_mobile/board_model/board.dart';
import 'package:bobail_mobile/board_model/pieces/bobail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Bobail Piece', () {
    Bobail bobail;

    test('Cannot add two bobails', () {
      Board board = Board();
      bobail = Bobail(board);

      expect(() => Bobail(board), throwsA(isA<Error>()));
    });

    test('Move to definite Position and test result', () {
      Board board = Board();
      bobail = Bobail(board);
      bobail.move(6);
      bobail.move(0);

      expect(bobail.isInDefinitePosition(), isTrue);
    });
  });
}
