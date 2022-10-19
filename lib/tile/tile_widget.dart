import 'package:flutter/material.dart';
import 'package:reactable/reactable.dart';

import '../main.dart';
import 'effects/explode_box.dart';
import 'effects/implode_box.dart';
import 'main_controller.dart';

class TileWidget extends StatelessWidget {
  const TileWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scope(builder: (_) => _build(context));

  Widget _build(BuildContext context) {
    switch (mainController.tileState.value) {
      case TileState.imploding:
        return ImplodeBox(
          value,
          mainController.animationDuration.read,
          () => mainController.tileState(TileState.readyToExplode),
        );

      default:
        return ExplodeBox(
          value: value,
          animationDuration: mainController.animationDuration.read,
          onEnd: () => mainController.tileState(TileState.imploding),
        );
    }
  }
}
