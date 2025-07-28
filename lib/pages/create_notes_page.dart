import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/widgets/creat_edit_note_title_bar.dart';
import 'package:noted_d/widgets/create_edit_note_appbar.dart';
import 'package:noted_d/widgets/create_edit_note_body.dart';
import 'package:noted_d/widgets/create_edit_note_time_sec.dart';
import 'package:noted_d/widgets/created_edit_note_toolbar.dart';
import 'package:provider/provider.dart';

class CreateNotesPage extends StatefulWidget {
  const CreateNotesPage({super.key});

  @override
  State<CreateNotesPage> createState() => _CreateNotesPageState();
}

class _CreateNotesPageState extends State<CreateNotesPage> {
  late NotesPro notesPro;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isFirstTime) {
      _isFirstTime = false;
      notesPro = Provider.of<NotesPro>(context, listen: false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notesPro.reset();
      });
    }
  }

  bool _isFirstTime = true;

  @override
  Widget build(final BuildContext context) {
    final notesSectionProvider = Provider.of<NotesPro>(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (final didPop, final result) async {
        if (!didPop) {
          await notesSectionProvider.saveNote(
            context: context,
            isForEditPage: false,
            noteId: null,
          );
        }
        return;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: createEditNoteAppBar(
          isCreate: true,
          notesPro: notesPro,
          context: context,
          noteId: null,
        ),
        body: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
    );
  }
}
