import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:provider/provider.dart';

class CreateNotesPage extends StatefulWidget {
  const CreateNotesPage({super.key});

  @override
  State<CreateNotesPage> createState() => _CreateNotesPageState();
}

class _CreateNotesPageState extends State<CreateNotesPage> {
  final _contentController = TextEditingController();
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
    _contentController.dispose();
    super.dispose();
  }

  void onBackAction(NotesPro notesProvider) async {
    if (_titleController.text.trim().isEmpty &&
        _contentController.text.trim().isEmpty) {
      log('empty note: note not saved');
    } else {
      notesProvider.addNote(
        notesTitle: _titleController.text.trim(),
        notesContent: _contentController.text,
      );
    }
    Navigator.of(context).pop();
    return;
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
                    onPressed: () {
                      if (_contentController.text.trim().contains('\n')) {
                        log('true');
                      } else {
                        log('false');
                      }
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
    );
  }
}
