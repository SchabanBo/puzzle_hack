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
          axis == Axis.vertical ? settingsButton() : const SizedBox.shrink(),
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
            icon: Image.asset('assets/settings.png'),
            tooltip: 'Settings',
            onPressed: () => Scaffold.of(screen.context).openDrawer(),
          ),
          IconButton(
            icon: Image.asset('assets/refresh.png'),
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
