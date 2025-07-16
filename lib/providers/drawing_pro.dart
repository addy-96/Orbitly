import 'package:flutter/widgets.dart';

class DrawingPro with ChangeNotifier {
  final List<Offset> _drawingPoints = [];

  List<Offset> get drawingPoints => _drawingPoints;

  void drawSketch({required Offset points}) {
    _drawingPoints.add(points);
    notifyListeners();
  }
}
