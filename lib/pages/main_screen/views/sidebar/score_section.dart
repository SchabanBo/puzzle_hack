import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/score_controller.dart';
import 'constants.dart';

class ScoreSection extends GetResponsiveView<ScoreController> {
  ScoreSection({Key? key}) : super(key: key);

  @override
  Widget builder() => Flex(
          direction: crossAxis(screen.width),
          mainAxisAlignment: crossAxis(screen.width) == Axis.vertical
              ? MainAxisAlignment.end
              : MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sizedBox,
            Obx(() => Text('Moves: ${controller.moves}', style: style)),
            sizedBox,
            Obx(() =>
                Text('Right Tiles: ${controller.rightTiles}', style: style)),
            sizedBox,
            Obx(() => Text(
                'Timer: ${Duration(seconds: controller.time.value)}'
                    .substring(0, 14),
                style: style)),
          ]);
}
