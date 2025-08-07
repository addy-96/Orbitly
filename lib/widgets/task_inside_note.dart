import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/providers/settings_pro.dart';
import 'package:provider/provider.dart';

class TaskInsideNote extends StatefulWidget {
  const TaskInsideNote({super.key, required this.section, required this.index});
  final TaskBlock section;
  final int index;

  @override
  State<TaskInsideNote> createState() => _TaskInsideNoteState();
}

class _TaskInsideNoteState extends State<TaskInsideNote> {
  late FocusNode taskFocusNode;

  @override
  void initState() {
    super.initState();
    taskFocusNode = FocusNode();
    taskFocusNode.addListener(() {
      setState(() {}); // Rebuild on focus change
    });
  }

  @override
  Widget build(final BuildContext context) {
    final notesSectionProvider = Provider.of<NotesPro>(context);
    final settingsPro = Provider.of<SettingsPro>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Gap(MediaQuery.of(context).size.width / 30),
        IconButton(
          onPressed: () {
            if (widget.section.textEditingController.text.trim().isEmpty) {
              return;
            }
            notesSectionProvider.updateTaskStatus(
              index: widget.index,
              isComplete: widget.section.isComplete == 0 ? 1 : 0,
            );
          },
          icon: Icon(
            widget.section.isComplete == 0
                ? HugeIcons.strokeRoundedSquare
                : HugeIcons.strokeRoundedCheckmarkSquare01,
            size: 20,
            color: widget.section.isComplete == 0
                ? notesSectionProvider.noteThemeColor
                : themeOrange,
          ),
        ),
        const Gap(10),
        Expanded(
          child: TextField(
            maxLength: 30,
            autofocus: true,
            focusNode: taskFocusNode,
            cursorColor: notesSectionProvider.noteThemeColor,
            style: textStyleOS(
              fontSize: settingsPro.getFontSize(),
              fontColor: notesSectionProvider.noteThemeColor,
            ),
            controller: widget.section.textEditingController,
            decoration: InputDecoration(
              counterText: '',
              border: InputBorder.none,
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
              ),
            ),
          ),
        ),
        taskFocusNode.hasFocus
            ? IconButton(
                onPressed: () {
                  notesSectionProvider.removeImageOrTask(index: widget.index);
                },
                icon: Icon(
                  HugeIcons.strokeRoundedMultiplicationSign,
                  size: 15,
                  color: notesSectionProvider.noteThemeColor,
                ),
              )
            : const SizedBox.shrink(),
        Gap(MediaQuery.of(context).size.width / 30),
      ],
    );
  }
}
