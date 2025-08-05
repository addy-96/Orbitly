import 'package:flutter/material.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/providers/settings_pro.dart';
import 'package:provider/provider.dart';

class CreateEditNoteTitleBar extends StatelessWidget {
  const CreateEditNoteTitleBar({super.key});

  @override
  Widget build(final BuildContext context) {
    final notesPro = Provider.of<NotesPro>(context);
    final settingPro = Provider.of<SettingsPro>(context);
    return TextField(
      controller: notesPro.titleController,
      style: textStyleOS(
        fontSize: 25,
        fontColor: notesPro.noteThemeColor,
      ).copyWith(fontWeight: FontWeight.w700),
      cursorColor: notesPro.noteThemeColor,
      decoration: InputDecoration(
        hintText: 'Title',
        hintStyle: textStyleOS(
          fontSize: settingPro.getFontSize() * 1.8,
          fontColor: notesPro.currentNoteBackground == 'default'
              ? Colors.grey.shade400
              : Colors.white.withOpacity(0.6),
        ).copyWith(fontWeight: FontWeight.w700),
        border: InputBorder.none,
      ),
    );
  }
}
