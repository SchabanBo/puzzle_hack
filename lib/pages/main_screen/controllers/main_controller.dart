import 'package:get/get.dart';

import 'puzzle_controller.dart';
import 'score_controller.dart';

class MainController extends GetxController {
  final background = BackgroundType.simple.obs;

  /// Simple animation settings
  final backgroundAnimationDuration = 5000.obs;

  /// Glass settings
  int maxGlassPiece = 7;
  int animationDuration = 1000;
  bool enableLowPerformanceMode = true;
  bool useRomanNumerals = true;

  /// Shadows animation settings
  int boxesCount = 15;
  int boxSpeed = 50;
  double lightRadius = 200;
  int shadowLength = 3000;

  /// Space animation settings
  int planetsCount = 2000;
  int starsCount = 50;
  int rotationVerticalSpeed = 10;

  @override
  void onInit() {
    Get.lazyPut(PuzzleController.new);
    Get.lazyPut(ScoreController.new);
    super.onInit();
  }

  void drawerChanged(bool value) {
    if (value == false) {
      Get.find<PuzzleController>().tiles.refresh();
    }
  }
}

enum BackgroundType {
  simple,
  shadows,
  space,
}
