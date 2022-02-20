import 'package:flutter/material.dart';

const sizedBox = SizedBox(height: 10, width: 10);
const style =
    TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white);

Axis mainAxis(double width) => width < 600 ? Axis.vertical : Axis.horizontal;
Axis crossAxis(double width) => width < 600 ? Axis.horizontal : Axis.vertical;
