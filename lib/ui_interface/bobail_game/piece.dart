import 'package:bobail_mobile/board_presentation/piece_indicators.dart';
import 'package:flutter/material.dart';

class Piece extends StatefulWidget {
  final PieceIndicator? piece;
  final bool isHighligthed;
  final bool isBobailPreview;
  final bool isSelected;

  const Piece({
    super.key,
    required this.piece,
    required this.isHighligthed,
    required this.isBobailPreview,
    required this.isSelected,
  });

  @override
  State<Piece> createState() => _PieceState();
}

class _PieceState extends State<Piece> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool get shouldAnimate =>
      ((widget.piece?.isMoveable ?? false) && !widget.isSelected);

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.05,
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
    final piece = widget.piece;
    final Color? baseColor = _correctColor(piece);
    final borderColor = _borderColor();

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: baseColor,
          border: Border.all(color: borderColor, width: 3),
          boxShadow: [
            if (widget.isBobailPreview)
              BoxShadow(
                color: Colors.lightGreenAccent.withAlpha(230),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            if (!widget.isBobailPreview && widget.isHighligthed)
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

    if (widget.isBobailPreview) return Colors.greenAccent;
    if (isEmpty) return Colors.brown[300];
    if (piece.isWhite) return Colors.white;
    if (piece.isBlack) return Colors.black;
    if (((piece.isBobail) && !piece.hasBobailMoved)) {
      return Colors.greenAccent;
    }
    return Colors.brown[300];
  }

  Color _borderColor() {
    if (widget.isBobailPreview) return Colors.lightBlueAccent;
    if (widget.isHighligthed) return Colors.pink;
    return Colors.black;
  }
}
