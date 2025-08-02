import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/widgets/task_inside_note.dart';
import 'package:provider/provider.dart';

class CreateEditNoteBody extends StatelessWidget {
  const CreateEditNoteBody({super.key});

  @override
  Widget build(final BuildContext context) {
    return Consumer<NotesPro>(
      builder: (final context, final notesSectionProvider, final child) {
        return Expanded(
          child: ListView.builder(
            itemCount: notesSectionProvider.sectionList.length,
            itemBuilder: (final context, final index) {
              final section = notesSectionProvider.sectionList[index];
              if (section is TextBlock) {
                return TextField(
                  controller: section.textEditingController,
                  autofocus: true,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  minLines: null,
                  style: textStyleOS(fontSize: 18, fontColor: Colors.black)
                      .copyWith(
                        wordSpacing: 5,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                      ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: notesSectionProvider.sectionList.length == 1
                        ? 'Start Your note...'
                        : '',
                    hintStyle: textStyleOS(
                      fontSize: 20,
                      fontColor: Colors.grey.shade400,
                    ).copyWith(fontWeight: FontWeight.w300),
                    contentPadding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 0,
                    ),
                    isDense: false,
                  ),
                );
              } else if (section is Imageblock) {
                return Padding(
                  padding: const EdgeInsetsGeometry.symmetric(
                    vertical: 10,
                    horizontal: 0,
                  ),
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
                                height: 300,
                              ),
                              Positioned(
                                right: 0,
                                top: 0,
                                child: IconButton(
                                  onPressed: () {
                                    notesSectionProvider.removeImageOrTask(
                                      index: index,
                                    );
                                  },
                                  icon: const Icon(
                                    HugeIcons
                                        .strokeRoundedMultiplicationSignCircle,
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
              } else if (section is TaskBlock) {
                return TaskInsideNote(
                  textController: section.textEditingController,
                  index: index,
                );
              } else if (section is DrawingBlock) {
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
                                height: 300,
                                width: 300,
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
                                              fontSize: 12,
                                              fontColor: Colors.black,
                                            ),
                                          ),
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed: () {
                                              notesSectionProvider
                                                  .removeDrawingSection(
                                                    drawingImagePath: section
                                                        .drawingImagePath,
                                                    index: index,
                                                  );
                                              Navigator.of(context).pop();
                                            },
                                            child: Text(
                                              'Remove',
                                              style: textStyleOS(
                                                fontSize: 12,
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
                                                fontSize: 12,
                                                fontColor: Colors.deepOrange,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                  icon: const Icon(
                                    HugeIcons
                                        .strokeRoundedMultiplicationSignCircle,
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
              } else if (section is GestureBlock) {
                return GestureDetector(
                  onTap: () {
                    notesSectionProvider.addTextsection();
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.transparent,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}
