import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controllers/main_controller.dart';
import '../../controllers/puzzle_controller.dart';

const _style = TextStyle(fontSize: 16, color: Colors.black);

class SettingsSection extends GetView<MainController> {
  const SettingsSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: const [
            Text(
              'Settings',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text('Puzzle Size',
                style: TextStyle(fontSize: 20, color: Colors.black)),
            Divider(),
            _PuzzleSettings(),
            SizedBox(height: 10),
            Text('Background',
                style: TextStyle(fontSize: 20, color: Colors.black)),
            Divider(),
            _BackgroundSettings(),
            SizedBox(height: 10),
            Text(
              'Glass Settings',
              style: TextStyle(fontSize: 20, color: Colors.black),
            ),
            Divider(),
            _GlassSettings(),
          ],
        ),
      );
}

class _PuzzleSettings extends GetView<PuzzleController> {
  final sizes = const [3, 4, 5, 6];
  const _PuzzleSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: sizes
                .map((e) => Expanded(
                      child: InkWell(
                        onTap: () {
                          Get.find<PuzzleController>().updateSize(e);
                          Scaffold.of(context).openEndDrawer();
                        },
                        child: Container(
                          color: e == controller.puzzleSize
                              ? Colors.blue
                              : Colors.transparent,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 8),
                          alignment: Alignment.center,
                          child: Text(e.toString(), style: _style),
                        ),
                      ),
                    ))
                .toList(),
          ),
          TextButton(
            onPressed: () => Get.find<PuzzleController>().solveIt(),
            child: const Text('Solve It'),
          ),
        ],
      );
}

class _GlassSettings extends GetView<MainController> {
  const _GlassSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ObxValue<RxBool>(
              (value) => CheckboxListTile(
                    value: value.value,
                    onChanged: (v) {
                      value.value = v ?? true;
                      controller.isSlidable = v ?? true;
                    },
                    title: const Text('Slidable Glass'),
                  ),
              controller.isSlidable.obs),
          ObxValue<RxBool>(
              (value) => CheckboxListTile(
                    value: value.value,
                    onChanged: (v) {
                      value.value = v ?? true;
                      controller.enableLowPerformanceMode = v ?? true;
                    },
                    title: const Text('Low Performance Mode'),
                  ),
              controller.enableLowPerformanceMode.obs),
          ObxValue<RxBool>(
              (value) => CheckboxListTile(
                    value: value.value,
                    onChanged: (v) {
                      value.value = v ?? true;
                      controller.useRomanNumerals = v ?? true;
                    },
                    title: const Text('Use Roman Numerals'),
                  ),
              controller.useRomanNumerals.obs),
          ValueChanger(
            label: 'Tile Animation Duration (ms)',
            min: 100,
            max: 4000,
            value: controller.animationDuration,
            onChanged: (v) => controller.animationDuration = v,
          ),
          ValueChanger(
            label: 'Max Glass Piece Count',
            min: 5,
            max: 20,
            value: controller.maxGlassPiece,
            onChanged: (v) => controller.maxGlassPiece = v,
          ),
        ],
      );
}

