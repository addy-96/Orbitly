
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noted_d/core/textstyle.dart';
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
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final Map<int, String> months = {
    1: 'January',
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
    _contentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(
      text: widget.notesModel.notesTitle,
    );
    _contentController = TextEditingController(
      text: widget.notesModel.notesContentHighLight,
    );
  }

  void onBackAction(NotesPro notesProvider) async {
    

    /* if (_titleController.text.trim() == widget.notesModel.notesTitle &&
        _contentController.text == widget.notesModel.notesContent) {
    } else if (_titleController.text.trim().isEmpty &&
        _contentController.text.trim().isEmpty) {
      notesProvider.deleteNote(notesId: widget.notesModel.notesId);
    } else {
      final newNotesModel = NotesModel(
        createdAt: widget.notesModel.createdAt,
        modifiedAt: DateTime.now(),
        notesId: widget.notesModel.notesId,
        notesTitle: _titleController.text.trim(),
        notesContent: _contentController.text,
      );
      notesProvider.editNote(notesModel: newNotesModel);
    }*/
    Navigator.of(context).pop();
    return; 
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
                onPressed: () {},
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
                Expanded(
                  child: TextField(
                    expands: true,
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
                      hintText: 'Start Your note...',
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
                    controller: _contentController,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    IconButton(
                      onPressed: () async {
                        final ImagePicker imagePicker = ImagePicker();
                        final pickedFile = await imagePicker.pickImage(
                          source: ImageSource.gallery,
                        );
                        if (pickedFile == null) {
                          return;
                        }
                        final selectedImagePath = pickedFile.path;
                        _contentController.text =
                            '${_contentController.text}\n</picture>$selectedImagePath<picture/>';
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
