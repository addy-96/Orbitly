import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/providers/settings_pro.dart';
import 'package:provider/provider.dart';

class NoteBodyDrawingImage extends StatelessWidget {
  const NoteBodyDrawingImage({
    super.key,
    required this.section,
    required this.index,
  });
  final DrawingBlock section;
  final int index;

  @override
  Widget build(final BuildContext context) {
    final notesSectionProvider = Provider.of<NotesPro>(context);
    final settingPro = Provider.of<SettingsPro>(context);
    final height = MediaQuery.of(context).size.height;

    final weidth = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            color: Colors.white,
            elevation: 10,
            borderRadius: BorderRadiusGeometry.circular(18),
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(18),
              child: Stack(
                children: [
                  Image.file(
                    alignment: Alignment.center,
                    File(section.drawingImagePath),
                    fit: BoxFit.contain,
                    height: height * 0.3,
                    width: weidth * 0.8,
                    scale: 0.2,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (final context) => AlertDialog(
                            backgroundColor: Colors.white,
                            content: Padding(
                              padding: const EdgeInsets.only(
                                top: 20,
                                left: 10,
                                right: 10,
                              ),
                              child: Text(
                                'The sketch will be permanently deleted are you sure?',
                                softWrap: true,
                                style: textStyleOS(
                                  fontSize: settingPro.getFontSize(),
                                  fontColor: Colors.black,
                                ),
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  notesSectionProvider.removeDrawingSection(
                                    drawingImagePath: section.drawingImagePath,
                                    index: index,
                                  );
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Remove',
                                  style: textStyleOS(
                                    fontSize: settingPro.getFontSize(),
                                    fontColor: Colors.black,
                                  ),
                                ),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  'Cancel',
                                  style: textStyleOS(
                                    fontSize: settingPro.getFontSize(),
                                    fontColor: themeOrange,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(
                        HugeIcons.strokeRoundedMultiplicationSignCircle,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
