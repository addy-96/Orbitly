import 'dart:developer';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/providers/drawing_pro.dart';
import 'package:provider/provider.dart';

class DrawingPage extends StatelessWidget {
  const DrawingPage({super.key});

  //final List<Offset> points = [];

  @override
  Widget build(BuildContext context) {
    final drawingProvider = Provider.of<DrawingPro>(context);
    return Scaffold(

      appBar: AppBar(
        title: IconButton(
          onPressed: () {
            log(MediaQuery.of(context).devicePixelRatio.toString());
          },
          icon: Icon(HugeIcons.strokeRoundedAddFemale),
        ),
      ),
      body: Listener(
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
        onPointerUp: (event) {},
        child: CustomPaint(
          size: Size(
            MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height,
          ),
          painter: LinePainter(drawingProvider),
        ),
      ),
    );
  }
}

class LinePainter extends CustomPainter {
  const LinePainter(this.provider);

  final DrawingPro provider;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.red
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap;
    canvas.drawPoints(PointMode.polygon, provider.drawingPoints, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

/* 


Listener(
        onPointerDown: (event) {
          log('onPOintDown');
          log(' dx : ${event.position.dx}');
          log(' dy : ${event.position.dy}');
        },
        onPointerUp: (event) {
          log('onPOintUp');
          log(' dx : ${event.position.dx}');
          log(' dy : ${event.position.dy}');
        },
        onPointerMove: (event) {
          log('onPOintMove');
          log(' dx : ${event.position.dx}');
          log(' dy : ${event.position.dy}');
        },
        child: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black87,
        ),
      ),

      */