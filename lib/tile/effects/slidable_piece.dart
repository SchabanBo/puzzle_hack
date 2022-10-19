import 'package:flutter/material.dart';

import '../../../../../../models/glass_piece.dart';
import '../../main.dart';

class SlidablePiece extends StatefulWidget {
  final GlassPiece piece;
  final Widget child;
  final int animationDuration;
  final Alignment direction;
  final bool reverse;
  const SlidablePiece(
      {required this.child,
      required this.piece,
      required this.direction,
      required this.animationDuration,
      this.reverse = false,
      Key? key})
      : super(key: key);

  @override
  _SlidablePieceState createState() => _SlidablePieceState();
}

class _SlidablePieceState extends State<SlidablePiece>
    with TickerProviderStateMixin {
  late final controller = _Animations(
    animationDuration: widget.animationDuration,
    piece: widget.piece,
    direction: widget.direction,
    vsync: this,
    reverse: widget.reverse,
  );

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: controller.rotationAnimation,
      child: FadeTransition(
        opacity: controller.fadeAnimation,
        child: SlideTransition(
          position: controller.offsetAnimation,
          child: widget.child,
        ),
      ),
    );
  }
}

class _Animations {
  final int animationDuration;
  final bool reverse;
  final Alignment direction;
  final GlassPiece piece;
  final TickerProvider vsync;

  _Animations({
    required this.animationDuration,
    required this.piece,
    required this.direction,
    required this.vsync,
    this.reverse = false,
  }) {
    _offsetController.forward();
    _fadeController.forward();
    _rotationController.forward();
  }

  // Set Durations
  late final _fadeDuration =
      random.nextInt(animationDuration ~/ 2) + animationDuration ~/ 2;
  late final _offsetDuration = _fadeDuration -
      (random.nextInt(animationDuration ~/ 6) * (reverse ? 1 : -1));

  // Set Controllers
  late final AnimationController _offsetController = AnimationController(
    duration: Duration(milliseconds: _offsetDuration),
    vsync: vsync,
  );
  late final AnimationController _fadeController = AnimationController(
    duration: Duration(milliseconds: _fadeDuration),
    vsync: vsync,
  );
  late final AnimationController _rotationController = AnimationController(
    duration: Duration(milliseconds: _offsetDuration),
    vsync: vsync,
  );

  // Set Tween
  late final Tween<Offset> _offsetTween = reverse
      ? Tween(
          end: Offset.zero,
          begin: Offset(-1 * direction.x, -1 * direction.y),
        )
      : Tween(
          begin: Offset.zero,
          end: Offset(direction.x, direction.y),
        );

  late final Tween<double> _fadeTween =
      reverse ? Tween(begin: 0, end: 1.0) : Tween(begin: 1.0, end: 0.0);

  late final Tween<double> _rotationTween = reverse
      ? Tween(begin: (piece.alignment.x + piece.alignment.y) / 25, end: 0.0)
      : Tween(begin: 0.0, end: (piece.alignment.x + piece.alignment.y) / 25);

  // Set Animations
  late final Animation<Offset> offsetAnimation =
      _offsetTween.animate(CurvedAnimation(
    parent: _offsetController,
    curve: Curves.easeInExpo,
  ));
  late final Animation<double> fadeAnimation =
      _fadeTween.animate(CurvedAnimation(
    parent: _fadeController,
    curve: Curves.easeInExpo,
  ));
  late final Animation<double> rotationAnimation =
      _rotationTween.animate(_rotationController);

  void dispose() {
    _offsetController.dispose();
    _rotationController.dispose();
    _fadeController.dispose();
  }
}
