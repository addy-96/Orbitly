import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/drawing_pro.dart';
import 'package:noted_d/providers/settings_pro.dart';
import 'package:provider/provider.dart';

class DrawingPageAppBar extends StatelessWidget implements PreferredSizeWidget {
  const DrawingPageAppBar({super.key});

  void onBackAction({
    required final DrawingPro drawingPro,
    required final BuildContext context,
    required final SettingsPro settingsPro,
  }) {
    if (drawingPro.sketchList.isEmpty) {
      Navigator.of(context).pop();
    } else {
      showDialog(
        context: context,
        builder: (final context) {
          return AlertDialog(
            backgroundColor: scaffoldBackgroudColor,
            title: Text(
              'Discard Changes?',
              textAlign: TextAlign.center,
              style: textStyleOS(
                fontSize: settingsPro.getFontSize() * 1.5,
                fontColor: Colors.black,
              ).copyWith(fontWeight: FontWeight.bold),
            ),
            content: Text(
              'You have unsaved changes. Are you sure you want to discard them?',
              style: textStyleOS(
                fontSize: settingsPro.getFontSize() * 1.2,
                fontColor: Colors.black,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Cancel',
                  style: textStyleOS(
                    fontSize: settingsPro.getFontSize() * 1.1,
                    fontColor: themeOrange,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  drawingPro.resetCanvas();
                  Navigator.of(context).pop();
                  Navigator.of(context).pop();
                },
                child: Text(
                  'Discard',
                  style: textStyleOS(
                    fontSize: settingsPro.getFontSize() * 1.1,
                    fontColor: Colors.black,
                  ),
                ),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  PreferredSizeWidget build(final BuildContext context) {
    final drawingPro = Provider.of<DrawingPro>(context);
    final settingsPro = Provider.of<SettingsPro>(context);
    return AppBar(
      backgroundColor: scaffoldBackgroudColor,
      forceMaterialTransparency: true,
      leading: IconButton(
        onPressed: () {
          onBackAction(
            drawingPro: drawingPro,
            context: context,
            settingsPro: settingsPro,
          );
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
