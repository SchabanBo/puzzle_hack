import 'package:flutter/material.dart';
import 'package:reactable/reactable.dart';

import '../../../../helpers/locator.dart';
import '../../controllers/main_controller.dart';

class BackgroundSection extends StatelessWidget {
  const BackgroundSection({Key? key}) : super(key: key);
  final _style = const TextStyle(fontSize: 24, color: Colors.white);
  @override
  Widget build(BuildContext context) {
    final controller = locator<MainController>();
    return Scope(
      builder: (_) => Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: BackgroundType.values.map((e) {
          final widget = TextButton(
            onPressed: () => controller.background(e),
            child: Text(
              e.name.toUpperCase(),
              style: _style,
            ),
          );
          return AnimatedSwitcher(
              duration: const Duration(milliseconds: 500),
              child: controller.background.value == e
                  ? Container(
                      padding: const EdgeInsets.all(8),
                      child: widget,
                      color: Colors.white12,
                    )
                  : Padding(padding: const EdgeInsets.all(8), child: widget));
        }).toList(),
      ),
    );
  }
}
