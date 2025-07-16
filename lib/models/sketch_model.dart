import 'package:flutter/widgets.dart';

class SketchModel {
  final List<Offset> points;
  final Color sketchColor;
  final double strokeWidth;

  SketchModel({
    required this.points,
    required this.sketchColor,
    required this.strokeWidth,
  });
}
