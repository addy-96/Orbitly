import 'dart:developer';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/models/sketch_model.dart';
import 'package:noted_d/providers/drawing_pro.dart';
import 'package:provider/provider.dart';

class DrawingPage extends StatefulWidget {
  const DrawingPage({super.key});

  @override
  State<DrawingPage> createState() => _DrawingPageState();
}

class _DrawingPageState extends State<DrawingPage> {
  final List<Color> colorPallets = [
    Color(0xFF000000), // Black
    Color(0xFFF44336), // Red
    Color(0xFF4CAF50), // Green
    Color(0xFF2196F3), // Blue
    Color(0xFFFFEB3B), // Yellow
    Color(0xFFFF9800), // Orange
    Color(0xFF9C27B0), // Purple
    Color(0xFFE91E63), // Pink
    Color(0xFF795548), // Brown
    Color(0xFF9E9E9E), // Grey
    Color(0xFF81D4FA), // Baby Blue
    Color(0xFFA5D6A7), // Mint Green
    Color(0xFFF8BBD0), // Cotton Candy Pink
    Color(0xFFFFCCBC), // Peach
    Color(0xFFCE93D8), // Lavender
    Color(0xFF4FC3F7), // Sky Blue
    Color(0xFFFFF59D), // Light Yellow
    Color(0xFFE0E0E0), // Light Grey
    Color(0xFFFF8A65), // Coral
  ];


