import 'dart:async';
import 'dart:math';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../../../helpers/locator.dart';
import '../../../../helpers/random.dart';
import '../../controllers/main_controller.dart';

class SpaceBackground extends StatelessWidget {
  const SpaceBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      child: Stack(
        children: [
          const GalaxyBackground(),
          Container(
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  radius: 0.1,
                  colors: [
                    Colors.white,
                    const Color(0xffffe484),
                    const Color(0xffffcc33),
                    const Color(0xfffc9601),
                    const Color(0xfffc9601).withOpacity(0.5),
                    Colors.transparent,
                  ],
                  stops: const [0, 0.05, 0.1, 0.15, 0.25, 0.5],
                )),
          ),
        ],
      ),
    );
  }
}

final _yScale = ScaleChanger();

class GalaxyBackground extends StatefulWidget {
  const GalaxyBackground({Key? key}) : super(key: key);

  @override
  _GalaxyBackgroundState createState() => _GalaxyBackgroundState();
}

class _GalaxyBackgroundState extends State<GalaxyBackground> {
  late Timer _timer;
  late Timer _timer2;
  final painter = _GalaxyPainter();
  final _controller = locator<MainController>();
  bool _canEdit = false;
  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(milliseconds: 100), (t) {
      _yScale.update();
    });
    _timer2 = Timer.periodic(const Duration(milliseconds: 50), (t) {
      _next();
    });
  }

  void _next() {
    if (painter._planets.length < _controller.planetsCount) {
      painter.addPlanet(_controller.planetsCount);
      painter.addPlanet(_controller.planetsCount);
    } else if (painter._planets.length > _controller.planetsCount + 10) {
      painter._planets.removeRange(
        painter._planets.length - 8,
        painter._planets.length,
      );
    }
    if (painter._stars.length < _controller.starsCount) {
      painter.addStar();
      painter.addStar();
    } else if (painter._stars.length > _controller.starsCount) {
      painter._stars.removeLast();
      painter._stars.removeLast();
    }
    update();
  }

  void update() {
    if (context.debugDoingBuild) {
      return;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel();
    _timer2.cancel();
    _yScale.scale = .5;
    _yScale.direction = -1;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _canEdit = true,
      onPointerUp: (_) => _canEdit = false,
      onPointerMove: (event) {
        if (_canEdit) {
          _yScale.scale += event.delta.dy / 1000;
          if (_controller.planetsCount > 0 || event.delta.dx > 0) {
            _controller.planetsCount += event.delta.dx.toInt();
          }
        }
      },
      onPointerSignal: (pointerSignal) {
        if (pointerSignal is PointerScrollEvent) {
          _controller.spaceZoom += pointerSignal.scrollDelta.dy.toInt();
        }
      },
      child: CustomPaint(
          key: ValueKey(random.nextDouble()),
          size: Size.infinite,
          painter: painter),
    );
  }
}

class _GalaxyPainter extends CustomPainter {
  final _planets = <_Planet>[];
  final _stars = <_Star>[];

  Size? size;
  @override
  void paint(Canvas canvas, Size size) {
    if (this.size != size) {
      this.size = size;
      _planets.clear();
      _stars.clear();
    }
    for (final planet in _planets) {
      planet.update();
      planet.draw(canvas);
    }

    for (final star in _stars) {
      star.update();
      star.draw(canvas);
    }
  }

  void addPlanet(int _maxCount) {
    final r = size!.shortestSide * ((_planets.length) / _maxCount);

    for (var i = 1; i < 4; i++) {
      _planets.add(_Planet(
        cx: .5 * size!.width,
        cy: .5 * size!.height,
        radius: r * (i / 3),
        step: pi * ((_planets.length + 1) / 4) / 180,
      ));
      _planets.add(_Planet(
        cx: .5 * size!.width,
        cy: .5 * size!.height,
        radius: -r * (i / 3),
        step: pi * ((_planets.length + 1) / 4) / 180,
      ));
    }
  }

  void addStar() {
    _stars.add(_Star(
      random.nextDouble() * size!.width,
      random.nextDouble() * size!.height,
    ));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class _Planet {
  double cx, cy, x = 0, y = 0, z = random.nextDouble() * 2 + 1;
  double speed = pi / 720, step = 0, radius;

  final _controller = locator<MainController>();
  double scale = random.nextBool() ? 1 : random.nextDouble() + .5;
  double scale1 = random.nextBool() ? 1 : random.nextDouble() + .5;
  _Planet({
    required this.cx,
    required this.cy,
    required this.radius,
    required this.step,
  });

  void update() {
    for (var i = 0; i < _controller.planetsSpeed.abs(); i++) {
      final _step = step * (_controller.planetsSpeed > 0 ? 1 : -1);
      x = (radius * cos(_step) * scale) * (_controller.spaceZoom / 100);
      y = radius * sin(_step) * (_controller.spaceZoom / 100);
      y *= _yScale.scale;
      step -= speed;
    }
  }

  final paint = Paint()
    ..color = const Color.fromARGB(200, 255, 255, 255)
    ..style = PaintingStyle.fill;
  void draw(Canvas canvas) {
    canvas.drawCircle(Offset(cx + x, cy + y), z, paint);
  }
}

class ScaleChanger {
  final _controller = locator<MainController>();
  double scale = .5;

  double direction = -1;

  void update() {
    direction = scale >= .8
        ? -1
        : scale <= -.5
            ? 1
            : direction;
    scale += direction * (_controller.rotationVerticalSpeed / 10000);
  }
}

class _Star {
  final double x, y;
  final double radius = random.nextDouble() * 10;
  final _controller = locator<MainController>();
  Color color;
  bool isUp = true;
  _Star(this.x, this.y)
      : color = Color.fromARGB(random.nextInt(256), random.nextInt(55) + 200,
            random.nextInt(55) + 200, random.nextInt(55) + 200);

  void draw(Canvas canvas) {
    final paint = Paint()
      ..shader = RadialGradient(colors: [color, Colors.transparent])
          .createShader(Rect.fromCircle(center: Offset(x, y), radius: radius));

    canvas.drawCircle(Offset(x, y), radius, paint);
  }

  void update() {
    if (color.alpha == 0 && !isUp) isUp = true;
    if (color.alpha == 255 && isUp) isUp = false;

    color = Color.fromARGB(
      isUp
          ? color.alpha + _controller.startFadingSpeed
          : color.alpha - _controller.startFadingSpeed,
      255,
      255,
      255,
    );
  }
}
