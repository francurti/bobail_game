import 'package:bobail_mobile/board_presentation/piece_indicators.dart';
import 'package:flutter/material.dart';

class Piece extends StatefulWidget {
  final PieceIndicator? piece;
  final bool isHighligthed;
  final bool isBobailPreview;
  const Piece({
    super.key,
    required this.piece,
    required this.isHighligthed,
    required this.isBobailPreview,
  });

  @override
  State<Piece> createState() => _PieceState();
}

class _PieceState extends State<Piece> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  bool get isMoveable => widget.piece?.isMoveable ?? false;

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

    if (isMoveable) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant Piece oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (isMoveable && !_controller.isAnimating) {
      _controller.repeat(reverse: true);
    } else if (!isMoveable && _controller.isAnimating) {
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
    final bool isEmpty = widget.piece == null;
    final Color baseColor =
        isEmpty ? Colors.grey[700]! : _correctColor(widget.piece!);
    final bool isPreview = widget.isBobailPreview;

    final borderColor =
        widget.isHighligthed
            ? Colors.pink
            : isPreview
            ? Colors.amber
            : Colors.black;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: isPreview ? Colors.amberAccent.withAlpha(204) : baseColor,
          border: Border.all(color: borderColor, width: 3),
          boxShadow: [
            if (isPreview)
              BoxShadow(
                color: Colors.amberAccent.withAlpha(230),
                blurRadius: 16,
                spreadRadius: 4,
                offset: Offset(0, 0),
              ),
            if (widget.isHighligthed)
              BoxShadow(
                color: Colors.pinkAccent.withAlpha(153),
                blurRadius: 12,
                spreadRadius: 2,
              ),
          ],
          gradient:
              !isEmpty && !isPreview
                  ? RadialGradient(
                    colors: [
                      baseColor.withAlpha(230), // ~0.9
                      baseColor.withAlpha(153), // ~0.6
                    ],
                    center: Alignment.topLeft,
                    radius: 1.2,
                  )
                  : null,
        ),
        width: 64,
        height: 64,
        child:
            isPreview
                ? const Center(
                  child: Icon(Icons.flag, color: Colors.black, size: 28),
                )
                : null,
      ),
    );
  }

  Color _correctColor(PieceIndicator piece) {
    if (piece.isWhite) return Colors.white;
    if (piece.isBlack) return Colors.black;
    if (piece.isBobail) return Colors.greenAccent;
    return Colors.grey;
  }
}