class _BackgroundSettings extends GetView<MainController> {
  const _BackgroundSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ExpansionTile(
              leading: Obx(() => Checkbox(
                    value: controller.background.value == BackgroundType.simple,
                    onChanged: (_) =>
                        controller.background(BackgroundType.simple),
                  )),
              title: const Text('Simple Animation'),
              initiallyExpanded:
                  controller.background.value == BackgroundType.simple,
              children: [
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Text(
                          'Animation Duration (ms)',
                          style: _style,
                        ),
                        Obx(() => Text(
                              controller.backgroundAnimationDuration.toString(),
                              style: _style,
                            ))
                      ],
                    ),
                    Obx(() => Slider(
                        value:
                            controller.backgroundAnimationDuration.toDouble(),
                        min: 1000,
                        max: 8000,
                        label:
                            controller.backgroundAnimationDuration.toString(),
                        activeColor: Colors.blue,
                        thumbColor: Colors.white,
                        onChanged: (value) {
                          controller.backgroundAnimationDuration(value.toInt());
                        })),
                  ],
                ),
              ]),
          ExpansionTile(
              leading: Obx(() => Checkbox(
                    value:
                        controller.background.value == BackgroundType.shadows,
                    onChanged: (_) =>
                        controller.background(BackgroundType.shadows),
                  )),
              title: const Text('Shadows Animation'),
              initiallyExpanded:
                  controller.background.value == BackgroundType.shadows,
              children: [
                ValueChanger(
                  label: 'Boxes Count',
                  value: controller.boxesCount,
                  min: 10,
                  max: 50,
                  onChanged: (v) => controller.boxesCount = v,
                ),
                ValueChanger(
                  label: 'Box Speed (ms)',
                  value: controller.boxSpeed,
                  min: 10,
                  max: 300,
                  onChanged: (v) => controller.boxSpeed = v,
                ),
                ValueChanger(
                  label: 'Light radius',
                  value: controller.lightRadius,
                  min: 10,
                  max: 300,
                  onChanged: (v) => controller.lightRadius = v,
                ),
                ValueChanger(
                  label: 'Shadow length',
                  value: controller.shadowLength,
                  min: 100,
                  max: 4000,
                  onChanged: (v) => controller.shadowLength = v,
                ),
              ]),
          ExpansionTile(
              leading: Obx(() => Checkbox(
                    value: controller.background.value == BackgroundType.space,
                    onChanged: (_) =>
                        controller.background(BackgroundType.space),
                  )),
              title: const Text('Space Animation'),
              initiallyExpanded:
                  controller.background.value == BackgroundType.space,
              children: [
                ValueChanger(
                  label: 'Asteroids count',
                  min: 1000,
                  max: 6000,
                  value: controller.planetsCount,
                  onChanged: (v) => controller.planetsCount = v,
                ),
                ValueChanger(
                  label: 'Asteroids speed',
                  min: -50,
                  max: 50,
                  value: controller.planetsSpeed,
                  onChanged: (v) => controller.planetsSpeed = v,
                ),
                ValueChanger(
                  label: 'Zoom %',
                  min: 1,
                  max: 1000,
                  value: controller.spaceZoom,
                  onChanged: (v) => controller.spaceZoom = v,
                ),
                ValueChanger(
                  label: 'Stars count',
                  value: controller.starsCount,
                  min: 10,
                  max: 200,
                  onChanged: (v) => controller.starsCount = v,
                ),
                ValueChanger(
                    label: 'Start fading speed',
                    value: controller.startFadingSpeed,
                    min: 0,
                    max: 30,
                    onChanged: (v) => controller.startFadingSpeed = v),
                ValueChanger(
                  label: 'Vertical rotation speed',
                  min: 1,
                  max: 100,
                  value: controller.rotationVerticalSpeed,
                  onChanged: (v) => controller.rotationVerticalSpeed = v,
                )
              ]),
        ],
      );
}

class ValueChanger extends StatelessWidget {
  final ValueChanged<int> onChanged;
  final String label;
  final int value;
  final int min;
  final int max;

  const ValueChanger({
    required this.label,
    required this.min,
    required this.max,
    required this.value,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ObxValue<RxInt>(
        (v) => Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(label, style: _style),
                  Obx(() => Text(
                        v.value.toString(),
                        style: _style,
                      ))
                ],
              ),
              Slider(
                  value: (v.value > max
                          ? max
                          : v.value < min
                              ? min
                              : v.value)
                      .toDouble(),
                  min: min.toDouble(),
                  max: max.toDouble(),
                  label: v.value.toString(),
                  activeColor: Colors.blue,
                  thumbColor: Colors.white,
                  onChanged: (value) {
                    onChanged(value.toInt());
                    v(value.toInt());
                  })
            ]),
        value.obs);
  }
}
