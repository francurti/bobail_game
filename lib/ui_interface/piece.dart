import 'package:bobail_mobile/board_model/pieces/piece_kind.dart';
import 'package:bobail_mobile/board_model/visualization/piece_view_model.dart';
import 'package:flutter/material.dart';

class Piece extends StatelessWidget {
  final PieceViewModel? piece;
  const Piece({super.key, required this.piece});

  @override
  Widget build(BuildContext context) {
    final bgColor =
        piece == null ? Colors.grey[300] : _correctColor(piece!.kind);

    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black),
        color: bgColor,
      ),
      child: Center(
        child: Text(
          style: TextStyle(color: Colors.orange),
          piece?.kind.toString() ?? '',
        ),
      ),
    );
  }

  Color _correctColor(PieceKind piece) {
    switch (piece) {
      case PieceKind.bobail:
        return Colors.greenAccent;
      case PieceKind.white:
        return Colors.white;
      case PieceKind.black:
        return Colors.black;
    }
  }
}
