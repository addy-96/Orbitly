import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:noted_d/models/sketch_model.dart';

class DrawingPro with ChangeNotifier {
  final List<Offset> _drawingPoints = [];
 
  final List<SketchModel> _sketchList = [];

  final double _minStrokeWidth = 1;
  final double _maxStrokeWidth = 22;

  double _currentStrokeWidth = 4;

  Color _currentPaintColor = Color(0xFF000000);

  List<SketchModel> _sketchBuffer = [];

  //getters

  double get minStrokeWidth => _minStrokeWidth;

  double get maxStrokeWidth => _maxStrokeWidth;

  double get currentStrokeWidth => _currentStrokeWidth;

  Color get currentPaintColor => _currentPaintColor;

  List<Offset> get drawingPoints => _drawingPoints;

  List<SketchModel> get sketchList => _sketchList;
  List<SketchModel> get sketchBuffer => _sketchBuffer;

  void drawSketch({required Offset points}) {
    _drawingPoints.add(points);
    notifyListeners();
  }

  void addToSketch({required SketchModel sketch}) {
    final coppiedPoints = List<Offset>.from(drawingPoints);
    _drawingPoints.clear();
    sketchList.add(
      SketchModel(
        points: coppiedPoints,
        sketchColor: sketch.sketchColor,
        strokeWidth: sketch.strokeWidth,
      ),
    );

    _sketchBuffer = List<SketchModel>.from(sketchList);
    notifyListeners();
  }

  void undoSketch() {
    _sketchList.remove(_sketchList.last);
    log('sketch removed : ${sketchList.length}');
    log('sketch in buffer : ${sketchBuffer.length}');
    notifyListeners();
  }

  void redoSketch() {
    _sketchList.add(_sketchBuffer[_sketchList.length]);
    notifyListeners();
  }

  void selectStrokeWidth({required double stroke}) {
    _currentStrokeWidth = stroke;
    notifyListeners();
  }

  void selectColor({required Color selectedColor}) {
    _currentPaintColor = selectedColor;
    notifyListeners();
  }

  void resetStroke() {
    log('called');
    _currentStrokeWidth = 4;
    notifyListeners();
  }

}
