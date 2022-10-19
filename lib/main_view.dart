import 'package:flutter/material.dart';

import 'controls_widget.dart';
import 'main.dart';
import 'tile/main_controller.dart';
import 'tile/tile_widget.dart';

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future.delayed(const Duration(seconds: 2), () {
      mainController.tileState(TileState.readyToExplode);
    });
    final sideLength = MediaQuery.of(context).size.shortestSide;
    return Column(
      children: [
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(sideLength * 0.3),
            child: const AspectRatio(aspectRatio: 1, child: TileWidget()),
          ),
        ),
        const Controls(),
      ],
    );
  }
}
