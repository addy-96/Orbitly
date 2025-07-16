import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/snackbr.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/pages/drawing_page.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/widgets/task_inside_note.dart';
import 'package:provider/provider.dart';

class CreateNotesPage extends StatefulWidget {
  const CreateNotesPage({super.key});

  @override
  State<CreateNotesPage> createState() => _CreateNotesPageState();
}

class _CreateNotesPageState extends State<CreateNotesPage> {

late NotesPro notesPro;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstTime) {
      _isFirstTime = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notesPro = Provider.of<NotesPro>(context, listen: false);
        notesPro.reset();
      });
    }
  }

  bool _isFirstTime = true;



  @override
  Widget build(BuildContext context) {
    final notesSectionProvider = Provider.of<NotesPro>(
      context,
      listen: false,
    );
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (!didPop) {
          await notesSectionProvider.saveNote(
            context: context,
            isForEditPage: false,
            noteId: null,
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
              await notesSectionProvider.saveNote(
                context: context,
                isForEditPage: false,
                noteId: null,
              );

            },
            icon: Icon(HugeIcons.strokeRoundedArrowLeft02),
          ),
          actions: [
            IconButton(
              onPressed: () {
        
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
                controller: notesSectionProvider.titleController,
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
              Consumer<NotesPro>(
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
                                    child: Stack(
                                      children: [
                                        Image.file(
                                          alignment: Alignment.center,
                                          File(section.imagePath),
                                          fit: BoxFit.contain,
                                          height: 300,
                                          scale: 0.2,
                                        ),
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: IconButton(
                                            onPressed: () {
                                              log('tapped');
                                              notesSectionProvider
                                                  .removeImageOrTask(
                                                    index: index,
                                                  );
                                            },
                                            icon: Icon(
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
                        return null;
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
                    onPressed: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => DrawingPage()),
                      );
                    },
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
