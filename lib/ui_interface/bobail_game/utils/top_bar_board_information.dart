import 'package:bobail_mobile/ui_interface/bobail_game/board_controller.dart';
import 'package:flutter/material.dart';

class TopBarBoardInformation extends StatelessWidget {
  const TopBarBoardInformation({
    super.key,
    required this.controller,
    required this.boardSize,
  });
  final double boardSize;
  final tobBarTextStyle = const TextStyle(
    fontWeight: FontWeight.bold,
    fontSize: 16,
  );
  final BoardController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: boardSize,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: Colors.amber,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('${controller.playerTurnName} turn', style: tobBarTextStyle),
          Text(
            'Turn ${controller.boardIndicators.turn}',
            style: tobBarTextStyle,
          ),
        ],
      ),
    );
  }
}
