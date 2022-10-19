import 'package:flutter/material.dart';
import 'package:reactable/reactable.dart';

import '../../../../helpers/locator.dart';
import '../../controllers/main_controller.dart';

class BackgroundSection extends StatelessWidget {
  final Axis axis;
  const BackgroundSection(this.axis, {Key? key}) : super(key: key);
  final _style = const TextStyle(fontSize: 24, color: Colors.white);
  @override
  Widget build(BuildContext context) {
    final controller = locator<MainController>();
    return Align(
      alignment: Alignment.centerLeft,
      child: Scope(
        builder: (_) => ToggleButtons(
          direction: axis,
          isSelected: BackgroundType.values
              .map((e) => e == controller.background.value)
              .toList(),
          onPressed: (index) {
            controller.background(BackgroundType.values[index]);
          },
          borderRadius: BorderRadius.circular(8),
          borderColor: Colors.white60,
          selectedBorderColor: Colors.white,
          children: BackgroundType.values.map((e) {
            return Text(
              ' ${e.name.toUpperCase()} ',
              style: _style,
            );
          }).toList(),
        ),
      ),
    );
  }
}
