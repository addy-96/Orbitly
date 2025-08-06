import 'package:flutter/material.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/providers/drawing_pro.dart';
import 'package:provider/provider.dart';

class DrawingEraser extends StatelessWidget {
  const DrawingEraser({super.key});

  @override
  Widget build(final BuildContext context) {
    final drawingPro = Provider.of<DrawingPro>(context);
    return InkWell(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(20),
        topRight: Radius.circular(10),
        bottomLeft: Radius.circular(4),
        bottomRight: Radius.circular(4),
      ),
      onTap: () {
        drawingPro.selectEraser();
      },
      child: Material(
        borderRadius: const BorderRadius.only(
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
            color: drawingPro.isEraserSelected
                ? themeOrange
                : const Color.fromARGB(255, 247, 204, 193),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(10),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(4),
            ),
          ),
        ),
      ),
    );
  }
}
