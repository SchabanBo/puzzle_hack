import 'package:flutter/material.dart';

import '../helpers/locator.dart';
import '../pages/main_screen/controllers/main_controller.dart';
import '../pages/main_screen/controllers/puzzle_controller.dart';
import '../pages/main_screen/controllers/score_controller.dart';
import '../pages/main_screen/views/main_view.dart';

class PuzzleApp extends StatelessWidget {
  const PuzzleApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!locator.isRegistered<MainController>()) {
      locator.registerSingleton(MainController());
      locator.registerSingleton(ScoreController());
      locator.registerSingleton(PuzzleController());
    }
    return const MaterialApp(
      home: MainScreen(),
    );
  }
}
