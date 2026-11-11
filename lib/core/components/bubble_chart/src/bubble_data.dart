import 'package:flutter/material.dart';

class BubbleData {
  String name;
  double value;
  Color color;
  Offset position;
  Offset velocity;
  double radius;

  BubbleData({
    required this.name,
    required this.value,
    required this.color,
    required this.position,
    required this.velocity,
    required this.radius,
  });
}
