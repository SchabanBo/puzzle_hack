import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../helpers/random.dart';
import '../../controllers/main_controller.dart';

const appColors = [
  Color(0xFF2674d7),
  Color(0xFF4e95e5),
  Color(0xFF8e5ff1),
  Color(0xFF7375ea),
];

class SimpleBackground extends StatefulWidget {
  const SimpleBackground({Key? key}) : super(key: key);

  @override
  _SimpleBackgroundState createState() => _SimpleBackgroundState();
}

class _SimpleBackgroundState extends State<SimpleBackground> {
  Alignment alignment = Alignment.centerRight;
  Alignment endAlignment = Alignment.centerLeft;
  final animationDuration =
      Get.find<MainController>().backgroundAnimationDuration;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      _update();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => AnimatedContainer(
          duration: Duration(milliseconds: animationDuration.value),
          curve: Curves.decelerate,
          onEnd: _update,
          decoration: BoxDecoration(
              gradient: LinearGradient(
            colors: appColors,
            begin: endAlignment,
            end: alignment,
          )),
        ));
  }

  void _update() {
    var newAlign = getRandomAlignment();
    while (alignment == newAlign) {
      newAlign = getRandomAlignment();
    }
    endAlignment = alignment;
    alignment = newAlign;
    setState(() {});
  }

  Alignment getRandomAlignment() =>
      Alignment(random.nextInt(3) - 1, random.nextInt(3) - 1);
}
