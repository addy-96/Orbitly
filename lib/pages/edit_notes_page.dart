import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/widgets/creat_edit_note_title_bar.dart';
import 'package:noted_d/widgets/create_edit_note_appbar.dart';
import 'package:noted_d/widgets/create_edit_note_body.dart';
import 'package:noted_d/widgets/create_edit_note_time_sec.dart';
import 'package:noted_d/widgets/created_edit_note_toolbar.dart';
import 'package:provider/provider.dart';

class EditNotes extends StatefulWidget {
  const EditNotes({super.key, required this.noteId});
  final String noteId;

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> {
  late NotesPro notesPro;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    notesPro = Provider.of<NotesPro>(context, listen: false);
    if (_isFirstTime) {
      _isFirstTime = false;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notesPro.reset();
      });
    }
    if (!_isInitialized) {
      _isInitialized = true;
      notesPro.editNoteInitialization(noteId: widget.noteId);
    }
  }

  bool _isInitialized = false;
  bool _isFirstTime = true;

  @override
  Widget build(final BuildContext context) {
    final notesProvider = Provider.of<NotesPro>(context);
    return Hero(
      tag: widget.noteId,
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (final didPop, final result) async {
          if (!didPop) {
            await notesProvider.saveNote(
              context: context,
              isForEditPage: true,
              noteId: widget.noteId,
            );
          }
          return;
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: createEditNoteAppBar(
            isCreate: false,
            notesPro: notesPro,
            context: context,
            noteId: widget.noteId,
          ),
          body: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Gap(10),
                CreatEditNoteTitleBar(),
                Gap(10),
                CreateEditNoteTimeSec(),
                Gap(10),
                CreateEditNoteBody(),
                CreatedEditNoteToolbar(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
