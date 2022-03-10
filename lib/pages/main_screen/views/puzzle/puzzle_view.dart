import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../helpers/extensions/list_extensions.dart';
import '../../controllers/puzzle_controller.dart';
import '../../controllers/tile_controller.dart';
import 'tile/tile_widget.dart';

class PuzzleView extends GetView<PuzzleController> {
  const PuzzleView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AspectRatio(
          aspectRatio: 1,
          child: Obx(() => builder(context)),
        ),
      ));

  Widget builder(BuildContext context) {
    if (controller.tiles.isEmpty) {
      return const SizedBox.shrink();
    }

    final puzzle = KeyboardListener(
      key: const ValueKey('puzzle'),
      autofocus: true,
      focusNode: controller.focusNode,
      onKeyEvent: (k) {
        if (k.logicalKey == LogicalKeyboardKey.space) {
          final scaffold = Scaffold.of(context);
          scaffold.openDrawer();
          return;
        }
        controller.onKey(k);
        FocusScope.of(context).requestFocus(controller.focusNode);
      },
      child: Table(
        children: controller.tiles
            .map(_buildTile)
            .toList()
            .chunk(controller.puzzleSize)
            .map((e) => TableRow(children: e))
            .toList(),
      ),
    );

    if (controller.isComplete()) {
      return Stack(children: [
        puzzle,
        const Center(
          child: Text(
            'YOU solved it!',
            style: TextStyle(
              fontSize: 40,
              color: Colors.indigo,
              shadows: [
                Shadow(
                  color: Colors.white,
                  offset: Offset(2, 2),
                  blurRadius: 2,
                ),
              ],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ]);
    }

    return puzzle;
  }

  Widget _buildTile(TileController tile) => AspectRatio(
      aspectRatio: 1,
      child: TileWidget(
        tile,
        key: ValueKey(tile.value),
      ));
}
