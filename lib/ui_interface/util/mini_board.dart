import 'package:flutter/material.dart';

class MiniBoard extends StatelessWidget {
  final int rowSize;

  const MiniBoard({super.key, this.rowSize = 5});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'bobail-board',
      child: Material(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: EdgeInsets.all(6),
          width: 205,
          height: 210,
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.zero,
            itemCount: rowSize * rowSize,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: rowSize,
              childAspectRatio: 1,
              crossAxisSpacing: 3,
              mainAxisSpacing: 3,
            ),
            itemBuilder: (context, index) {
              return _Piece(index: index);
            },
          ),
        ),
      ),
    );
  }
}

class _Piece extends StatelessWidget {
  final int index;
  const _Piece({required this.index});

  @override
  Widget build(BuildContext context) {
    const white = Colors.white;
    const black = Colors.black;
    const bobail = Colors.green;
    const colorMap = {
      0: white,
      1: white,
      2: white,
      3: white,
      4: white,
      12: bobail,
      20: black,
      21: black,
      22: black,
      23: black,
      24: black,
    };

    Color color = colorMap[index] ?? Colors.grey;

    return CircleAvatar(backgroundColor: color, radius: 2);
  }
}
