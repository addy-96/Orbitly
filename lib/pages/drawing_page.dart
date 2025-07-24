import 'package:flutter/material.dart';
import 'package:noted_d/models/sketch_model.dart';
import 'package:noted_d/providers/drawing_pro.dart';
import 'package:noted_d/widgets/drawing_page_app_bar.dart';
import 'package:noted_d/widgets/drawing_page_bottom_toolbar.dart';
import 'package:noted_d/widgets/painting_canvas.dart';
import 'package:provider/provider.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}




class _DrawingPageState extends State<DrawingPage> {

  @override
  Widget build(final BuildContext context) {
    final drawingProvider = Provider.of<DrawingPro>(context, listen: true);
    return Scaffold(
      appBar: const DrawingPageAppBar(),
      body: Column(
        children: [
          Expanded(
            child: Listener(
              onPointerDown: (final event) {
                //log('onPointDown -----> dx : ${event.position.dx} , dy : ${event.position.dy}');
                drawingProvider.drawSketch(
                  points: Offset(event.position.dx, event.position.dy),
                );
              },
              onPointerMove: (final event) {
                //log('onPointMove -----> dx : ${event.position.dx} , dy : ${event.position.dy}');
                drawingProvider.drawSketch(
                  points: Offset(event.position.dx, event.position.dy),
                );
              },
              onPointerUp: (final event) {
                drawingProvider.addToSketch(
                  sketch: SketchModel(
                    points: drawingProvider.drawingPoints,
                    sketchColor: drawingProvider.currentPaintColor,
                    strokeWidth: drawingProvider.currentStrokeWidth,
                  ),
                );
              },
              child: RepaintBoundary(
                key: drawingProvider.drawingAreaKey,
                child: CustomPaint(
                  size: const Size(double.infinity, 200),
                  painter: PaintingCanvas(drawingProvider),
                ),
              ),
            ),
          ),
          const DrawingPageBottomToolbar(),
        ],
      ),
    );
  }

}









class ColorPalletOption extends StatelessWidget {
  const ColorPalletOption({super.key, required this.color});

  final Color color;

  @override
  Widget build(final BuildContext context) {
    final drawingProvider = Provider.of<DrawingPro>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          drawingProvider.selectColor(selectedColor: color);
          Navigator.of(context).pop();
        },
        child: Material(
          borderRadius: BorderRadius.circular(14),
          color: Colors.transparent,
          elevation: 1,
          child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: color,
              border: Border.all(width: 3, color: Colors.white60),
            ),
          ),
        ),
      ),
    );
  }
}


































