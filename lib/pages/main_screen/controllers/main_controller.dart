import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:reactable/reactable.dart';

class MainController {
  final background = BackgroundType.simple.asReactable;

  /// Simple animation settings
  final backgroundAnimationDuration = 5000.asReactable;

  // Tile settings
  bool isSlidable = true;

  /// Glass settings
  int maxGlassPiece = 15;
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

  MainController() {
    if (kIsWeb) {
      background.addListener(() {
        debugPrint('Background changed to ${background.read}');
        FirebaseAnalytics.instance.logEvent(
          name: 'background: ${background.read.toString()}',
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
