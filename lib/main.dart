import 'dart:math';

import 'package:flutter/material.dart';

import 'main_view.dart';
import 'tile/main_controller.dart';

final mainController = MainController();
final random = Random();
final value = random.nextInt(10);
const appColors = [
  Color(0xFF2674d7),
  Color(0xFF4e95e5),
  Color(0xFF8e5ff1),
  Color(0xFF7375ea),
];

void main() async {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Material(
        color: appColors[0],
        child: const MainView(),
      ),
    );
  }
}
