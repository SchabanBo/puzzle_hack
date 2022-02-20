import 'package:flutter/material.dart';

class GlassPiece {
  final Line line1;
  final Line line2;
  final Alignment alignment;
  const GlassPiece(
    this.line1,
    this.line2,
    this.alignment,
  );
}

class Line {
  final Offset start;
  final Offset end;
  final int x;
  final int y;
  const Line(this.start, this.end, {this.x = 0, this.y = 0});
  @override
  String toString() => "$start $end";
}
