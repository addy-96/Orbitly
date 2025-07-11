import 'dart:developer';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/models/notes_model.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

abstract interface class NotesLocalServiceInterface {
  Future saveNewNote({required NotesModel notesModel});

  Future<List<HomeNotesModel>> getAllNotes();

  Future<NotesModel> enterEditNote({required HomeNotesModel homeNotesModel});

  Future deleteNote({required String notesId});

  Future updateNote({required NotesModel notesModel});

  Future<List<HomeNotesModel>> getSearchedNotes({required String searchQuery});
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

      log('save new note called');
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

      log('get all notes called');
    return notesList;
    } catch (err) {
      log(err.toString());
      throw Exception(err);
    }

  }

  @override
  Future<NotesModel> enterEditNote({
    required HomeNotesModel homeNotesModel,
  }) async {
    try {
      final db = await createDatabase();

      final getSectionResult = await db.query(
        sectionTable,
        where: '$notesIdSTC = ?',
        whereArgs: [homeNotesModel.notesId],
      );

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
        notesId: homeNotesModel.notesId,
        createdAt: homeNotesModel.createdAt,
        modifiedAt: homeNotesModel.modifiedAt,
        notesTitle: homeNotesModel.notesTitle,
        notesContentHighLight: homeNotesModel.notesContentHighlight,
        sectionList: sectionModelList,
      );

      log('enter edit note called');
      return notesModel;

    } catch (err) {
      log(err.toString());
      throw Exception(err);
    }
  }

  @override
  Future deleteNote({required String notesId}) async {
    try {
      final db = await createDatabase();
      await db.delete(
        notesTable,
        where: '$notesIdNTC = ?',
        whereArgs: [notesId],
      );
      await db.delete(
        sectionTable,
        where: '$notesIdSTC = ?',
        whereArgs: [notesId],
      );

      log('delete note called');
    } catch (err) {
      log(err.toString());
      throw Exception();
    }
  }

  @override
  Future updateNote({required NotesModel notesModel}) async {
    try {

      log('update for noteId ${notesModel.notesId} requested');

      final db = await createDatabase();

      final deleteAllSections = await db.delete(
        sectionTable,
        where: '$notesIdSTC = ?',
        whereArgs: [notesModel.notesId],
      );

      final updateNotesTable = await db.update(
        notesTable,
        {
          modifiedAtNTC: notesModel.modifiedAt.toIso8601String(),
          notesTitleNTC: notesModel.notesTitle,
          notesContentHighLightNTC: notesModel.notesContentHighLight,
        },
        where: '$notesIdNTC = ?',
        whereArgs: [notesModel.notesId],
      );

      //inserting new sections
      for (var sec in notesModel.sectionList) {
        await db.insert(sectionTable, {
          sectioonIdSTC: sec.sectionId,
          notesIdSTC: notesModel.notesId,
          sectionNoSTC: sec.sectionNo,
          typeSTC: sec.sectionType,
          contentSTC: sec.sectionContnet,
        });
      }

      log('update note called');
    } catch (err) {
      log(err.toString());
      throw Exception();
    }
  }
  
  @override
  Future<List<HomeNotesModel>> getSearchedNotes({
    required String searchQuery,
  }) async {
    try {
      final List<HomeNotesModel> searchedNotes = [];
      final db = await createDatabase();
      final sections = await db.query(
        sectionTable,
        where: '$contentSTC LIKE ?',
        whereArgs: ['%$searchQuery%'],
      );

      String lastAddedNoteid = '';
      for (var section in sections) {
        if (lastAddedNoteid == section[notesIdSTC]) {
          continue;
        }
        final notes = await db.query(
          notesTable,
          where: '$notesIdNTC = ?',
          whereArgs: [section[notesIdSTC]],
        );

        final HomeNotesModel homeNotesModel = HomeNotesModel(
          notesId: section[notesIdSTC] as String,
          createdAt: DateTime.parse(notes.first[createdAtNTC] as String),
          modifiedAt: DateTime.parse(notes.first[modifiedAtNTC] as String),
          notesContentHighlight:
              notes.first[notesContentHighLightNTC] as String,
          notesTitle: notes.first[notesContentHighLightNTC] as String,
        );

        searchedNotes.add(homeNotesModel);
        lastAddedNoteid = section[notesIdSTC] as String;
      }

      return searchedNotes;
    } catch (err) {
      log(err.toString());
      throw Exception(err);
    }
  }
}


