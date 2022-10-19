import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../helpers/locator.dart';
import '../../controllers/puzzle_controller.dart';
import 'background_section.dart';
import 'score_section.dart';

class SidebarView extends StatelessWidget {
  final Axis axis;
  const SidebarView(this.axis, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: axis == Axis.horizontal
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            const Text(
              'Rutzzle',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            if (axis == Axis.horizontal) ...[
              const Spacer(),
              settingsButton(context),
            ]
          ],
        ),
        if (axis == Axis.vertical)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Move with arrows or space for settings',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ),
        if (axis == Axis.vertical) settingsButton(context),
        Expanded(child: BackgroundSection(axis)),
        const ScoreSection(),
      ],
    );
  }

  Widget settingsButton(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.settings, color: Colors.white),
            tooltip: 'Settings',
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Shuffle',
            onPressed: () => locator<PuzzleController>().shuffle(),
          ),
          IconButton(
            icon: Image.asset('assets/github-icon.png'),
            tooltip: 'Settings',
            onPressed: () => launch('https://github.com/SchabanBo/puzzle_hack'),
          ),
        ],
      );
}
