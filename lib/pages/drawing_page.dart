import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:noted_d/models/sketch_model.dart';
import 'package:noted_d/providers/drawing_pro.dart';
import 'package:noted_d/widgets/drawing_page_app_bar.dart';
import 'package:noted_d/widgets/drawing_page_bottom_toolbar.dart';
import 'package:noted_d/widgets/painting_canvas.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}




class _DrawingPageState extends State<DrawingPage> {
  final GlobalKey _drawingKey = GlobalKey();
  String? imagePath;
  final String drawingId = const Uuid().v4();

  Future captureDrawingAndAdd(final DrawingPro drawingProvider) async {
    try {
      final boundary =
          _drawingKey.currentContext?.findRenderObject()
              as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 3);
      final byteData = await image.toByteData(format: ImageByteFormat.png);
      final docsDirectory = await getApplicationDocumentsDirectory();
      imagePath = '${docsDirectory.path}/$drawingId.png';
      if (imagePath == null) {
        return;
      }
      final File imageFile = File(imagePath!);
      await imageFile.writeAsBytes(byteData!.buffer.asInt8List());
      log(imagePath!);
      await drawingProvider.saveDrawing(
        imagePath: imagePath!,
        sketchList: drawingProvider.sketchList,
        drawingId: drawingId,
        context: context,
      );
    } catch (err) {
      log(err.toString());
    }
  }




  @override
  Widget build(final BuildContext context) {
    final drawingProvider = Provider.of<DrawingPro>(context, listen: true);
    return Scaffold(
      appBar: const DrawingPageAppBar() as PreferredSizeWidget,
      body: Column(
        children: [
          Expanded(
            child: Listener(
              onPointerDown: (final event) {
                //     log('onPointDown -----> dx : ${event.position.dx} , dy : ${event.position.dy}');
                drawingProvider.drawSketch(
                  points: Offset(event.position.dx, event.position.dy),
                );
              },
              onPointerMove: (final event) {
                //     log('onPointMove -----> dx : ${event.position.dx} , dy : ${event.position.dy}');
                drawingProvider.drawSketch(
                  points: Offset(event.position.dx, event.position.dy),
                );
              },
              onPointerUp: (final event) {
                //    log('added to sketch');
                drawingProvider.addToSketch(
                  sketch: SketchModel(
                    points: drawingProvider.drawingPoints,
                    sketchColor: drawingProvider.currentPaintColor,
                    strokeWidth: drawingProvider.currentStrokeWidth,
                  ),
                );
              },
              child: RepaintBoundary(
                key: _drawingKey,
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


































