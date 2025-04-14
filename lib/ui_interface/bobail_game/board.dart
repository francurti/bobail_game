import 'package:bobail_mobile/ui_interface/bobail_game/board_controller.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/game_over_overlay.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/utils/top_bar_board_information.dart';
import 'package:bobail_mobile/ui_interface/settings/board_view_settings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

const int rowSize = 5;

class Board extends StatelessWidget {
  final BoardViewSettings viewSettings;

  const Board({super.key, required this.viewSettings});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoardController(viewSettings),
      child: const BoardView(),
    );
  }
}

class BoardView extends StatelessWidget {
  const BoardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BoardController>();

    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = MediaQuery.of(context).size.width;
        final double screenHeight = MediaQuery.of(context).size.height;
        final double boardSize = [
          screenWidth * 0.9,
          screenHeight * 0.6,
          1700.0, // Max size on large screens
        ].reduce((a, b) => a < b ? a : b);
        const double kBoardExtraPadding = 16.0;

        return Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TopBarBoardInformation(
                controller: controller,
                boardSize: boardSize,
              ),
              SizedBox(
                width: boardSize,
                height: boardSize + kBoardExtraPadding,
                child: Stack(
                  children: [
                    AbsorbPointer(
                      absorbing: controller.isGameOver,
                      child: Column(
                        children: [
                          Container(
                            height: 8,
                            color:
                                controller.isWhiteOnTheTop()
                                    ? Colors.white
                                    : Colors.black,
                          ),
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black54,
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(4),

                              child: Hero(
                                tag: 'bobail-board',
                                child: GridView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: rowSize * rowSize,
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: rowSize,
                                        childAspectRatio: 1,
                                        crossAxisSpacing: 4,
                                        mainAxisSpacing: 4,
                                      ),
                                  itemBuilder:
                                      (context, index) => controller
                                          .itemBuilder(context, index),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(16),
                                bottomRight: Radius.circular(16),
                              ),
                              color:
                                  !controller.isWhiteOnTheTop()
                                      ? Colors.white
                                      : Colors.black,
                            ),
                            height: 8,
                          ),
                        ],
                      ),
                    ),

                    if (controller.isGameOver)
                      GameOverOverlay(
                        onRestart: controller.restartGame,
                        winner: controller.winner,
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
