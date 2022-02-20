import 'dart:async';

import 'package:get/get.dart';

class ScoreController extends GetxController {
  final moves = 0.obs;
  final rightTiles = 0.obs;
  final time = 0.obs;

  @override
  void onInit() {
    Timer.periodic(const Duration(seconds: 1), (_) => time.value++);
    super.onInit();
  }
}
