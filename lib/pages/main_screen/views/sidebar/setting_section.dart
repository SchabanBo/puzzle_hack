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
                  color: Colors.black),
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
  Widget build(BuildContext context) => Row(
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
          ObxValue<Rx<int>>(
              (v) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            'Tile Animation Duration (ms)',
                            style: _style,
                          ),
                          Text(
                            v.toString(),
                            style: _style,
                          )
                        ],
                      ),
                      Slider(
                          value: v.toDouble(),
                          min: 100,
                          max: 4000,
                          label: v.toString(),
                          activeColor: Colors.blue,
                          thumbColor: Colors.white,
                          onChanged: (value) {
                            controller.animationDuration = value.toInt();
                            v(value.toInt());
                          }),
                    ],
                  ),
              controller.animationDuration.obs),
          ObxValue<Rx<int>>(
              (v) => Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          const Text(
                            'Max Glass Piece Count',
                            style: _style,
                          ),
                          Text(
                            (v.value + 4).toString(),
                            style: _style,
                          )
                        ],
                      ),
                      Slider(
                          value: v.toDouble(),
                          min: 1,
                          max: 20,
                          label: v.toString(),
                          activeColor: Colors.blue,
                          thumbColor: Colors.white,
                          onChanged: (value) {
                            controller.maxGlassPiece = value.toInt();
                            v(value.toInt());
                          }),
                    ],
                  ),
              controller.maxGlassPiece.obs),
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
              children: [
                ObxValue<RxInt>(
                    (v) => Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                'Boxes Count',
                                style: _style,
                              ),
                              Obx(() => Text(
                                    v.value.toString(),
                                    style: _style,
                                  ))
                            ],
                          ),
                          Slider(
                              value: v.value.toDouble(),
                              min: 10,
                              max: 50,
                              label: v.value.toString(),
                              activeColor: Colors.blue,
                              thumbColor: Colors.white,
                              onChanged: (value) {
                                controller.boxesCount = value.toInt();
                                v(value.toInt());
                              })
                        ]),
                    controller.boxesCount.obs),
                ObxValue<RxInt>(
                    (v) => Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                'Box Speed (ms)',
                                style: _style,
                              ),
                              Obx(() => Text(
                                    v.value.toString(),
                                    style: _style,
                                  ))
                            ],
                          ),
                          Slider(
                              value: v.value.toDouble(),
                              min: 10,
                              max: 300,
                              label: v.value.toString(),
                              activeColor: Colors.blue,
                              thumbColor: Colors.white,
                              onChanged: (value) {
                                controller.boxSpeed = value.toInt();
                                v(value.toInt());
                              })
                        ]),
                    controller.boxSpeed.obs),
                ObxValue<RxDouble>(
                    (v) => Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                'Light radius',
                                style: _style,
                              ),
                              Obx(() => Text(
                                    v.value.toInt().toString(),
                                    style: _style,
                                  ))
                            ],
                          ),
                          Slider(
                              value: v.value,
                              min: 10,
                              max: 300,
                              label: v.value.toString(),
                              activeColor: Colors.blue,
                              thumbColor: Colors.white,
                              onChanged: (value) {
                                controller.lightRadius = value;
                                v(value);
                              })
                        ]),
                    controller.lightRadius.obs),
                ObxValue<RxInt>(
                    (v) => Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                'Shadow length',
                                style: _style,
                              ),
                              Obx(() => Text(
                                    v.value.toString(),
                                    style: _style,
                                  ))
                            ],
                          ),
                          Slider(
                              value: v.value.toDouble(),
                              min: 100,
                              max: 4000,
                              label: v.value.toString(),
                              activeColor: Colors.blue,
                              thumbColor: Colors.white,
                              onChanged: (value) {
                                controller.shadowLength = value.toInt();
                                v(value.toInt());
                              })
                        ]),
                    controller.shadowLength.obs),
              ]),
          ExpansionTile(
              leading: Obx(() => Checkbox(
                    value: controller.background.value == BackgroundType.space,
                    onChanged: (_) =>
                        controller.background(BackgroundType.space),
                  )),
              title: const Text('Space Animation'),
              children: [
                ObxValue<RxInt>(
                    (v) => Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                'Asteroids count',
                                style: _style,
                              ),
                              Obx(() => Text(
                                    v.value.toString(),
                                    style: _style,
                                  ))
                            ],
                          ),
                          Slider(
                              value: v.value.toDouble(),
                              min: 1000,
                              max: 6000,
                              label: v.value.toString(),
                              activeColor: Colors.blue,
                              thumbColor: Colors.white,
                              onChanged: (value) {
                                controller.planetsCount = value.toInt();
                                v(value.toInt());
                              })
                        ]),
                    controller.planetsCount.obs),
                ObxValue<RxInt>(
                    (v) => Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                'Stars count',
                                style: _style,
                              ),
                              Obx(() => Text(
                                    v.value.toString(),
                                    style: _style,
                                  ))
                            ],
                          ),
                          Slider(
                              value: v.value.toDouble(),
                              min: 10,
                              max: 200,
                              label: v.value.toString(),
                              activeColor: Colors.blue,
                              thumbColor: Colors.white,
                              onChanged: (value) {
                                controller.starsCount = value.toInt();
                                v(value.toInt());
                              })
                        ]),
                    controller.starsCount.obs),
                ObxValue<RxInt>(
                    (v) => Column(children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              const Text(
                                'Vertical rotation speed',
                                style: _style,
                              ),
                              Obx(() => Text(
                                    v.value.toString(),
                                    style: _style,
                                  ))
                            ],
                          ),
                          Slider(
                              value: v.value.toDouble(),
                              min: 1,
                              max: 30,
                              label: v.value.toString(),
                              activeColor: Colors.blue,
                              thumbColor: Colors.white,
                              onChanged: (value) {
                                controller.rotationVerticalSpeed =
                                    value.toInt();
                                v(value.toInt());
                              })
                        ]),
                    controller.rotationVerticalSpeed.obs),
              ]),
        ],
      );
}
