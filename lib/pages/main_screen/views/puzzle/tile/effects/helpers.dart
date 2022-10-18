import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../../../helpers/locator.dart';
import '../../../../../../helpers/random.dart';
import '../../../../../../models/glass_piece.dart';
import '../../../../controllers/main_controller.dart';

final isMobile = defaultTargetPlatform == TargetPlatform.iOS ||
    defaultTargetPlatform == TargetPlatform.android;

class BreakingLineGenerator {
  static const breakSpace = 1;
  final Offset breakPoint;
  final MainController mainController = locator();
  final Size size;
  final _lines = <Line>[];

  BreakingLineGenerator(this.breakPoint, this.size) {
    _lines.add(Line(Offset.zero, breakPoint));
    _top();
    _lines.add(Line(Offset(size.width, 0), breakPoint));
    _right();
    _lines.add(Line(Offset(size.width, size.height), breakPoint));
    _bottom();
    _lines.add(Line(Offset(0, size.height), breakPoint));
    _left();
    _lines.add(Line(Offset.zero, breakPoint));
  }

  List<double> points(int max, {bool reverse = false}) {
    final points = <double>[];
    final count = (mainController.maxGlassPiece - 4) ~/ 4;
    for (var i = 0; i < count; i++) {
      points.add(random.nextInt(max).toDouble());
    }
    points.sort();
    if (reverse) {
      return points.reversed.toList();
    }
    return points;
  }

  List<GlassPiece> toPieces() {
    final pieces = <GlassPiece>[];
    for (var i = 0; i < _lines.length - 1; i++) {
      pieces.add(GlassPiece(
        _lines[i],
        _lines[i + 1],
        _alignment(_lines[i].start),
      ));
    }
    return pieces;
  }

  Alignment _alignment(Offset start) => Alignment(
      ((start.dx / size.width) - 0.5) * 2,
      ((start.dy / size.height) - 0.5) * 2);

  void _top() => _lines.addAll(points(size.width.toInt())
      .map((e) => Line(Offset(e, 0), breakPoint, x: breakSpace)));

  void _bottom() => _lines.addAll(points(size.width.toInt(), reverse: true)
      .map((e) => Line(Offset(e, size.height), breakPoint, x: -breakSpace)));

  void _left() => _lines.addAll(points(size.width.toInt(), reverse: true)
      .map((e) => Line(Offset(0, e), breakPoint, y: -breakSpace)));

  void _right() => _lines.addAll(points(size.height.toInt())
      .map((e) => Line(Offset(size.height, e), breakPoint, y: breakSpace)));
}

class GlassPieceClipper extends CustomClipper<Path> {
  final GlassPiece piece;

  const GlassPieceClipper(this.piece);

  @override
  Path getClip(Size size) {
    final path1 = Path();
    path1.moveTo(piece.line1.end.dx, piece.line1.end.dy);
    path1.lineTo(piece.line1.start.dx + piece.line1.x,
        piece.line1.start.dy + piece.line1.y);
    path1.lineTo(piece.line2.start.dx - piece.line1.x,
        piece.line2.start.dy - piece.line1.y);
    path1.close();

    return path1;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}

class NumberPainter extends CustomPainter {
  final int value;
  final controller = locator<MainController>();
  NumberPainter(this.value);

  @override
  void paint(Canvas canvas, Size size) {
    final textSpan = TextSpan(
        text:
            controller.useRomanNumerals ? _intToRoman(value) : value.toString(),
        style: TextStyle(
          fontSize: size.width * 0.4,
          color: Colors.white,
        ));
    final textPainter =
        TextPainter(text: textSpan, textDirection: TextDirection.ltr);
    textPainter.layout(minWidth: 0, maxWidth: size.width);
    final xCenter = (size.width - textPainter.width) / 2;
    final yCenter = (size.height - textPainter.height) / 2;
    final offset = Offset(xCenter, yCenter);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

const List<int> _arabianRomanNumbers = [10, 9, 5, 4, 1];

const List<String> _romanNumbers = ["X", "IX", "V", "IV", "I"];

String _intToRoman(int input) {
  var num = input;

  if (num < 0) {
    return "";
  } else if (num == 0) {
    return "null";
  }

  final builder = StringBuffer();
  for (var a = 0; a < _arabianRomanNumbers.length; a++) {
    final times = (num / _arabianRomanNumbers[a]).truncate();
    builder.write(_romanNumbers[a] * times);
    num -= times * _arabianRomanNumbers[a];
  }

  return builder.toString();
}
