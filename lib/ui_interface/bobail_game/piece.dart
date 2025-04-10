import 'package:bobail_mobile/board_presentation/piece_indicators.dart';
import 'package:flutter/material.dart';

class Piece extends StatefulWidget {
  final PieceIndicator? piece;
  final bool isHighligthed;
  final bool isBobailPreview;
  final int row;
  final bool isSelected;
  final bool isScaled;

  const Piece({
    super.key,
    required this.piece,
    required this.isHighligthed,
    required this.isBobailPreview,
    required this.row,
    this.isScaled = false,
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
    final scale = 1.0 + ((widget.row) / 4) * 0.2; // row 0 = 1.0, row 4 = 1.2
    final bool isEmpty = widget.piece == null;
    final Color? baseColor = _correctColor(widget.piece);
    final bool isPreview = widget.isBobailPreview;

    final borderColor =
        isPreview
            ? Colors.lightGreenAccent
            : widget.isHighligthed
            ? Colors.pink
            : Colors.black;

    return Transform.scale(
      scale:
          isEmpty
              ? 0.7
              : widget.isScaled
              ? scale
              : 1,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color:
                isPreview ? Colors.lightGreenAccent.withAlpha(204) : baseColor,
            border: Border.all(color: borderColor, width: 3),
            boxShadow: [
              if (isPreview)
                BoxShadow(
                  color: Colors.lightGreenAccent.withAlpha(230),
                  blurRadius: 24,
                  spreadRadius: 5,
                  offset: Offset(0, 0),
                ),
              if (!isPreview && widget.isHighligthed)
                BoxShadow(
                  color: Colors.pinkAccent.withAlpha(153),
                  blurRadius: 24,
                  spreadRadius: 5,
                ),
            ],
            gradient:
                !isEmpty && !isPreview
                    ? RadialGradient(
                      colors: [
                        baseColor?.withAlpha(230) ?? Colors.green,
                        baseColor?.withAlpha(153) ?? Colors.green,
                      ],
                      center: Alignment.topLeft,
                      radius: 1.2,
                    )
                    : null,
          ),
          child:
              isPreview
                  ? const Center(
                    child: Icon(Icons.flag, color: Colors.black, size: 28),
                  )
                  : null,
        ),
      ),
    );
  }

  Color? _correctColor(PieceIndicator? piece) {
    if (piece == null) return Colors.brown[300];
    if (piece.isWhite) return Colors.white;
    if (piece.isBlack) return Colors.black;
    if (piece.isBobail) return Colors.greenAccent;
    return Colors.grey;
  }
}
