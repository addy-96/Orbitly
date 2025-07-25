import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/providers/drawing_pro.dart';
import 'package:provider/provider.dart';

class DrawingPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DrawingPageAppBar({super.key});

  void onBackAction({
    required final DrawingPro drawingPro,
    required final BuildContext context,
  }) {
    if (drawingPro.sketchList.isEmpty) {
      Navigator.of(context).pop();
    } else {
      log('show dialog to confirm dismis or save drawings');
    }
  }


  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);


  @override
  PreferredSizeWidget build(final BuildContext context) {
    final drawingPro = Provider.of<DrawingPro>(context);
    return AppBar(
      backgroundColor: Colors.deepOrange,
      leading: IconButton(
        onPressed: () {
          onBackAction(drawingPro: drawingPro, context: context);
        },
        icon: const Icon(HugeIcons.strokeRoundedMultiplicationSign, size: 30),
      ),
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: drawingPro.sketchList.isEmpty
                ? null
                : () {
                    drawingPro.undoSketch();
                  },
            icon: Transform.flip(
              flipX: true,
              flipY: true,
              child: const Icon(
                HugeIcons.strokeRoundedArrowTurnForward,
                size: 30,
              ),
            ),
          ),
          IconButton(
            onPressed:
                drawingPro.sketchList.length == drawingPro.sketchBuffer.length
                ? null
                : () {
                    drawingPro.redoSketch();
                  },
            icon: Transform.flip(
              flipX: true,
              flipY: true,
              child: const Icon(
                size: 30,
                HugeIcons.strokeRoundedArrowTurnBackward,
              ),
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () async {
            await drawingPro.captureDrawingAndAdd(context);
          },
          icon: const Icon(HugeIcons.strokeRoundedTick02, size: 30),
        ),
      ],
    );
  }
}
