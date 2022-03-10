import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/main_controller.dart';
import 'shadow.dart';
import 'simple.dart';
import 'space.dart';

class Background extends GetView<MainController> {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Obx(
        () => AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          switchInCurve: Curves.easeIn,
          switchOutCurve: Curves.easeOut,
          child: builder(),
        ),
      );

  Widget builder() {
    switch (controller.background.value) {
      case BackgroundType.shadows:
        return const ShadowsBackground();
      case BackgroundType.space:
        return const SpaceBackground();
      default:
        return const SimpleBackground();
    }
  }
}
