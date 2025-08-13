import 'package:Orbitly/core/constant.dart';
import 'package:Orbitly/core/textstyle.dart';
import 'package:Orbitly/pages/drawing_page.dart';
import 'package:Orbitly/providers/drawing_pro.dart';
import 'package:Orbitly/providers/settings_pro.dart';
import 'package:Orbitly/widgets/drawing_eraser.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

class DrawingPageBottomToolbar extends StatelessWidget {
  const DrawingPageBottomToolbar({super.key});

  @override
  Widget build(final BuildContext context) {
    final drawingPro = Provider.of<DrawingPro>(context);
    final settingPro = Provider.of<SettingsPro>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: drawingPro.sketchList.isEmpty
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              drawingPro.isEraserSelected ? drawingPro.selectEraser() : null;
              showModalBottomSheet(
                backgroundColor: scaffoldBackgroudColor,
                isScrollControlled: true,
                showDragHandle: true,
                isDismissible: true,
                context: context,
                builder: (final context) => StatefulBuilder(
                  builder: (final context, final setState) {
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
                              fontSize: settingPro.getFontSize() * 1.5,
                              fontColor: Colors.black,
                            ).copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            drawPro.currentStrokeWidth.toStringAsPrecision(2),
                            style: textStyleOS(
                              fontSize: settingPro.getFontSize() * 1.5,
                              fontColor: Colors.black,
                            ).copyWith(fontWeight: FontWeight.w600),
                          ),
                          const Gap(10),
                          Row(
                            children: [
                              Expanded(
                                child: Slider(
                                  value: drawPro.currentStrokeWidth,
                                  min: drawPro.minStrokeWidth,
                                  max: drawPro.maxStrokeWidth,
                                  activeColor: themeOrange,
                                  thumbColor: themeOrange,
                                  onChanged: (final value) {
                                    drawPro.selectStrokeWidth(stroke: value);
                                  },
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  drawPro.resetStroke();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: themeOrange,
                                ),
                                child: Text(
                                  'Reset',
                                  style: textStyleOS(
                                    fontSize: settingPro.getFontSize(),
                                    fontColor: themeOrange,
                                  ),
                                ),
                              ),
                              const Gap(10),
                              ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: themeOrange,
                                ),
                                child: const Icon(
                                  HugeIcons.strokeRoundedMultiplicationSign,
                                ),
                              ),
                            ],
                          ),

                          const Gap(20),
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
                child: const Icon(HugeIcons.strokeRoundedPencil),
              ),
            ),
          ),
          const Gap(20),
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              showModalBottomSheet(
                backgroundColor: scaffoldBackgroudColor,
                isScrollControlled: true,
                showDragHandle: true,
                isDismissible: true,
                context: context,
                builder: (final context) => Padding(
                  padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom,
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
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
                                fontSize: settingPro.getFontSize() * 1.5,
                                fontColor: Colors.black,
                              ).copyWith(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 16),
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
                                              drawingPro.currentPaintColor ==
                                                      colorPallets[i]
                                                  ? Container(
                                                      width: 10,
                                                      height: 4,
                                                      decoration: BoxDecoration(
                                                        color: themeOrange,
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                              14,
                                                            ),
                                                      ),
                                                    )
                                                  : const SizedBox.shrink(),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ),
                                  const Align(
                                    alignment: Alignment.centerLeft,
                                    child: Icon(
                                      size: 30,
                                      HugeIcons.strokeRoundedArrowLeft01,
                                      color: Colors.black,
                                    ),
                                  ),
                                  const Align(
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
                  color: drawingPro.currentPaintColor,
                  border: Border.all(width: 3, color: Colors.white60),
                ),
              ),
            ),
          ),
          const Gap(20),
          drawingPro.sketchList.isEmpty
              ? const SizedBox.shrink()
              : const DrawingEraser(),
        ],
      ),
    );
  }
}
