import 'package:flutter/material.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/providers/settings_pro.dart';
import 'package:provider/provider.dart';

class NoteBodyTextfield extends StatelessWidget {
  const NoteBodyTextfield({super.key, required this.section});

  final TextBlock section;

  @override
  Widget build(final BuildContext context) {
    final settingPro = Provider.of<SettingsPro>(context);
    final notesSectionProvider = Provider.of<NotesPro>(context);
    return TextField(
      controller: section.textEditingController,
      autofocus: true,
      keyboardType: TextInputType.multiline,
      maxLines: null,
      minLines: null,
      cursorColor: notesSectionProvider.noteThemeColor,
      style:
          textStyleOS(
            fontSize: settingPro.getFontSize() * 1.4,
            fontColor: notesSectionProvider.noteThemeColor,
          ).copyWith(
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
          fontSize: settingPro.getFontSize() * 1.5,
          fontColor: darkkgrey,
        ).copyWith(fontWeight: FontWeight.w300),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        isDense: false,
      ),
    );
  }
}
