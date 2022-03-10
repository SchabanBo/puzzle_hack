import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

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
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              axis == Axis.horizontal
                  ? settingsButton()
                  : const SizedBox.shrink(),
              SizedBox(width: axis == Axis.horizontal ? 16 : 0),
              const Text(
                'Puzzle Challenge',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ],
          ),
          if (axis == Axis.vertical)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                'Move with arrows or Space for settings',
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
            ),
          if (axis == Axis.vertical) settingsButton(),
          axis == Axis.vertical
              ? Expanded(child: BackgroundSection())
              : const SizedBox(height: 16),
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
          IconButton(
            icon: Image.asset('assets/github-icon.png'),
            tooltip: 'Settings',
            onPressed: () => launch('https://github.com/SchabanBo/puzzle_hack'),
          ),
        ],
      );
}
