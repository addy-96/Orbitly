import 'dart:developer';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/models/notes_model.dart';
import 'package:path/path.dart' as p;

import 'package:sqflite/sqflite.dart';

abstract interface class NotesLocalServiceInterface {
  Future saveNewNote({required NotesModel notesModel});

  Future<List<HomeNotesModel>> getAllNotes();

  Future<NotesModel> editNote({required HomeNotesModel homeNotesModel});

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
  CREATE TABLE IF NOT EXISTS $notesTable (
    $notesIdNTC TEXT PRIMARY KEY NOT NULL,
    $notesTitleNTC TEXT,
    $createdAtNTC TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
    $modifiedAtNTC TEXT NOT NULL,
    $notesContentHighLightNTC TEXT
  );
''');

          await db.execute('''
  CREATE TABLE IF NOT EXISTS $sectionTable (
    $sectioonIdSTC TEXT PRIMARY KEY NOT NULL,
    $notesIdSTC TEXT NOT NULL,
    $sectionNoSTC INT NOT NULL,
    $typeSTC TEXT NOT NULL,
    $contentSTC TEXT NOT NULL
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
  Future saveNewNote({required NotesModel notesModel}) async {
    try {
      final db = await createDatabase();
      final noteId = notesModel.notesId;
      await db.insert(notesTable, {
        notesIdNTC: notesModel.notesId,
        notesTitleNTC: notesModel.notesTitle,
        modifiedAtNTC: notesModel.modifiedAt.toIso8601String(),
        notesContentHighLightNTC: notesModel.notesContentHighLight,
      });



      for (var sec in notesModel.sectionList) {
        await db.insert(sectionTable, {
          sectioonIdSTC: sec.sectionId,
          notesIdSTC: noteId,
          sectionNoSTC: sec.sectionNo,
          typeSTC: sec.sectionType,
          contentSTC: sec.sectionContnet,
        });
      }
    } catch (err) {
      log(err.toString());
      throw Exception(err);
    }
  }

  @override
  Future<List<HomeNotesModel>> getAllNotes() async {
    try {
    final db = await createDatabase();
      final getNotesResult = await db.query(notesTable);

      List<HomeNotesModel> notesList = [];

      for (var item in getNotesResult) {
        final HomeNotesModel homeNotesModel = HomeNotesModel(
          notesId: item[notesIdNTC] as String,
          notesTitle: item[notesTitleNTC] as String,
          createdAt: DateTime.parse(item[createdAtNTC] as String),
          modifiedAt: DateTime.parse(item[modifiedAtNTC] as String),
          notesContentHighlight: item[notesContentHighLightNTC] as String,
      );

        notesList.add(homeNotesModel);
    }
    return notesList;
    } catch (err) {
      log(err.toString());
      throw Exception(err);
    }

  }

  @override
  Future<NotesModel> editNote({required HomeNotesModel homeNotesModel}) async {
    try {
      final db = await createDatabase();
      

final resilt1 = await db.query(sectionTable);

      log(resilt1.toString());

      final getSectionResult = await db.query(
        sectionTable,
        where: '$notesIdSTC = ?',
        whereArgs: [homeNotesModel.notesId],
      );

      log(getSectionResult.toString());

      List<SectionModel> sectionModelList = [];

      for (var entry in getSectionResult) {
        final SectionModel sectionModel = SectionModel(
          sectionNo: entry[sectionNoSTC] as int,
          sectionType: entry[typeSTC] as String,
          sectionContnet: entry[contentSTC] as String,
        );

        sectionModelList.add(sectionModel);
      }

      NotesModel notesModel = NotesModel(
        createdAt: homeNotesModel.createdAt,
        modifiedAt: homeNotesModel.modifiedAt,
        notesTitle: homeNotesModel.notesTitle,
        notesContentHighLight: homeNotesModel.notesContentHighlight,
        sectionList: sectionModelList,
      );

      return notesModel;

    } catch (err) {
      log(err.toString());
      throw Exception(err);
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


