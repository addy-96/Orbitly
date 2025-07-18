import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/snackbr.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/widgets/task_inside_note.dart';
import 'package:provider/provider.dart';




class EditNotes extends StatefulWidget {
  const EditNotes({super.key, required this.noteId});
  final String noteId;
  
  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  
  late NotesPro notesPro;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    notesPro = Provider.of<NotesPro>(context, listen: false);
    if (_isFirstTime) {
      _isFirstTime = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notesPro.reset();
      });
    }
if (!_isInitialized) {
      _isInitialized = true;
      notesPro.editNoteInitialization(noteId: widget.noteId);
    }
  }

 
  bool _isInitialized = false;
  bool _isFirstTime = true;

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesPro>(context);

    return Hero(
      tag: widget.noteId,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (!didPop) {
            await notesProvider.saveNote(
              context: context,
              isForEditPage: true,
              noteId: widget.noteId,
            );
          }
          return;
        },
        child: Scaffold(
          appBar: AppBar(
            surfaceTintColor: Colors.transparent,
            forceMaterialTransparency: true,
            leading: IconButton(
              onPressed: () async {
                await notesProvider.saveNote(
                  context: context,
                  isForEditPage: true,
                  noteId: widget.noteId,
                );
              },
              icon: Icon(HugeIcons.strokeRoundedArrowLeft02),
            ),
            actions: [
              IconButton(
                onPressed: () async {

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
                  controller: notesProvider.titleController,
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
                    itemCount: notesProvider.sectionList.length,
                    itemBuilder: (context, index) {
                      final section = notesProvider.sectionList[index];
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
                            hintText: notesProvider.sectionList.length == 1
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
                      if (section is TaskBlock) {
                        return TaskInsideNote(
                          textController: section.textEditingController,
                          index: index,
                        );
                      }
                      if (section is GestureBlock) {
                        return GestureDetector(
                          onTap: () {
                            log('tapped');
                            notesProvider.addTextsection();
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height / 2,
                            color: Colors.yellow,
                            child: Align(
                              alignment: Alignment.bottomCenter,
                              child: Text('-----End----'),
                            ),
                          ),
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
                      onPressed: () async {
                        await notesProvider.addImageSection();
                      },
                      icon: Icon(HugeIcons.strokeRoundedImageAdd01),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(HugeIcons.strokeRoundedCurvyUpDownDirection),
                    ),
                    IconButton(
                      onPressed: () {
                        notesProvider.addTaskSection(context);
                      },
                      icon: Icon(HugeIcons.strokeRoundedCheckmarkSquare01),
                    ),
                    IconButton(
                      onPressed: () {
                        cSnack(
                          message: 'Feature comming soon!',
                          backgroundColor: Colors.white,
                          context: context,
                        );
                      },
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


