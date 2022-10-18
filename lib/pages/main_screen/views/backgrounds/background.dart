import 'package:flutter/material.dart';
import 'package:reactable/reactable.dart';

import '../../../../helpers/locator.dart';
import '../../controllers/main_controller.dart';
import 'shadow.dart';
import 'simple.dart';
import 'space.dart';

class Background extends StatelessWidget {
  const Background({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scope(
      builder: (_) => AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        child: builder(),
      ),
    );
  }

  Widget builder() {
    final controller = locator<MainController>();
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
