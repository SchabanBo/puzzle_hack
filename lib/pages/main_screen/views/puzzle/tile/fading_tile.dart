import 'package:flutter/material.dart';

import 'effects/helpers.dart';
import 'glass_widget.dart';

class FadingTile extends StatefulWidget {
  final int value;
  final bool reverse;
  final VoidCallback onEnd;
  const FadingTile(this.value, this.onEnd, {this.reverse = false, Key? key})
      : super(key: key);

  @override
  _FadingTileState createState() => _FadingTileState();
}

class _FadingTileState extends State<FadingTile> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  late final Animation<double> _animation = Tween<double>(
    begin: widget.reverse ? 0 : 1.0,
    end: widget.reverse ? 1.0 : 0,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOutBack,
  ));

  @override
  void initState() {
    super.initState();
    _controller.forward();
    _animation.addStatusListener((status) {
      if (status == AnimationStatus.completed) widget.onEnd();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: FadeTransition(
        opacity: _animation,
        child: glass,
      ),
    );
  }

  Widget get glass => GlassWidget(
          child: CustomPaint(
        painter: NumberPainter(widget.value),
        child: Container(),
      ));
}
