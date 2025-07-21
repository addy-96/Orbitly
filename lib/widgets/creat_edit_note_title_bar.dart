import 'package:flutter/material.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:provider/provider.dart';

class CreatEditNoteTitleBar extends StatelessWidget {
  const CreatEditNoteTitleBar({super.key});

  @override
  Widget build(final BuildContext context) {
    final notesPro = Provider.of<NotesPro>(context);
    return TextField(
      controller: notesPro.titleController,
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
    );
  }
}
