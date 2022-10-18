import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import '../../../../helpers/locator.dart';
import '../../../../helpers/random.dart';
import '../../controllers/main_controller.dart';
import '../puzzle/tile/effects/helpers.dart';

class ShadowsBackground extends StatefulWidget {
  const ShadowsBackground({Key? key}) : super(key: key);

  @override
  _ShadowsBackgroundState createState() => _ShadowsBackgroundState();
}

class _ShadowsBackgroundState extends State<ShadowsBackground> {
  late Timer _timer;
  _BoxBackgroundPainter painter = _BoxBackgroundPainter();
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 50), (t) {
      update();
    });
    _next();
  }

  void _next() {
    try {
      painter.update();
    } catch (e) {
      // ignore
    }
    Timer(Duration(milliseconds: painter.controller.boxSpeed), _next);
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void update() {
    if (context.debugDoingBuild) {
      return;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _backgroundColor,
      child: Listener(
        onPointerDown: (_) {
          painter.update();
          update();
        },
        onPointerMove: (event) {
          _light = event.position;
          update();
        },
        onPointerHover: (event) {
          _light = event.position;
          update();
        },
        child: CustomPaint(
          key: Key(DateTime.now().toIso8601String()),
          size: Size.infinite,
          painter: painter,
        ),
      ),
    );
  }
}

const _full = (pi * 2) / 4;
const _colors = [
  Color(0xfff9e65a),
  Color(0xffe96709),
  Color(0xff7a0400),
];
const _backgroundColor = Color(0xff29417b);
Offset _light = const Offset(100, 100);
void setLight(Offset light) {
  _light = light;
}

class _BoxBackgroundPainter extends CustomPainter {
  final List<_Box> _boxes = <_Box>[];
  final MainController controller = locator();
  final _shadowRect = const RadialGradient(
    center: Alignment.center,
    colors: [
      Color.fromARGB(255, 255, 255, 255),
      Color(0xff52689a),
      _backgroundColor,
    ],
    stops: [0, 0.05, 1.0],
  );
  final _shadowPaint = Paint()
    ..color = const Color(0xff061126)
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    for (var i = _boxes.length; i < controller.boxesCount; i++) {
      _boxes.add(_Box(size));
    }

    for (var i = _boxes.length - 1; i >= controller.boxesCount; i--) {
      _boxes.removeLast();
    }

    _moveLight(size);
    final lightRect = Rect.fromCircle(
        center: _light, radius: controller.lightRadius.toDouble());
    final lightPaint = Paint()..shader = _shadowRect.createShader(lightRect);
    canvas.drawRect(lightRect, lightPaint);
    for (final box in _boxes) {
      box.drawShadow(canvas, _light, _shadowPaint, controller.shadowLength);
    }
    for (final box in _boxes) {
      box.draw(canvas, size);
    }
  }

  void update() {
    for (final box in List.from(_boxes)) {
      box.rotate();
      box.collisionDetection(_boxes);
    }
  }

  void _moveLight(Size size) {
    if (!isMobile) {
      return;
    }
    _light = Offset(
      _light.dx + random.nextDouble(),
      _light.dy + random.nextDouble(),
    );
    if (_light.dx > size.width) _light = Offset(0, _light.dy);
    if (_light.dy > size.height) _light = Offset(_light.dy, 0);
  }

  @override
  bool shouldRepaint(_BoxBackgroundPainter oldDelegate) => true;
}

// Source: https://codepen.io/mladen___/pen/gbvqBo
class _Box {
  int halfSize;
  double x;
  double y;
  double r = random.nextDouble() * pi;
  Color color = _colors[random.nextInt(_colors.length)];
  _Box(Size screen)
      : x = random.nextDouble() * screen.width,
        y = random.nextDouble() * screen.height,
        halfSize = (random.nextDouble() * screen.shortestSide * 0.08).toInt();

  List<Offset> _getPoints() => [
        Offset(
          x + halfSize * sin(r),
          y + halfSize * cos(r),
        ),
        Offset(
          x + halfSize * sin(r + _full),
          y + halfSize * cos(r + _full),
        ),
        Offset(
          x + halfSize * sin(r + _full * 2),
          y + halfSize * cos(r + _full * 2),
        ),
        Offset(
          x + halfSize * sin(r + _full * 3),
          y + halfSize * cos(r + _full * 3),
        ),
      ];

  void draw(Canvas canves, Size screen) {
    final path = Path();
    final points = _getPoints();
    path.moveTo(points[0].dx, points[0].dy);
    path.lineTo(points[1].dx, points[1].dy);
    path.lineTo(points[2].dx, points[2].dy);
    path.lineTo(points[3].dx, points[3].dy);
    path.close();

    if (y - halfSize > screen.height || x - halfSize > screen.width) {
      if (y - halfSize > screen.height) {
        y -= screen.height + 100;
      } else {
        x -= screen.width + 100;
      }
      _reset();
    }

    canves.drawPath(path, Paint()..color = color);
  }

  void _reset() {
    halfSize = (random.nextDouble() * 50).toInt();
    color = _colors[random.nextInt(_colors.length)];
  }

  void rotate() {
    var speed = (60 - halfSize) / 20;
    r += speed * 0.002;
    x += speed.abs();
    y += speed.abs();
  }

  void drawShadow(Canvas canves, Offset light, Paint paint, int _shadowLength) {
    final points = <_Shadow>[];
    for (var point in _getPoints()) {
      var angle = atan2(light.dy - point.dy, light.dx - point.dx);
      var endX = point.dx + _shadowLength * sin(-angle - pi / 2);
      var endY = point.dy + _shadowLength * cos(-angle - pi / 2);
      points.add(_Shadow(point, Offset(endX, endY), angle));
    }

    for (var i = points.length - 1; i >= 0; i--) {
      var n = i == 3 ? 0 : i + 1;
      final path = Path();
      path.moveTo(points[i].start.dx, points[i].start.dy);
      path.lineTo(points[n].start.dx, points[n].start.dy);
      path.lineTo(points[n].end.dx, points[n].end.dy);
      path.lineTo(points[i].end.dx, points[i].end.dy);
      path.close();
      canves.drawPath(path, paint);
    }
  }

  void collisionDetection(List<_Box> boxes) {
    for (var box in boxes) {
      if (box == this) continue;
      final dx = (x + halfSize) - (box.x + box.halfSize);
      final dy = (y + halfSize) - (box.y + box.halfSize);
      final d = sqrt(dx * dx + dy * dy);
      if (box.halfSize < 5) {
        boxes.remove(box);
      } else if (d < halfSize + halfSize) {
        halfSize = halfSize > 1 ? halfSize -= 1 : 1;
        box.halfSize = box.halfSize > 1 ? box.halfSize -= 1 : 1;
      }
    }
  }
}

class _Shadow {
  final Offset start, end;
  final double angle;
  _Shadow(this.start, this.end, this.angle);
}
