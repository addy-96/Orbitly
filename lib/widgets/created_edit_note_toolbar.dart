import 'package:Orbitly/providers/notes_pro.dart';
import 'package:Orbitly/widgets/notes_background_image_option.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

class CreatedEditNoteToolbar extends StatelessWidget {
  const CreatedEditNoteToolbar({super.key});

  @override
  Widget build(final BuildContext context) {
    final NotesPro notesPro = Provider.of<NotesPro>(context);
    return notesPro.showBackgroundAvatarMenu
        ? const NotesBackgroundImageOption()
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () async {
                  await notesPro.addImageSection();
                },
                icon: Icon(
                  HugeIcons.strokeRoundedImageAdd01,
                  color: notesPro.noteThemeColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  context.push('/drawing');
                },
                icon: Icon(
                  HugeIcons.strokeRoundedCurvyUpDownDirection,
                  color: notesPro.noteThemeColor,
                ),
              ),
              IconButton(
                onPressed: () {
                  notesPro.addTaskSection(context);
                },
                icon: Icon(
                  HugeIcons.strokeRoundedCheckmarkSquare01,
                  color: notesPro.noteThemeColor,
                ),
              ),
            ],
          );
  }
}
