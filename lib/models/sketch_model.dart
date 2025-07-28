import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

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

class DrawingModel {
  final String drawingId;
  final String? noteId;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final int sectionNumber;
  final List<SketchModel> sketchList;

  DrawingModel({
    required this.createdAt,
    required this.modifiedAt,
    required this.sectionNumber,
    required this.sketchList,
    this.noteId,
    final String? drawingId,
  }) : drawingId = drawingId ?? const Uuid().v4();
}
