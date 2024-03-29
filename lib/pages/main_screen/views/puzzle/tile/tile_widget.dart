import 'package:flutter/material.dart';
import 'package:reactable/reactable.dart';

import '../../../../../helpers/locator.dart';
import '../../../controllers/main_controller.dart';
import '../../../controllers/puzzle_controller.dart';
import '../../../controllers/tile_controller.dart';
import 'effects/explode_box.dart';
import 'effects/implode_box.dart';
import 'fading_tile.dart';

class TileWidget extends StatelessWidget {
  final TileController controller;
  final PuzzleController puzzleController = locator();
  final MainController mainController = locator();
  TileWidget(this.controller, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scope(
        builder: (_) => _build(context),
      );

  Widget _build(BuildContext context) {
    FocusScope.of(context).requestFocus(puzzleController.focusNode);
    switch (controller.state.value) {
      case TileState.readyToExplode:
        return Container(
          decoration: controller.value == controller.currentValue.value
              ? const BoxDecoration(color: Colors.white24)
              : null,
          child: ExplodeBox(
            value: controller.currentValue.value,
            direction: puzzleController.getDirection(controller),
            animationDuration: mainController.animationDuration,
            explode: controller.explode,
            canBreak: () => puzzleController.isTileMovable(controller),
            onTap: () =>
                controller.newValue = puzzleController.updateValue(controller),
            onEnd: () => puzzleController.updateWhitespace(controller),
          ),
        );
      case TileState.imploding:
        return ImplodeBox(
          controller.currentValue.value,
          mainController.animationDuration,
          () => controller.state(TileState.readyToExplode),
        );
      case TileState.whitespace:
        return const SizedBox.shrink();
      default:
        return FadingTile(
          controller.currentValue.value,
          () => controller.state(controller.state.value == TileState.onStart
              ? TileState.readyToExplode
              : TileState.whitespace),
          reverse: controller.state.value == TileState.onStart,
        );
    }
  }
}
