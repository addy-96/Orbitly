import 'dart:developer';
import 'package:noted_d/models/notes_model.dart';
import 'package:path/path.dart' as p;

import 'package:sqflite/sqflite.dart';

abstract interface class NotesLocalServiceInterface {
  Future saveNewNote({required String noteTitle, required String noteContent});

  Future<List<NotesModel>> getAllNotes();

  Future editNote({required NotesModel notesModel});

  Future deleteNote({required int notesId});
}

class NotesLocalServiceInterfaceImpl implements NotesLocalServiceInterface {
  NotesLocalServiceInterfaceImpl();

  Future<Database> createDatabase() async {
    try {
      final dbPath = await getDatabasesPath();
      final path = p.join(dbPath, 'notes.db');
      final database = await openDatabase(
        path,
        version: 1,
        onCreate: (db, version) async {
          await db.execute('''
  CREATE TABLE IF NOT EXISTS notes (
    notesId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    notesTitle TEXT,
    createdAt TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    modifiedAt TEXT NOT NULL,
    notesContent TEXT
  );
''');
        },
      );
      return database;
    } catch (err) {
      log(err.toString());
      throw Exception(err.toString());
    }
  }

  @override
  Future saveNewNote({
    required String noteTitle,
    required String noteContent,
  }) async {
    try {
      final db = await createDatabase();
      await db.insert('notes', {
        'notesTitle': noteTitle,
        'createdAt': DateTime.now().toIso8601String(),
        'modifiedAt': DateTime.now().toIso8601String(),
        'notesContent': noteContent,
      });
    } catch (err) {
      log(err.toString());
      throw Exception(err);
    }
  }

  @override
  Future<List<NotesModel>> getAllNotes() async {
    List<NotesModel> notesList = [];
    final db = await createDatabase();
    final getNotesList = await db.query('notes');
    for (var noteItem in getNotesList) {
      final note = NotesModel(
        createdAt: DateTime.parse(noteItem['createdAt'].toString()),
        modifiedAt: DateTime.parse(noteItem['modifiedAt'].toString()),
        notesId: noteItem['notesId'] as int,
        notesTitle: noteItem['notesTitle'] as String,
        notesContent: noteItem['notesContent'] as String,
      );
      notesList.add(note);
    }
    return notesList;
  }

  @override
  Future editNote({required NotesModel notesModel}) async {
    try {
      final db = await createDatabase();
      await db.update(
        'notes',
        {
          'notesTitle': notesModel.notesTitle,
          'createdAt': notesModel.createdAt.toIso8601String(),
          'modifiedAt': DateTime.now().toIso8601String(),
          'notesContent': notesModel.notesContent,
        },
        where: 'notesId = ?',
        whereArgs: [notesModel.notesId],
      );
    } catch (err) {
      log(err.toString());
    }
  }

  @override
  Future deleteNote({required int notesId}) async {
    try {
      final db = await createDatabase();
      await db.delete('notes', where: 'notesId = ?', whereArgs: [notesId]);
    } catch (err) {
      log(err.toString());
    }
  }
}































































/*
      final dbPath = await getDatabasesPath();
      final path = p.join(dbPath, 'notes.db');
      await deleteDatabase(path);
*/ 