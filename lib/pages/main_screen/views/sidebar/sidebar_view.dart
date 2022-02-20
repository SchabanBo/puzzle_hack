import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/puzzle_controller.dart';
import '../../controllers/score_controller.dart';
import 'background_section.dart';
import 'score_section.dart';

class SidebarView extends GetResponsiveView<ScoreController> {
  final Axis axis;
  SidebarView(this.axis, {Key? key}) : super(key: key);

  @override
  Widget builder() => Column(
        crossAxisAlignment: axis == Axis.vertical
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: axis == Axis.horizontal
                ? MainAxisAlignment.spaceEvenly
                : MainAxisAlignment.start,
            children: [
              axis == Axis.horizontal
                  ? settingsButton()
                  : const SizedBox.shrink(),
              const Text(
                'Puzzle Challenge',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          axis == Axis.vertical ? settingsButton() : const SizedBox.shrink(),
          axis == Axis.vertical
              ? Expanded(child: BackgroundSection())
              : const SizedBox.shrink(),
          ScoreSection(),
        ],
      );

  Widget settingsButton() => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            tooltip: 'Settings',
            onPressed: () => Scaffold.of(screen.context).openDrawer(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Shuffle',
            onPressed: () => Get.find<PuzzleController>().shuffle(),
          ),
        ],
      );
}
