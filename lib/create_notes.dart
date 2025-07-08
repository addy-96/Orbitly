import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/models/notes_model.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:provider/provider.dart';

class CreateNotesPage extends StatefulWidget {
  const CreateNotesPage({super.key});

  @override
  State<CreateNotesPage> createState() => _CreateNotesPageState();
}

class _CreateNotesPageState extends State<CreateNotesPage> {
  final _titleController = TextEditingController();

  final Map<int, String> months = {
    0: 'January',
    2: 'February',
    3: 'March',
    4: 'April',
    5: 'May',
    6: 'June',
    7: 'July',
    8: 'August',
    9: 'Septemeber',
    10: 'October',
    11: 'November',
    12: 'December',
  };

  DateTime getDateTime() {
    return DateTime.now();
  }

  @override
  void dispose() {
    _titleController.dispose();

    for (final block in sectionList) {
      if (block is TextBlock) {
        block.textEditingController.dispose();
      }
    }
    super.dispose();
  }



  List<NoteBlocks> sectionList = [
    TextBlock(textEditingController: TextEditingController(), blokCount: 1),
  ];

  onSelectImage() async {
    try {
      final selectImage = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (selectImage == null) {
        return;
      }

      log(selectImage.path);
      log(sectionList.length.toString());
      int size = sectionList.length;
      setState(() {
        sectionList.add(
          Imageblock(imagePath: selectImage.path, blokCount: size++),
        );
        sectionList.add(
          TextBlock(
            textEditingController: TextEditingController(),
            blokCount: size++,
          ),
        );
      });
    } catch (eerr) {
      log(eerr.toString());
    }
  }

  void onBackAction(NotesPro notesProvider) async {
    bool isContentThere = true;
    for (var item in sectionList) {
      if (item is TextBlock) {
        item.textEditingController.text.trim().isEmpty
            ? isContentThere = false
            : isContentThere;
      }
      if (item is Imageblock) {
        isContentThere = true;
      }
      if (_titleController.text.trim().isEmpty && !isContentThere) {
        Navigator.of(context).pop();
        return;
      }
    }

    final String noteHIghLIght = 'abc';
    List<SectionModel> sectionlist = [];

    for (var section in sectionList) {
      if (section is TextBlock) {
        final SectionModel sectionModel = SectionModel(
          sectionNo: section.blokCount,
          sectionType: 'T',
          sectionContnet: section.textEditingController.text.trim(),
        );
        sectionlist.add(sectionModel);
      }
      if (section is Imageblock) {
        final SectionModel sectionModel = SectionModel(
          sectionNo: section.blokCount,
          sectionType: 'I',
          sectionContnet: section.imagePath,
        );
        sectionlist.add(sectionModel);
      }
    }

    notesProvider.addNote(
      notesModel: NotesModel(
        createdAt: DateTime.now(),
        modifiedAt: DateTime.now(),
        notesTitle: _titleController.text,
        notesContentHighLight: noteHIghLIght,
        sectionList: sectionlist,
      ),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesPro>(context);
    return PopScope(
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
              onPressed: () {},
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
              Expanded(
                child: ListView.builder(
                  itemCount: sectionList.length,
                  itemBuilder: (context, index) {
                    final section = sectionList[index];
                    if (section is TextBlock) {
                      return TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                  minLines: null,
                  style: textStyleOS(fontSize: 20, fontColor: Colors.black)
                      .copyWith(
                        wordSpacing: 5,
                        fontWeight: FontWeight.w400,
                        overflow: TextOverflow.ellipsis,
                      ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                          hintText: sectionList.length == 1
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
                      return SizedBox(
                        height: 170,
                        width: double.infinity,
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(18),
                          child: Image.file(
                            File(section.imagePath),
                            fit: BoxFit.cover,
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
                    onPressed: () {
                      onSelectImage();
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
                    onPressed: () {
                      log(sectionList.length.toString());
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




abstract class NoteBlocks {}

final class TextBlock extends NoteBlocks {
  final int blokCount;
  final TextEditingController textEditingController;
  TextBlock({required this.textEditingController, required this.blokCount});
}

final class Imageblock extends NoteBlocks {
  final int blokCount;
  final String imagePath;
  Imageblock({required this.imagePath, required this.blokCount});
}
