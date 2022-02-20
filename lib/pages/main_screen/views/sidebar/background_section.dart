import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/main_controller.dart';

class BackgroundSection extends GetResponsiveView<MainController> {
  BackgroundSection({Key? key}) : super(key: key);
  final _style = const TextStyle(fontSize: 24, color: Colors.white);
  @override
  Widget? builder() {
    return Obx(
      () => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: BackgroundType.values.map((e) {
          final widget = TextButton(
            onPressed: () => controller.background(e),
            child: Text(
              e.name.toUpperCase(),
              style: _style,
            ),
          );
          return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: controller.background.value == e
                  ? Container(
                      padding: const EdgeInsets.all(8),
                      child: widget,
                      color: Colors.white12,
                    )
                  : Padding(padding: const EdgeInsets.all(8), child: widget));
        }).toList(),
      ),
    );
  }
}
