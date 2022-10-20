import 'package:flutter/material.dart';

import '../../../../../../models/glass_piece.dart';
import '../../main.dart';
import '../glass_widget.dart';
import 'explodable_piece.dart';
import 'helpers.dart';
import 'slidable_piece.dart';

class ExplodeBox extends StatefulWidget {
  final int value;
  final VoidCallback onEnd;
  final int animationDuration;
  const ExplodeBox({
    required this.value,
    required this.animationDuration,
    required this.onEnd,
    Key? key,
  }) : super(key: key);

  @override
  _ExplodeBoxState createState() => _ExplodeBoxState();
}

class _ExplodeBoxState extends State<ExplodeBox> {
  Offset? breakingPoint;

  void explode() {
    if (isWorking) return;
    setState(() {
      breakingPoint = Offset.zero;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (details) {
        if (isWorking) return;
        setState(() {
          breakingPoint = details.localPosition;
        });
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
      final glassChild = glass();

      if (breakingPoint == Offset.zero) {
        breakingPoint =
            Offset(constraints.maxWidth / 2, constraints.maxHeight / 2);
      }
      final lines = BreakingLineGenerator(
        breakingPoint!,
        Size(constraints.maxWidth, constraints.maxHeight),
      );
      final pieces = lines.toPieces();
      mainController.lastPieces = pieces;
      return Stack(
          children: pieces.map((e) => getPiece(e, glassChild)).toList());
    }));
  }

  Widget getPiece(GlassPiece piece, Widget glassChild) {
    if (mainController.isSlidable.read) {
      return SlidablePiece(
        direction: mainController.animationDirection.read,
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

  Widget glass() => GlassWidget(
        child: CustomPaint(
          painter: NumberPainter(widget.value),
          child: const SizedBox.expand(),
        ),
      );
}
