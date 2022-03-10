import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
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
  int lightRadius = 200;
  int shadowLength = 3000;

  /// Space animation settings
  int planetsCount = 2000;
  int planetsSpeed = 1;
  int spaceZoom = 100;
  int starsCount = 50;
  int rotationVerticalSpeed = 5;
  int startFadingSpeed = 1;

  @override
  void onInit() {
    Get.lazyPut(() => PuzzleController());
    Get.lazyPut(() => ScoreController());
    super.onInit();
    if (kIsWeb) {
      background.listen((p0) {
        debugPrint('Background changed to $p0');
        FirebaseAnalytics.instance.logEvent(
          name: 'background: ${p0.toString()}',
        );
      });
    }
  }
}

enum BackgroundType {
  simple,
  shadows,
  space,
}
