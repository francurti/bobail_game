import 'package:bobail_mobile/board_model/board_movement_rules/position.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Position', () {
    test('constructor sets correct linear position', () {
      final p = Position.fromPoint(2, 3); // should be 3 * 5 + 2 = 17
      expect(p.linearPosition, equals(17));

      final q = Position.fromPoint(0, 0);
      expect(q.linearPosition, equals(0));

      final d = Position.fromPoint(4, 4);
      expect(d.linearPosition, equals(24));
    });

    test('fromLinear sets correct x and y', () {
      final p = Position.fromLinear(17);
      expect(p.x, equals(2));
      expect(p.y, equals(3));
    });

    test('equality works based on linear position', () {
      final p1 = Position.fromPoint(2, 3);
      final p2 = Position.fromLinear(17);
      expect(p1, equals(p2));
    });

    test('hashCode is consistent with equality', () {
      final p1 = Position.fromPoint(2, 3);
      final p2 = Position.fromLinear(17);
      expect(p1.hashCode, equals(p2.hashCode));
    });

    test('adjacent positions for corner (0,0)', () {
      final corner = Position(0, 0);
      final expected = {Position(0, 1), Position(1, 0), Position(1, 1)};
      expect(corner.getAdjacent(), equals(expected));
    });

    test('adjacent positions for middle (2,2)', () {
      final middle = Position(2, 2);
      final expected = {
        Position(1, 1),
        Position(1, 2),
        Position(1, 3),
        Position(2, 1),
        Position(2, 3),
        Position(3, 1),
        Position(3, 2),
        Position(3, 3),
      };

      expect(middle.getAdjacent(), equals(expected));
    });
  });
}
