import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class DrawingPage extends StatelessWidget {
  const DrawingPage({super.key});

  @override
  Widget build(BuildContext context) {
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
    );
  }
}

/*class LinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()..strokeWidth = 4;
    Offset center = Offset(size.width / 2, size.height / 2);
final Paragraph paragraph = Paragraph._contentController;
    canvas.drawParagraph(, offset)
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
*/
