import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
      return Obx(() => AnimatedContainer(
            duration: Duration(milliseconds: random.nextInt(750)),
            margin: const EdgeInsets.all(8),
            decoration: _glassDecoration(Get.find<MainController>().background),
            child: child,
          ));
    }

    return Container(
      decoration: _glassDecoration(Get.find<MainController>().background),
      child: child,
    );
  }

  BoxDecoration _glassDecoration(Rx<BackgroundType> background) {
    switch (background.value) {
      case BackgroundType.shadows:
        return BoxDecoration(
          color: Colors.black54,
          border: Border.all(color: Colors.black),
        );
      case BackgroundType.space:
        return BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.circular(25),
          border: Border.all(color: Colors.white),
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
