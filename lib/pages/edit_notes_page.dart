import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/pages/create_notes_page.dart';
import 'package:noted_d/models/notes_model.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:provider/provider.dart';

class EditNotes extends StatefulWidget {
  const EditNotes({super.key, required this.notesModel});
  final NotesModel notesModel;

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  final List<NoteBlocks> newSectionList = [];

  void setSections() {
    for (var item in widget.notesModel.sectionList) {
      if (item.sectionType == 'T') {
        newSectionList.add(
          TextBlock(
            textEditingController: TextEditingController(
              text: item.sectionContnet,
            ),
            blokCount: item.sectionNo,
          ),
        );
      }
      if (item.sectionType == 'I') {
        newSectionList.add(
          Imageblock(imagePath: item.sectionContnet, blokCount: item.sectionNo),
        );
      }
    }
  }

  late TextEditingController _titleController;

  @override
  void dispose() {
    _titleController.dispose();

    for (var item in newSectionList) {
      if (item is TextBlock) {
        item.textEditingController.dispose();
      }
    }

    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.notesModel.notesTitle,
    );

    setSections();
  }

  onImageSelection() async {
    try {
      final selectImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (selectImage == null) {
        return;
      }

      log(selectImage.path);
      log(newSectionList.length.toString());
      int size = newSectionList.length;
      setState(() {
        newSectionList.add(
          Imageblock(imagePath: selectImage.path, blokCount: ++size),
        );
        newSectionList.add(
          TextBlock(
            textEditingController: TextEditingController(),
            blokCount: ++size,
          ),
        );
      });
    } catch (eerr) {
      log(eerr.toString());
    }
  }

  void onBackAction(NotesPro notesProvider) async {
    try {
      bool contentPresent = false;

      for (var section in newSectionList) {
        if (section is Imageblock) {
          contentPresent = true;
          break;
        }
        if (section is TextBlock) {
          section.textEditingController.text.trim().isNotEmpty
              ? contentPresent = true
              : contentPresent = false;
        }
      }
      if (_titleController.text.trim().isNotEmpty) {
        contentPresent = true;
      }

      if (!contentPresent) {
        await notesProvider.deleteNote(notesId: widget.notesModel.notesId);
        Navigator.of(context).pop();
        return;
      } else {
        final List<SectionModel> sectionModelList = [];

        String notesContentHiglight = '';
        bool gotTextHiglight = false;
        for (var item in newSectionList) {
          SectionModel sectionModel;

          if (item is Imageblock) {
            notesContentHiglight = 'Image Note';
            sectionModel = SectionModel(
              sectionNo: item.blokCount,
              sectionType: 'I',
              sectionContnet: item.imagePath,
            );

            sectionModelList.add(sectionModel);
          } else if (item is TextBlock) {
            if (!gotTextHiglight) {
              if (item.textEditingController.text.trim().isNotEmpty) {
                if (item.textEditingController.text.trim().length < 15) {
                  notesContentHiglight = item.textEditingController.text
                      .trim()
                      .substring(0, item.textEditingController.text.length - 1);
                } else {
                  notesContentHiglight = item.textEditingController.text
                      .trim()
                      .substring(0, 15);
                  gotTextHiglight = true;
                }
              }
            }
            sectionModel = SectionModel(
              sectionNo: item.blokCount,
              sectionType: 'T',
              sectionContnet: item.textEditingController.text,
            );

            sectionModelList.add(sectionModel);
          }
        }
        if (_titleController.text.trim().isNotEmpty) {
          if (_titleController.text.trim().length < 15) {
            notesContentHiglight = _titleController.text.trim().substring(
              0,
              _titleController.text.trim().length - 1,
            );
          } else {
            notesContentHiglight = _titleController.text.trim().substring(0);
          }
        }
        final NotesModel notesModel = NotesModel(
          notesId: widget.notesModel.notesId,
          createdAt: widget.notesModel.createdAt,
          modifiedAt: DateTime.now(),
          notesTitle: _titleController.text,
          notesContentHighLight: notesContentHiglight,
          sectionList: sectionModelList,
        );
        await notesProvider.updateNote(notesModel: notesModel);

        Navigator.of(context).pop();
        return;
      }
    } catch (err) {
      log(err.toString());
      throw Exception();
    }
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesPro>(context);
    return Hero(
      tag: widget.notesModel.notesId,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) {
          if (!didPop) {
            onBackAction(notesProvider);
          }
          return;
        },
        child: Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            forceMaterialTransparency: true,
            leading: IconButton(
              onPressed: () async {
                onBackAction(notesProvider);
              },
              icon: Icon(HugeIcons.strokeRoundedArrowLeft02),
            ),
            actions: [
              IconButton(
                onPressed: () {
                  log('opened noteId ${widget.notesModel.notesId}');
                },
                icon: Icon(HugeIcons.strokeRoundedShare01),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(HugeIcons.strokeRoundedTShirt),
              ),
              PopupMenuButton(
                borderRadius: BorderRadius.circular(19),

                icon: Icon(HugeIcons.strokeRoundedMenu08),
                color: Colors.white,
                menuPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
                popUpAnimationStyle: AnimationStyle(
                  curve: Curves.ease,
                  duration: Duration(milliseconds: 200),
                  reverseCurve: Curves.ease,
                  reverseDuration: Duration(milliseconds: 200),
                ),
                position: PopupMenuPosition.under,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(19),
                ),
                itemBuilder: (context) {
                  return [
                    PopupMenuItem(
                      child: Text(
                        'Item 1',
                        style: textStyleOS(
                          fontSize: 18,
                          fontColor: Colors.black,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: Text(
                        'Item 2',
                        style: textStyleOS(
                          fontSize: 18,
                          fontColor: Colors.black,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: Text(
                        'Item 3',
                        style: textStyleOS(
                          fontSize: 18,
                          fontColor: Colors.black,
                        ),
                      ),
                    ),
                    PopupMenuItem(
                      child: Text(
                        'Item 4',
                        style: textStyleOS(
                          fontSize: 18,
                          fontColor: Colors.black,
                        ),
                      ),
                    ),
                  ];
                },
              ),
            ],
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                Gap(10),
                TextField(
                  controller: _titleController,
                  style: textStyleOS(
                    fontSize: 25,
                    fontColor: Colors.grey.shade400,
                  ).copyWith(fontWeight: FontWeight.w700),
                  decoration: InputDecoration(
                    hintText: 'Title',
                    hintStyle: textStyleOS(
                      fontSize: 25,
                      fontColor: Colors.grey.shade400,
                    ).copyWith(fontWeight: FontWeight.w700),
                    border: InputBorder.none,
                  ),
                ),
                Gap(10),
                Text(
                  '${getDateTime().day} ${months[getDateTime().month]} ${getDateTime().hour > 12 ? getDateTime().hour - 12 : getDateTime().hour}:${getDateTime().minute < 10 ? '0${getDateTime().minute}' : getDateTime().minute}  ${getDateTime().hour >= 12 && getDateTime().hour <= 24 ? 'PM' : 'AM'} |  Characters',
                  style: textStyleOS(
                    fontSize: 14,
                    fontColor: Colors.grey.shade400,
                  ).copyWith(fontWeight: FontWeight.w400),
                ),
                Gap(10),
                Flexible(
                  child: ListView.builder(
                    itemCount: newSectionList.length,
                    itemBuilder: (context, index) {
                      final section = newSectionList[index];
                      if (section is TextBlock) {
                        return TextField(
                          keyboardType: TextInputType.multiline,
                          maxLines: null,
                          minLines: null,
                          style:
                              textStyleOS(
                                fontSize: 20,
                                fontColor: Colors.black,
                              ).copyWith(
                                wordSpacing: 5,
                                fontWeight: FontWeight.w400,
                                overflow: TextOverflow.ellipsis,
                              ),
                          decoration: InputDecoration(
                            border: InputBorder.none,
                            hintText: newSectionList.length == 1
                                ? 'Start Your note...'
                                : '',
                            hintStyle: textStyleOS(
                              fontSize: 20,
                              fontColor: Colors.grey.shade400,
                            ).copyWith(fontWeight: FontWeight.w300),

                            contentPadding: EdgeInsets.symmetric(
                              vertical: 10,
                              horizontal: 0,
                            ),
                            isDense: false,
                          ),
                          controller: section.textEditingController,
                        );
                      }
                      if (section is Imageblock) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Material(
                              color: Colors.transparent,
                              elevation: 10,
                              child: ClipRRect(
                                borderRadius: BorderRadiusGeometry.circular(18),
                                child: Image.file(
                                  alignment: Alignment.center,
                                  File(section.imagePath),
                                  fit: BoxFit.contain,
                                  height: 300,

                                  scale: 0.2,
                                ),
                              ),
                            ),
                          ],
                        );
                      }
                      return null;
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () {
                        onImageSelection();
                      },
                      icon: Icon(HugeIcons.strokeRoundedImageAdd01),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(HugeIcons.strokeRoundedCurvyUpDownDirection),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(HugeIcons.strokeRoundedCheckmarkSquare01),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(HugeIcons.strokeRoundedText),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
