import 'package:flutter/material.dart';
import 'package:reactable/reactable.dart';

import '../../../../helpers/locator.dart';
import '../../controllers/score_controller.dart';
import 'constants.dart';

class ScoreSection extends StatelessWidget {
  const ScoreSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = locator<ScoreController>();
    return LayoutBuilder(builder: (c, b) {
      final screen = MediaQuery.of(c).size;
      return Flex(
        direction: crossAxis(screen.width),
        mainAxisAlignment: crossAxis(screen.width) == Axis.vertical
            ? MainAxisAlignment.end
            : MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          sizedBox,
          Scope(
            builder: (_) => Text('Moves: ${controller.moves}', style: style),
          ),
          sizedBox,
          Scope(
            builder: (_) =>
                Text('Right Tiles: ${controller.rightTiles}', style: style),
          ),
          sizedBox,
          Scope(
            builder: (_) => Text(
                'Timer: ${Duration(seconds: controller.time.value)}'
                    .substring(0, 14),
                style: style),
          ),
        ],
      );
    });
  }
}
