import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:noted_d/models/sketch_model.dart';
import 'package:noted_d/providers/notes_pro.dart';

class DrawingPro with ChangeNotifier {
 
  DrawingPro({required this.notesPro});
  final NotesPro notesPro;

  final List<Offset> _drawingPoints = [];
 
  final List<SketchModel> _sketchList = [];

  final double _minStrokeWidth = 1;
  final double _maxStrokeWidth = 22;

  double _currentStrokeWidth = 4;

  Color _currentPaintColor = const Color(0xFF000000);

  List<SketchModel> _sketchBuffer = [];

  

  //getters

  double get minStrokeWidth => _minStrokeWidth;

  double get maxStrokeWidth => _maxStrokeWidth;

  double get currentStrokeWidth => _currentStrokeWidth;

  Color get currentPaintColor => _currentPaintColor;

  List<Offset> get drawingPoints => _drawingPoints;

  List<SketchModel> get sketchList => _sketchList;
  List<SketchModel> get sketchBuffer => _sketchBuffer;

  void drawSketch({required final Offset points}) {
    _drawingPoints.add(points);
    notifyListeners();
  }

  void addToSketch({required final SketchModel sketch}) {
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

  void selectStrokeWidth({required final double stroke}) {
    _currentStrokeWidth = stroke;
    notifyListeners();
  }

  void selectColor({required final Color selectedColor}) {
    _currentPaintColor = selectedColor;
    notifyListeners();
  }

  void resetStroke() {
    _currentStrokeWidth = 4;
    notifyListeners();
  }

  void resetCanvas() {}

  Future saveDrawing({
    required final String imagePath,
    required final List<SketchModel> sketchList,
    required final String drawingId,
    required final BuildContext context,
  }) async {
    await notesPro.addDrawingSection(
      context: context,
      drawingBlock: DrawingBlock(
        drawingImagePath: imagePath,
        sketchList: sketchList,
        drawingId: drawingId,
      ),
    );
  }

}
