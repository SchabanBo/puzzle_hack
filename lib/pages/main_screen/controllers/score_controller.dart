import 'dart:async';

import 'package:reactable/reactable.dart';

class ScoreController {
  final moves = 0.asReactable;
  final rightTiles = 0.asReactable;
  final time = 0.asReactable;

  ScoreController() {
    Timer.periodic(const Duration(seconds: 1), (_) => time.value++);
  }
}
