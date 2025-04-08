import 'package:bobail_mobile/board_model/board_movement_rules/movement_manager.dart';
import 'package:bobail_mobile/board_model/board_movement_rules/position.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MovementManager', () {
    test('movement manager generates the correct amount of items', () {
      final mm = Movementmanager.instance;
      expect(mm.allPositions.keys.length, equals(Position.boardSize));
      expect(mm.getLine(12, 13), isNotEmpty);
    });

    test('This should not exist', () {
      final mm = Movementmanager.instance;
      expect(mm.getLine(Position.boardSize + 5, 0), isEmpty);
    });

    test('Adjacency test, corner adjacents should be 3', () {
      final mm = Movementmanager.instance;
      expect(mm.getAdjacent(0).length, equals(3));
    });
  });
}
