import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/snackbr.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/providers/notes_section_pro.dart';
import 'package:noted_d/widgets/task_inside_note.dart';
import 'package:provider/provider.dart';

class CreateNotesPage extends StatefulWidget {
  const CreateNotesPage({super.key});

  @override
  State<CreateNotesPage> createState() => _CreateNotesPageState();
}

class _CreateNotesPageState extends State<CreateNotesPage> {
  final _titleController = TextEditingController();

  

  @override
  void dispose() {
    _titleController.dispose();
    final notesSectionProvider = Provider.of<NotesSectionPro>(context);
    for (final block in notesSectionProvider.sectionList) {
      if (block is TextBlock) {
        block.textEditingController.dispose();
      }

      if (block is TaskBlock) {
        block.textEditingController.dispose();
      }
    }
    super.dispose();
  }

 

  

  /* void onBackAction(NotesPro notesProvider) async {
    
    /* for (var section in sectionList) {
      if (section is TextBlock) {
        log('text block count ${section.blokCount}');
      }
      if (section is Imageblock) {
        log('image block count ${section.blokCount}');
      }
    } */

    bool contentPresent = false;

    for (var section in sectionList) {

      if (section is Imageblock) {

        contentPresent = true;

        break;

      }
      if (section is TextBlock) {
        section.textEditingController.text.trim().isNotEmpty
            ? contentPresent = true
            : contentPresent = false;
      }
      /*  if (section is TaskBlock) {
        section.textEditingController.text.trim().isNotEmpty
            ? contentPresent = true
            : contentPresent = false;
      }*/
    }



    if (_titleController.text.trim().isNotEmpty) {
      contentPresent = true;
    }

    if (!contentPresent) {
      Navigator.of(context).pop();
      return;
    } else {
      final List<SectionModel> sectionModelList = [];

      String notesContentHiglight = '';
      bool gotTextHiglight = false;
      for (var item in sectionList) {
        SectionModel sectionModel;

        if (item is Imageblock) {
          notesContentHiglight = 'Image Note';
          sectionModel = SectionModel(
            sectionNo: item.blokCount,
            sectionType: 'I',
            sectionContnet: item.imagePath,
          );

          sectionModelList.add(sectionModel);
        } /*else if (item is TextBlock) {
          if (!gotTextHiglight) {
            if (item.textEditingController.text.trim().isNotEmpty) {
              if (item.textEditingController.text.length < 15) {
                notesContentHiglight = item.textEditingController.text
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
        }*/ 
      }
      if (_titleController.text.trim().isNotEmpty) {

        notesContentHiglight = _titleController.text.trim().length < 15
            ? _titleController.text.trim().substring(
                0,
                _titleController.text.trim().length - 1,
              )
            : _titleController.text.trim().substring(0, 15);
      }

      final NotesModel notesModel = NotesModel(
        createdAt: DateTime.now(),
        modifiedAt: DateTime.now(),
        notesTitle: _titleController.text,
        notesContentHighLight: notesContentHiglight,
        sectionList: sectionModelList,
      );

      await notesProvider.addNote(notesModel: notesModel);

      Navigator.of(context).pop();
      return;
    } */
 
  
  

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesPro>(context);
    final notesSectionProvider = Provider.of<NotesSectionPro>(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          //onBackAction(notesProvider);
        }
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          surfaceTintColor: Colors.transparent,
          forceMaterialTransparency: true,
          leading: IconButton(
            onPressed: () async {
              // onBackAction(notesProvider);
            },
            icon: Icon(HugeIcons.strokeRoundedArrowLeft02),
          ),
          actions: [
            IconButton(
              onPressed: () {
                for (var section in notesSectionProvider.sectionList) {
                  if (section is TextBlock) {
                    log('text block count ${section.blokCount}');
                  }
                  if (section is Imageblock) {
                    log('image block count ${section.blokCount}');
                  }
                  if (section is TaskBlock) {
                    log('task block count ${section.blockcount}');
                  }
                }
              },
              icon: Icon(HugeIcons.strokeRoundedShare01),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(HugeIcons.strokeRoundedTShirt),
            ),
            IconButton(
              onPressed: () {},
              icon: Icon(HugeIcons.strokeRoundedMenu08),
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
              Consumer<NotesSectionPro>(
                builder: (context, notesSectionProvider, child) {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: notesSectionProvider.sectionList.length,
                      itemBuilder: (context, index) {
                        final section = notesSectionProvider.sectionList[index];
                        if (section is TextBlock) {
                          return TextField(
                            autofocus: true,
                            keyboardType: TextInputType.multiline,
                            maxLines: null,
                            minLines: null,
                            style:
                                textStyleOS(
                                  fontSize: 18,
                                  fontColor: Colors.black,
                                ).copyWith(
                                  wordSpacing: 5,
                                  fontWeight: FontWeight.w400,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText:
                                  notesSectionProvider.sectionList.length == 1
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
                       else if (section is Imageblock) {
                          return Padding(
                            padding: EdgeInsetsGeometry.symmetric(
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
                                    borderRadius: BorderRadiusGeometry.circular(
                                      18,
                                    ),
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
                            ),
                          );
                        } else if (section is TaskBlock) {
                          return TaskInsideNote(
                            textController: section.textEditingController,
                          );
                        } else if (section is GestureBlock) {
                          return GestureDetector(
                            onTap: () {
                              notesSectionProvider.addTextsection();
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
                      },
                    ),
                  );
                },
              ),
             
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    onPressed: () async {
                      await notesSectionProvider.addImageSection();
                    },
                    icon: Icon(HugeIcons.strokeRoundedImageAdd01),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: Icon(HugeIcons.strokeRoundedCurvyUpDownDirection),
                  ),
                  IconButton(
                    onPressed: () {
                      notesSectionProvider.addTaskSection(context);
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
    );
  }

}
