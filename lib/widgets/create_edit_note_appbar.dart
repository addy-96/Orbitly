import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:path_provider/path_provider.dart';

PreferredSizeWidget createEditNoteAppBar({
  required final bool isCreate,
  required final NotesPro notesPro,
  required final BuildContext context,
  required final String? noteId,
}) {
  //final DrawingPro drawingPro = Provider.of<DrawingPro>(context);
  return AppBar(
    surfaceTintColor: Colors.transparent,
    forceMaterialTransparency: true,
    leading: IconButton(
      onPressed: () async {
        if (isCreate) {
          await notesPro.saveNote(
            context: context,
            isForEditPage: false,
            noteId: noteId,
     
          );
        } else {
          await notesPro.saveNote(
            context: context,
            isForEditPage: true,
            noteId: noteId,
       
          );
        }
      },
      icon: const Icon(HugeIcons.strokeRoundedArrowLeft02),
    ),
    actions: [
      IconButton(
        onPressed: () {
          for (var item in notesPro.sectionList) {
            if (item is DrawingBlock) {}
          }
        },
        icon: const Icon(HugeIcons.strokeRoundedShare01),
      ),
      IconButton(
        onPressed: () async {
          final dir = await getApplicationDocumentsDirectory();
          if (dir.existsSync()) {
            for (var item in dir.listSync()) {}
          }
        },
        icon: const Icon(HugeIcons.strokeRoundedTShirt),
      ),
      IconButton(
        onPressed: () {},
        icon: const Icon(HugeIcons.strokeRoundedMenu08),
      ),
    ],
  );
}
