import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:noted_d/providers/drawing_pro.dart';

class PaintingCanvas extends CustomPainter {
  const PaintingCanvas(this.provider);

  final DrawingPro provider;

  @override
  void paint(final Canvas canvas, final Size size) {
    final Paint paint = Paint()
      ..color = provider.currentPaintColor
      ..style = PaintingStyle.fill
      ..strokeWidth = provider.currentStrokeWidth
      ..style = PaintingStyle.stroke;

    for (var item in provider.sketchList) {
      canvas.drawPoints(
        PointMode.polygon,
        item.points,
        Paint()
          ..color = item.sketchColor
          ..strokeWidth = item.strokeWidth,
      );
    }
    canvas.drawPoints(PointMode.polygon, provider.drawingPoints, paint);
  }

  @override
  bool shouldRepaint(covariant final CustomPainter oldDelegate) {
    return true;
  }
}
