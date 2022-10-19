import 'package:flutter/material.dart';

import '../main.dart';

class GlassWidget extends StatelessWidget {
  final Widget child;
  const GlassWidget({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: random.nextInt(1000) + 600),
      curve: Curves.slowMiddle,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.white38),
      ),
      child: child,
    );
  }
}
