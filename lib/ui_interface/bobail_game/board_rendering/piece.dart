import 'package:bobail_mobile/board_presentation/piece_indicators.dart';
import 'package:bobail_mobile/ui_interface/bobail_game/utils/position_information.dart';
import 'package:flutter/material.dart';

class Piece extends StatefulWidget {
  final PieceIndicator? piece;
  final PositionInformation renderInfo;

  const Piece({super.key, required this.piece, required this.renderInfo});

  @override
  State<Piece> createState() => _PieceState();
}

class _PieceState extends State<Piece> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool get shouldAnimate =>
      ((widget.piece?.isMoveable ?? false) && !widget.renderInfo.isSelected);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    if (shouldAnimate) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant Piece oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (shouldAnimate && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!shouldAnimate && _controller.isAnimating) {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final piece = widget.piece;
    final Color baseColor = _correctColor(piece) ?? theme.primaryColor;
    final borderColor = _borderColor();

    final isPreview = widget.renderInfo.isBobailPreview;
    final isHighlight = widget.renderInfo.isHighligthed;
    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: baseColor,
          border: Border.all(color: borderColor, width: 3),
          boxShadow: [
            if (shouldAnimate)
              BoxShadow(
                color: Colors.amberAccent.shade700,
                blurRadius: 3,
                spreadRadius: 1,
              ),
            if (!isPreview && isHighlight)
              BoxShadow(
                color: Colors.pinkAccent.withAlpha(153),
                blurRadius: 24,
                spreadRadius: 5,
              ),
          ],
        ),
      ),
    );
  }

  Color? _correctColor(PieceIndicator? piece) {
    final bool isEmpty =
        piece == null || (piece.isBobail && piece.hasBobailMoved);

    if (widget.renderInfo.isBobailPreview) return Colors.greenAccent;
    if (isEmpty) return null;
    if (piece.isWhite) return Colors.white;
    if (piece.isBlack) return Colors.black;
    if (((piece.isBobail) && !piece.hasBobailMoved)) {
      return Colors.greenAccent;
    }
    return null;
  }

  Color _borderColor() {
    if (widget.renderInfo.isHighligthed) return Colors.pink;
    return Colors.black;
  }
}
