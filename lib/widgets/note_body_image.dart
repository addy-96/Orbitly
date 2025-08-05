import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:provider/provider.dart';

class NoteBodyImage extends StatelessWidget {
  const NoteBodyImage({super.key, required this.section, required this.index});

  final Imageblock section;
  final int index;

  @override
  Widget build(final BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final notesSectionProvider = Provider.of<NotesPro>(context);
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(vertical: 10, horizontal: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Material(
            color: Colors.transparent,
            elevation: 10,
            child: ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(18),
              child: Stack(
                children: [
                  Image.file(
                    alignment: Alignment.center,
                    File(section.imagePath),
                    fit: BoxFit.contain,
                    height: height * 0.3,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: IconButton(
                      onPressed: () {
                        notesSectionProvider.removeImageOrTask(index: index);
                      },
                      icon: const Icon(
                        HugeIcons.strokeRoundedMultiplicationSignCircle,
                        color: Colors.white,
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
