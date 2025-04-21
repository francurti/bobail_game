import 'package:bobail_mobile/board_presentation/piece_indicators.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/board_rendering/piece.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/utils/position_information.dart';
import 'package:flutter/material.dart';

class BoardTile extends StatelessWidget {
  final int index;
  final PieceIndicator? piece;
  final PositionInformation info;
  final void Function()? onTap;

  const BoardTile({
    super.key,
    required this.index,
    required this.piece,
    required this.info,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Piece(piece: piece, renderInfo: info),
      ),
    );
  }
}
