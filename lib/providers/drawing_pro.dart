import 'dart:io';
import 'dart:ui';
import 'package:Orbitly/models/sketch_model.dart';
import 'package:Orbitly/providers/notes_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

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

  final GlobalKey _drawingKey = GlobalKey();

  //getters

  double get minStrokeWidth => _minStrokeWidth;

  double get maxStrokeWidth => _maxStrokeWidth;

  double get currentStrokeWidth => _currentStrokeWidth;

  Color get currentPaintColor => _currentPaintColor;

  List<Offset> get drawingPoints => _drawingPoints;

  List<SketchModel> get sketchList => _sketchList;

  List<SketchModel> get sketchBuffer => _sketchBuffer;

  GlobalKey get drawingAreaKey => _drawingKey;

  bool _isEraserSelected = false;

  bool get isEraserSelected => _isEraserSelected;

  Future captureDrawingAndAdd(final BuildContext context) async {
    try {
      final boundary =
          _drawingKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary;

      final image = await boundary.toImage(pixelRatio: 3);

      final byteData = await image.toByteData(format: ImageByteFormat.png);

      final docsDirectory = await getApplicationDocumentsDirectory();

      final String drawingId = const Uuid().v4();

      String? imagePath;

      imagePath = '${docsDirectory.path}/$drawingId.png';

      final File imageFile = File(imagePath);

      await imageFile.writeAsBytes(byteData!.buffer.asInt8List());

      await addDrawingToNotesSection(
        imagePath: imagePath,
        sketchList: _sketchList,
        drawingId: drawingId,
        context: context,
      );
    } catch (err) {}
  }

  ////////////////////////////
  void drawSketch({required final Offset points}) {
    _drawingPoints.add(points);
    notifyListeners();
  }

  ////////////////////////////
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

  ////////////////////////////
  void undoSketch() {
    _sketchList.remove(_sketchList.last);
    notifyListeners();
  }

  ////////////////////////////
  void redoSketch() {
    _sketchList.add(_sketchBuffer[_sketchList.length]);
    notifyListeners();
  }

  ////////////////////////////
  void selectStrokeWidth({required final double stroke}) {
    _currentStrokeWidth = stroke;
    notifyListeners();
  }

  ////////////////////////////
  void selectColor({required final Color selectedColor}) {
    _currentPaintColor = selectedColor;
    notifyListeners();
  }

  //////////////////////////////
  void selectEraser() {
    _isEraserSelected = !_isEraserSelected;
    if (_isEraserSelected) {
      _currentStrokeWidth = 20;
    } else {
      _currentStrokeWidth = 4;
    }
    notifyListeners();
  }

  ////////////////////////////
  void resetStroke() {
    _currentStrokeWidth = 4;
    notifyListeners();
  }

  ////////////////////////////
  void resetCanvas() {
    _sketchList.clear();
    _sketchBuffer.clear();
  }

  ////////////////////////////
  Future addDrawingToNotesSection({
    required final String imagePath,
    required final List<SketchModel> sketchList,
    required final String drawingId,
    required final BuildContext context,
  }) async {
    await notesPro.addDrawingSection(
      context: context,
      drawingBlock: DrawingBlock(
        drawingImagePath: imagePath,
        drawingId: drawingId,
      ),
    );
    resetCanvas();
  }
}