  @override
  Widget build(BuildContext context) {
    final drawingProvider = Provider.of<DrawingPro>(context, listen: true);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
        leading: IconButton(
          onPressed: () {
            if (drawingProvider.sketchList.isEmpty) {
              Navigator.of(context).pop();
            } 
  
          },
          icon: Icon(HugeIcons.strokeRoundedMultiplicationSign, size: 30),
        ),
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              onPressed: drawingProvider.sketchList.isEmpty
                  ? null
                  : () {
                      drawingProvider.undoSketch();
                    },
              icon: Transform.flip(
                flipX: true,
                flipY: true,
                child: Icon(HugeIcons.strokeRoundedArrowTurnForward, size: 30),
              ),
            ),
            IconButton(
              onPressed:
                  drawingProvider.sketchList.length ==
                      drawingProvider.sketchBuffer.length
                  ? null
                  : () {
                      drawingProvider.redoSketch();
                    },
              icon: Transform.flip(
                flipX: true,
                flipY: true,
                child: Icon(size: 30, HugeIcons.strokeRoundedArrowTurnBackward),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {
              log(drawingProvider.sketchList.first.points.toString());
            },
            icon: Icon(HugeIcons.strokeRoundedTick02, size: 30),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Listener(
              onPointerDown: (event) {
                log(' dx : ${event.position.dx}');
                log(' dy : ${event.position.dy}');
                log('onPointDown');
                drawingProvider.drawSketch(
                  points: Offset(event.position.dx, event.position.dy),
                );
              },
              onPointerMove: (event) {
                log('onPointMove');
                log(' dx : ${event.position.dx}');
                log(' dy : ${event.position.dy}');
                drawingProvider.drawSketch(
                  points: Offset(event.position.dx, event.position.dy),
                );
              },
              onPointerUp: (event) {
                log('added to sketch');
                drawingProvider.addToSketch(
                  sketch: SketchModel(
                    points: drawingProvider.drawingPoints,
                    sketchColor: drawingProvider.currentPaintColor,
                    strokeWidth: drawingProvider.currentStrokeWidth,
                  ),
                );
              },
              child: RepaintBoundary(
                child: CustomPaint(
                  size: Size(double.infinity, 200),
                  painter: PaintingCanvas(drawingProvider),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: drawingProvider.sketchList.isEmpty
                  ? MainAxisAlignment.center
                  : MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      showDragHandle: true,
                      isDismissible: true,
                      context: context,
                      builder: (context) => StatefulBuilder(
                        builder: (context, setState) {
                          final drawPro = Provider.of<DrawingPro>(context);
                          return Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Set Stroke',
                                  style: textStyleOS(
                                    fontSize: 18,
                                    fontColor: Colors.black,
                                  ).copyWith(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  drawPro.currentStrokeWidth
                                      .toStringAsPrecision(2),
                                  style: textStyleOS(
                                    fontSize: 15,
                                    fontColor: Colors.black,
                                  ).copyWith(fontWeight: FontWeight.w600),
                                ),
                                Gap(10),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Slider(
                                        value: drawPro.currentStrokeWidth,
                                        min: drawPro.minStrokeWidth,
                                        max: drawPro.maxStrokeWidth,
                                        activeColor: Colors.deepOrange,
                                        thumbColor: Colors.deepOrange,
                                        onChanged: (value) {
                                          log(value.toString());
                                          drawPro.selectStrokeWidth(
                                            stroke: value,
                                          );
                                        },
                                      ),
                                    ),
                                    ElevatedButton(
                                      onPressed: () {
                                        drawPro.resetStroke();
                                      },
                                      child: Text('Reset'),
                                    ),
                                    Gap(10),
                                    ElevatedButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Icon(
                                        HugeIcons
                                            .strokeRoundedMultiplicationSign,
                                      ),
                                    ),
                                  ],
                                ),

                                Gap(20),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                  child: Material(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.transparent,
                    elevation: 10,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: Colors.white,
                        border: Border.all(width: 3, color: Colors.white60),
                      ),
                      child: Icon(HugeIcons.strokeRoundedPencil),
                    ),
                  ),
                ),
                Gap(20),
                InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      showDragHandle: true,
                      isDismissible: true,
                      context: context,
                      builder: (context) => Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom,
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(30),
                            ),
                          ),
                          child: SingleChildScrollView(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 10,
                                right: 10,
                                bottom: 25,
                                top: 10,
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min, // Important!
                                children: [
                                  Text(
                                    'Select Paint color',
                                    style: textStyleOS(
                                      fontSize: 18,
                                      fontColor: Colors.black,
                                    ).copyWith(fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 16),
                                  SizedBox(
                                    height:
                                        60, // Fixed height for horizontal ListView
                                    child: Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: 25,
                                            right: 25,
                                          ),
                                          child: ListView(
                                            scrollDirection: Axis.horizontal,
                                            children: [
                                              for (
                                                var i = 0;
                                                i < colorPallets.length;
                                                i++
                                              )
                                                Column(
                                                  children: [
                                                    ColorPalletOption(
                                                      color: colorPallets[i],
                                                    ),
                                                    drawingProvider
                                                                .currentPaintColor ==
                                                            colorPallets[i]
                                                        ? Container(
                                                            width: 10,
                                                            height: 4,
                                                            decoration: BoxDecoration(
                                                              color: Colors
                                                                  .deepOrange,
                                                              borderRadius:
                                                                  BorderRadius.circular(
                                                                    14,
                                                                  ),
                                                            ),
                                                          )
                                                        : SizedBox.shrink(),
                                                  ],
                                                ),
                                            ],
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Icon(
                                            size: 30,
                                            HugeIcons.strokeRoundedArrowLeft01,
                                            color: Colors.black,
                                          ),
                                        ),
                                        Align(
                                          alignment: Alignment.centerRight,
                                          child: Icon(
                                            size: 30,
                                            HugeIcons.strokeRoundedArrowRight01,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                  child: Material(
                    borderRadius: BorderRadius.circular(14),
                    color: Colors.transparent,
                    elevation: 10,
                    child: Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        color: drawingProvider.currentPaintColor,
                        border: Border.all(width: 3, color: Colors.white60),
                      ),
                    ),
                  ),
                ),
                Gap(20),
                drawingProvider.sketchList.isEmpty
                    ? SizedBox.shrink()
                    : InkWell(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(10),
                          bottomLeft: Radius.circular(4),
                          bottomRight: Radius.circular(4),
                        ),
                        onTap: () {},
                        child: Material(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(4),
                            bottomRight: Radius.circular(4),
                          ),
                          elevation: 10,
                          child: Container(
                            height: 60,
                            width: 40,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 247, 204, 193),
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(10),
                                bottomLeft: Radius.circular(4),
                                bottomRight: Radius.circular(4),
                              ),
                            ),
                          ),
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}

class PaintingCanvas extends CustomPainter {
  const PaintingCanvas(this.provider);

  final DrawingPro provider;

@override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
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
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}








class ColorPalletOption extends StatelessWidget {
  const ColorPalletOption({super.key, required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
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


































