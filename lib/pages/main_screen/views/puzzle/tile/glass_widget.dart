import 'package:flutter/material.dart';
import 'package:reactable/reactable.dart';

import '../../../../../helpers/locator.dart';
import '../../../../../helpers/random.dart';
import '../../../controllers/main_controller.dart';

class GlassWidget extends StatelessWidget {
  final Widget child;
  final bool canAnimate;
  const GlassWidget({required this.child, this.canAnimate = true, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (canAnimate) {
      return Scope(
        builder: (_) => AnimatedContainer(
          duration: Duration(milliseconds: random.nextInt(1000) + 600),
          curve: Curves.slowMiddle,
          margin: const EdgeInsets.all(4),
          decoration: _glassDecoration(locator<MainController>().background),
          child: child,
        ),
      );
    }

    return Container(
      decoration: _glassDecoration(locator<MainController>().background),
      child: child,
    );
  }

  BoxDecoration _glassDecoration(Reactable<BackgroundType> background) {
    switch (background.value) {
      case BackgroundType.shadows:
        return BoxDecoration(
          color: Colors.black54,
          border: Border.all(color: Colors.black),
        );
      case BackgroundType.space:
        return BoxDecoration(
          color: Colors.white.withOpacity(.05),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color: const Color(0xffffcc33).withOpacity(0.5),
            width: 2,
          ),
        );
      default:
        return BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.white38),
        );
    }
  }
}
