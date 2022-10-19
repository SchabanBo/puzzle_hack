import 'package:flutter/material.dart';

import '../../../../../../models/glass_piece.dart';
import '../../main.dart';

bool isWorking = false;

class ExplodablePiece extends StatefulWidget {
  final GlassPiece piece;
  final Widget child;
  final int animationDuration;
  final bool reverse;
  const ExplodablePiece(
      {required this.child,
      required this.piece,
      required this.animationDuration,
      this.reverse = false,
      Key? key})
      : super(key: key);

  @override
  _ExplodablePieceState createState() => _ExplodablePieceState();
}

class _ExplodablePieceState extends State<ExplodablePiece>
    with TickerProviderStateMixin {
  late final controller = _Animations(
    animationDuration: widget.animationDuration,
    piece: widget.piece,
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
      child: ScaleTransition(
        scale: controller.sizeAnimation,
        child: FadeTransition(
          opacity: controller.fadeAnimation,
          child: SlideTransition(
            position: controller.offsetAnimation,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}

class _Animations {
  final int animationDuration;
  final bool reverse;
  final GlassPiece piece;
  final TickerProvider vsync;

  _Animations({
    required this.animationDuration,
    required this.piece,
    required this.vsync,
    this.reverse = false,
  }) {
    _offsetController.forward();
    _fadeController.forward();
    _rotationController.forward();
    _sizeController.forward();
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
  late final AnimationController _sizeController = AnimationController(
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
          end: Offset.zero, begin: Offset(piece.alignment.x, piece.alignment.y))
      : Tween(
          begin: Offset.zero,
          end: Offset(piece.alignment.x, piece.alignment.y));

  late final Tween<double> _fadeTween =
      reverse ? Tween(begin: 0.0, end: 1.0) : Tween(begin: 1.0, end: 0.0);

  late final Tween<double> _rotationTween = reverse
      ? Tween(begin: (piece.alignment.x + piece.alignment.y) / 25, end: 0.0)
      : Tween(begin: 0.0, end: (piece.alignment.x + piece.alignment.y) / 25);

  late final Tween<double> _sizeTween =
      reverse ? Tween(begin: 2, end: 1) : Tween(begin: 1, end: 2);

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
  late final Animation<double> sizeAnimation =
      _sizeTween.animate(_sizeController);

  void dispose() {
    _offsetController.dispose();
    _rotationController.dispose();
    _fadeController.dispose();
    _sizeController.dispose();
  }
}
