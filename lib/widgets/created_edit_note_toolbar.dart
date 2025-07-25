import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:provider/provider.dart';

class CreatedEditNoteToolbar extends StatelessWidget {
  const CreatedEditNoteToolbar({super.key});

  @override
  Widget build(final BuildContext context) {
    final NotesPro notesPro = Provider.of<NotesPro>(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () async {
            await notesPro.addImageSection();
          },
          icon: const Icon(HugeIcons.strokeRoundedImageAdd01),
        ),
        IconButton(
          onPressed: () {
            context.push('/drawing');
          },
          icon: const Icon(HugeIcons.strokeRoundedCurvyUpDownDirection),
        ),
        IconButton(
          onPressed: () {
            notesPro.addTaskSection(context);
          },
          icon: const Icon(HugeIcons.strokeRoundedCheckmarkSquare01),
        ),
      ],
    );
  }
}
