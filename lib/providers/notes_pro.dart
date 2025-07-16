
import 'package:flutter/material.dart';
import 'package:noted_d/models/notes_model.dart';
import 'package:noted_d/services%20/notes_local_service.dart';

class NotesPro with ChangeNotifier {
  final NotesLocalServiceInterface notesLocalServiceInterface;
  NotesPro({required this.notesLocalServiceInterface});

  List<HomeNotesModel> _notesList = [];

  List<HomeNotesModel> get notesList => _notesList;

  Future loadAllNotes() async {
    _notesList = await notesLocalServiceInterface.getAllNotes();
    notifyListeners();
  }

  Future addNote({required NotesModel notesModel}) async {
    await notesLocalServiceInterface.saveNewNote(notesModel: notesModel);

    await loadAllNotes();

  }

  Future<NotesModel> editNote({required HomeNotesModel homeNotesModel}) async {
    return notesLocalServiceInterface.enterEditNote(
      homeNotesModel: homeNotesModel,
    );
  }

  Future deleteNote({required String notesId}) async {
    await notesLocalServiceInterface.deleteNote(notesId: notesId);
    loadAllNotes();
    notifyListeners();
  }

  Future updateNote({required NotesModel notesModel}) async {
    await notesLocalServiceInterface.updateNote(notesModel: notesModel);
    loadAllNotes();
    notifyListeners();
  }
}


