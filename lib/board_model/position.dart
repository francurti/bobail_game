class Position implements Comparable<Position> {
  final int x;
  final int y;
  final int linearPosition;

  static const rowSize = 5;

  static _linearPosition(int x, int y) {
    return y * rowSize + x;
  }

  static bool insideBoundary(int x) {
    return x >= 0 && x < rowSize;
  }

  Position.copy(Position pos)
    : x = pos.x,
      y = pos.y,
      linearPosition = pos.linearPosition;

  Position(this.x, this.y) : linearPosition = _linearPosition(x, y);
  Position.fromPoint(this.x, this.y) : linearPosition = _linearPosition(x, y);

  Position.fromLinear(int pos)
    : linearPosition = pos,
      x = pos % rowSize,
      y = pos ~/ rowSize;

  List<int> getLineWith(Position position) {
    int xAxis = position.x.compareTo(x);
    int yAxis = position.y.compareTo(y);

    return getLine(xAxis, yAxis);
  }

  List<int> getLine(int xAxis, int yAxis) {
    List<int> positions = [];
    int x = this.x + xAxis;
    int y = this.y + yAxis;

    while (insideBoundary(x) && insideBoundary(y)) {
      positions.add(_linearPosition(x, y));
      x = x + xAxis;
      y = y + yAxis;
    }

    return positions;
  }

  Set<Position> getAdjacent() {
    Set<Position> adyacentPosition = <Position>{};

    for (int i = -1; i <= 1; i++) {
      for (int j = -1; j <= 1; j++) {
        if (!(i == 0 && j == 0)) {
          int x = this.x + i;
          int y = this.y + j;
          if (insideBoundary(x) && insideBoundary(y)) {
            adyacentPosition.add(Position.fromPoint(x, y));
          }
        }
      }
    }

    return adyacentPosition;
  }

  int getPosition() {
    return linearPosition;
  }

  @override
  int compareTo(Position other) {
    return linearPosition - other.linearPosition;
  }

  @override
  bool operator ==(Object other) {
    return other is Position && other.linearPosition == linearPosition;
  }

  @override
  int get hashCode => linearPosition.hashCode;

  @override
  String toString() => '($linearPosition)';
}
