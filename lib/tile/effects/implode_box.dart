import 'package:flutter/material.dart';

import '../../../../../../models/glass_piece.dart';
import '../../main.dart';
import '../glass_widget.dart';
import 'explodable_piece.dart';
import 'helpers.dart';

class ImplodeBox extends StatefulWidget {
  final int value;
  final VoidCallback onEnd;
  final int animationDuration;
  const ImplodeBox(
    this.value,
    this.animationDuration,
    this.onEnd, {
    Key? key,
  }) : super(key: key);

  @override
  _ImplodeBoxState createState() => _ImplodeBoxState();
}

class _ImplodeBoxState extends State<ImplodeBox> {
  bool _isAnimating = true;

  late final glass = GlassWidget(
    child: CustomPaint(
      painter: NumberPainter(widget.value),
      child: Container(),
    ),
  );

  @override
  Widget build(BuildContext context) {
    if (_isAnimating) {
      Future.delayed(Duration(milliseconds: widget.animationDuration + 200),
          () {
        setState(() {
          _isAnimating = false;
        });
      });
    } else {
      Future.delayed(Duration(milliseconds: widget.animationDuration ~/ 4), () {
        widget.onEnd();
        isWorking = false;
      });
    }

    return AnimatedSwitcher(
      duration: Duration(milliseconds: widget.animationDuration ~/ 4),
      child: buildChild(),
    );
  }

  Widget buildChild() {
    if (!_isAnimating) return glass;

    return LayoutBuilder(builder: ((context, constraints) {
      List<GlassPiece> _getPieces() {
        if (mainController.lastPieces.isNotEmpty) {
          final pieces = mainController.lastPieces;
          mainController.lastPieces = [];
          return pieces;
        }
        final lines = BreakingLineGenerator(
          Offset(constraints.maxWidth / 2, constraints.maxHeight / 2),
          Size(constraints.maxWidth, constraints.maxHeight),
        );
        return lines.toPieces();
      }

      return Stack(
        children: _getPieces().map((e) => getPiece(e, glass)).toList(),
      );
    }));
  }

  Widget getPiece(GlassPiece piece, Widget childGlass) {
    return ExplodablePiece(
      piece: piece,
      animationDuration: widget.animationDuration,
      reverse: true,
      child: ClipPath(
        clipper: GlassPieceClipper(piece),
        child: childGlass,
      ),
    );
  }
}
