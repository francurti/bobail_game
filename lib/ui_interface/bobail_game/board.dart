import 'package:bobail_mobile/board_presentation/piece_indicators.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/board_controller.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/game_over_overlay.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/utils/top_bar_board_information.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'piece.dart';

class Board extends StatelessWidget {
  const Board({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => BoardController(),
      child: const BoardView(),
    );
  }
}

class BoardView extends StatelessWidget {
  const BoardView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BoardController>();
    const int rowSize = 5;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double screenWidth = MediaQuery.of(context).size.width;
        final double screenHeight = MediaQuery.of(context).size.height;
        final double boardSize = [
          screenWidth * 0.9,
          screenHeight * 0.6,
          1700.0, // Max size on large screens
        ].reduce((a, b) => a < b ? a : b);

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
                height: boardSize,
                child: Stack(
                  children: [
                    AbsorbPointer(
                      absorbing: controller.isGameOver,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFF795548),
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(16),
                            bottomRight: Radius.circular(16),
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 12,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(8),

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
                            itemBuilder: (context, index) {
                              final PieceIndicator? piece =
                                  controller
                                      .boardIndicators
                                      .piecesIndicator[index];

                              return Material(
                                child: InkWell(
                                  onTap:
                                      () =>
                                          controller.handleTap(context, index),
                                  customBorder: const CircleBorder(),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF8D6E63),
                                    ),
                                    child: Piece(
                                      row: index ~/ rowSize,
                                      isScaled: false,
                                      piece: piece,
                                      isBobailPreview:
                                          controller.game.bobailPreview ==
                                          index,
                                      isHighligthed: controller
                                          .highlightedPiecesIndex
                                          .contains(index),
                                      isSelected:
                                          (controller.currentSelectedPiece ==
                                              index),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
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
