import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ShimmerEffect extends StatefulWidget {
  final Widget child;
  const ShimmerEffect({required this.child, Key? key}) : super(key: key);

  @override
  _ShimmerEffectState createState() => _ShimmerEffectState();
}

const _duration = Duration(seconds: 3);

class _ShimmerEffectState extends State<ShimmerEffect> {
  bool enabled = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (event) {
        Future.delayed(_duration, () {
          if (mounted) {
            setState(() {
              enabled = false;
            });
          }
        });
        setState(() {
          enabled = true;
        });
      },
      child: Shimmer(
        duration: _duration,
        enabled: enabled,
        child: widget.child,
      ),
    );
  }
}
