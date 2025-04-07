import 'package:bobail_mobile/board_model/board_movement_rules/position.dart';

class Movementmanager {
  late final Map<int, List<int>> adyacent;
  late final Map<int, Map<int, List<int>>> reachablePosition;
  late final Map<int, Position> allPositions;

  Movementmanager._internal() {
    adyacent = {};
    reachablePosition = {};
    allPositions = {};

    for (int i = 0; i < Position.boardSize; i++) {
      final Position p = Position.fromLinear(i);
      allPositions[i] = p;
      var list = p.getAdjacent();
      adyacent[i] = list.map((adj) => adj.position).toList();

      reachablePosition[i] = {};
      for (var adyacentPosition in list) {
        reachablePosition[i]![adyacentPosition.position] = p.getLineWith(
          adyacentPosition,
        );
      }
    }
  }

  static final Movementmanager _instance = Movementmanager._internal();
  static Movementmanager get instance => _instance;

  Position getPosition(int position) {
    final found = allPositions[position];
    if (found == null) {
      throw Exception("Position $position not found in allPositions");
    }
    return found;
  }

  List<int> getAdjacent(int position) {
    return adyacent[position] ?? [];
  }

  List<int> getLine(int position, int direction) {
    return reachablePosition[position]?[direction] ?? [];
  }
}
