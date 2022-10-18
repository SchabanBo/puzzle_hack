import 'package:flutter/material.dart';

import '../../../../../../helpers/locator.dart';
import '../../../../../../helpers/random.dart';
import '../../../../../../models/glass_piece.dart';
import '../../../../controllers/main_controller.dart';
import '../glass_widget.dart';
import 'explodable_piece.dart';
import 'helpers.dart';
import 'slidable_piece.dart';

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
  final MainController _mainController = locator();

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
      if (isMobile && locator<MainController>().enableLowPerformanceMode) {
        return SlidablePiece(
          piece: GlassPiece(
            const Line(Offset.zero, Offset.zero),
            const Line(Offset.zero, Offset.zero),
            Alignment(random.nextInt(3) - 1, random.nextInt(3) - 1),
          ),
          reverse: true,
          child: glass,
          direction: Alignment.center,
          animationDuration: widget.animationDuration,
        );
      }

      final lines = BreakingLineGenerator(
        Offset(constraints.maxWidth / 2, constraints.maxHeight / 2),
        Size(constraints.maxWidth, constraints.maxHeight),
      );

      return Stack(
        children: lines.toPieces().map((e) => getPiece(e, glass)).toList(),
      );
    }));
  }

  Widget getPiece(GlassPiece piece, Widget childGlass) {
    if (_mainController.isSlidable) {
      return SlidablePiece(
        child: ClipPath(
          clipper: GlassPieceClipper(piece),
          child: childGlass,
        ),
        reverse: true,
        piece: piece,
        direction: Alignment.center,
        animationDuration: widget.animationDuration,
      );
    }
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
