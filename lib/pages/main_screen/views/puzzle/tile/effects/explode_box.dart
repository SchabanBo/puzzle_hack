import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../../helpers/random.dart';
import '../../../../../../models/glass_piece.dart';
import '../../../../controllers/main_controller.dart';
import '../../../backgrounds/shadow.dart';
import '../glass_widget.dart';
import 'explodable_piece.dart';
import 'helpers.dart';
import 'slidable_piece.dart';

class ExplodeBox extends StatefulWidget {
  final int value;
  final VoidCallback onTap;
  final VoidCallback onEnd;
  final ExplodeNotifier explode;
  final bool Function() canBreak;
  final Alignment direction;
  final int animationDuration;
  const ExplodeBox({
    required this.value,
    required this.animationDuration,
    required this.direction,
    required this.explode,
    required this.canBreak,
    required this.onTap,
    required this.onEnd,
    Key? key,
  }) : super(key: key);

  @override
  _ExplodeBoxState createState() => _ExplodeBoxState();
}

class _ExplodeBoxState extends State<ExplodeBox> {
  final MainController _mainController = Get.find();
  Offset? breakingPoint;
  @override
  void initState() {
    super.initState();
    widget.explode.addListener(explode);
  }

  void explode() {
    if (isWorking || !widget.canBreak()) return;
    setState(() {
      breakingPoint = Offset.zero;
    });
    widget.onTap();
  }

  @override
  void dispose() {
    widget.explode.removeListener(explode);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerHover: (event) {
        setLight(event.position);
      },
      onPointerDown: (details) {
        if (isWorking || !widget.canBreak()) return;
        setState(() {
          breakingPoint = details.localPosition;
        });
        widget.onTap();
      },
      child: child,
    );
  }

  Widget get child {
    if (breakingPoint == null) {
      return glass();
    }

    isWorking = true;
    Future.delayed(Duration(milliseconds: widget.animationDuration), () {
      widget.onEnd();
    });

    return LayoutBuilder(builder: ((context, constraints) {
      final glassChild = glass(canAnimate: false);
      if (isMobile && Get.find<MainController>().enableLowPerformanceMode) {
        return getPiece(
          GlassPiece(
            const Line(Offset.zero, Offset.zero),
            const Line(Offset.zero, Offset.zero),
            Alignment(random.nextInt(3) - 1, random.nextInt(3) - 1),
          ),
          glassChild,
        );
      }
      if (breakingPoint == Offset.zero) {
        breakingPoint =
            Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
      }
      final lines = BreakingLineGenerator(
        breakingPoint!,
        Size(constraints.maxWidth, constraints.maxHeight),
      );
      return Stack(
          children:
              lines.toPieces().map((e) => getPiece(e, glassChild)).toList());
    }));
  }

  Widget getPiece(GlassPiece piece, Widget glassChild) {
    if (_mainController.isSlidable) {
      return SlidablePiece(
        direction: widget.direction,
        piece: piece,
        animationDuration: widget.animationDuration,
        child: ClipPath(
          clipper: GlassPieceClipper(piece),
          child: glassChild,
        ),
      );
    }
    return ExplodablePiece(
      piece: piece,
      animationDuration: widget.animationDuration,
      child: ClipPath(
        clipper: GlassPieceClipper(piece),
        child: glassChild,
      ),
    );
  }

  Widget glass({bool canAnimate = true}) => GlassWidget(
        canAnimate: canAnimate,
        child: CustomPaint(
          painter: NumberPainter(widget.value),
          child: const SizedBox.expand(),
        ),
      );
}
