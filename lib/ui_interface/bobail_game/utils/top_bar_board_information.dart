import 'package:bobail_mobile/ui_interface/bobail_game/board_controller/board_controller.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/board_controller/local_board_controller.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

class TopBarBoardInformation extends ConsumerWidget {
  const TopBarBoardInformation({
    super.key,
    required this.controller,
    required this.boardSize,
  });
  final double boardSize;
  final BoardController controller;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(localBoardControllerProvider);

    final theme = Theme.of(context);
    final tobBarTextStyle = const TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.white,
    );

    return Container(
      width: boardSize,
      height: 30,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
        color: theme.primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('${controller.playerTurnName} turn', style: tobBarTextStyle),
          Text('Turn ${state.boardIndicators.turn}', style: tobBarTextStyle),
        ],
      ),
    );
  }
}
