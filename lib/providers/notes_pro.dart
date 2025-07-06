import 'package:flutter/material.dart';
import 'package:noted_d/models/notes_model.dart';
import 'package:noted_d/services%20/notes_local_service.dart';

class NotesPro with ChangeNotifier {
  final NotesLocalServiceInterface notesLocalServiceInterface;
  NotesPro({required this.notesLocalServiceInterface});

  List<NotesModel> _notesList = [];

  List<NotesModel> get notesList => _notesList;

  Future loadAllNotes() async {
    _notesList = await notesLocalServiceInterface.getAllNotes();
    notifyListeners();
  }

  Future addNote({
    required String notesTitle,
    required String notesContent,
  }) async {
    await notesLocalServiceInterface.saveNewNote(
      noteTitle: notesTitle,
      noteContent: notesContent,
    );
    loadAllNotes();
  }

  Future editNote({required NotesModel notesModel}) async {
    await notesLocalServiceInterface.editNote(notesModel: notesModel);
    loadAllNotes();
  }

  Future deleteNote({required int notesId}) async {
    await notesLocalServiceInterface.deleteNote(notesId: notesId);
    loadAllNotes();
  }
}
