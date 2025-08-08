import 'package:Orbitly/providers/notes_pro.dart';
import 'package:Orbitly/widgets/note_body_drawing_image.dart';
import 'package:Orbitly/widgets/note_body_image.dart';
import 'package:Orbitly/widgets/note_body_textfield.dart';
import 'package:Orbitly/widgets/task_inside_note.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateEditNoteBody extends StatelessWidget {
  const CreateEditNoteBody({super.key});

  @override
  Widget build(final BuildContext context) {
    return Consumer<NotesPro>(
      builder: (final context, final notesSectionProvider, final child) {
        return Expanded(
          child: ListView.builder(
            itemCount: notesSectionProvider.sectionList.length,
            itemBuilder: (final context, final index) {
              final section = notesSectionProvider.sectionList[index];
              if (section is TextBlock) {
                return NoteBodyTextfield(section: section);
              } else if (section is Imageblock) {
                return NoteBodyImage(section: section, index: index);
              } else if (section is TaskBlock) {
                return TaskInsideNote(section: section, index: index);
              } else if (section is DrawingBlock) {
                return NoteBodyDrawingImage(section: section, index: index);
              } else if (section is GestureBlock) {
                return GestureDetector(
                  onTap: () {
                    notesSectionProvider.addTextsection();
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    color: Colors.transparent,
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }
}
