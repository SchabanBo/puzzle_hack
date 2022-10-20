import 'package:flutter/material.dart';
import 'package:reactable/reactable.dart';

import 'main.dart';
import 'tile/main_controller.dart';

class Controls extends ScopedView {
  const Controls({Key? key}) : super(key: key);

  @override
  Widget builder(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Row(
            children: [
              const Text('State'),
              const SizedBox(width: 8),
              ToggleButtons(
                borderRadius: const BorderRadius.all(Radius.circular(8)),
                onPressed: (index) {
                  mainController.tileState(TileState.values[index]);
                },
                children:
                    TileState.values.map((e) => Text(' ${e.name} ')).toList(),
                isSelected: TileState.values
                    .map((e) => e == mainController.tileState.value)
                    .toList(),
              )
            ],
          ),
          const SizedBox(width: 16),
          Text('Animation duration ${mainController.animationDuration.value}'),
          Expanded(
            child: Slider(
              min: 100,
              max: 7000,
              onChanged: (value) {
                mainController.animationDuration(value.toInt());
              },
              value: mainController.animationDuration.value.toDouble(),
            ),
          ),
          Row(
            children: [
              SizedBox(
                width: 150,
                child: CheckboxListTile(
                  value: mainController.isSlidable.value,
                  onChanged: mainController.isSlidable,
                  title: const Text('Can Slide'),
                ),
              ),
              if (mainController.isSlidable.value)
                DropdownButton<Alignment>(
                  value: mainController.animationDirection.value,
                  elevation: 16,
                  onChanged: (value) {
                    if (value != null) {
                      mainController.animationDirection(value);
                    }
                  },
                  items:
                      alignmentValues.map<DropdownMenuItem<Alignment>>((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value.toString()),
                    );
                  }).toList(),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

List<Alignment> alignmentValues = [
  Alignment.topLeft,
  Alignment.topCenter,
  Alignment.topRight,
  Alignment.centerLeft,
  Alignment.center,
  Alignment.centerRight,
  Alignment.bottomLeft,
  Alignment.bottomCenter,
  Alignment.bottomRight,
];
