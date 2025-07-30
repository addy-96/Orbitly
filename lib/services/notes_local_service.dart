import 'dart:developer';
import 'dart:io';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/exceptions.dart';
import 'package:noted_d/models/notes_model.dart';
import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

abstract interface class NotesLocalServiceInterface {
  Future saveNewNote({
    required final NotesModel notesModel,
    required final String selectedFolder,
  });

  Future<List<HomeNotesModel>> getAllNotes({
    required final String selectedFolder,
  });

  Future<NotesModel> enterEditNote({required final String noteId});

  Future deleteNote({required final String notesId});

  Future updateNote({required final NotesModel notesModel});

  Future<List<HomeNotesModel>> getSearchedNotes({
    required final String searchQuery,
  });

  Future deleteDrawingImage({required final String imagePath});

  Future<List<String>> getAllFolders();

  Future createAFolder({required final String folderName});

  Future<void> addNoteToFolder({
    required final String foldername,
    required final String noteId,
  });

  Future<void> removeFromFolder({
    required final String foldername,
    required final String noteId,
  });
}

class NotesLocalServiceInterfaceImpl implements NotesLocalServiceInterface {
  Future<String> getDBpath() async {
    final dbPath = await getDatabasesPath();
    final path = p.join(dbPath, 'notes.db');
    return path;
  }

  Future<Database> createDatabase() async {
    try {
      final path = await getDBpath();
      final database = await openDatabase(
        path,
        version: 1,
        onCreate: (final db, final version) async {
          await db.execute('''
          CREATE TABLE IF NOT EXISTS $notesTable (
          $notesIdNTC TEXT PRIMARY KEY NOT NULL,
          $notesTitleNTC TEXT,
          $createdAtNTC TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
          $modifiedAtNTC TEXT NOT NULL,
          $notesContentHighLightNTC TEXT,
          $noteBackgroundNTC TEXT NOT NULL
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

          await db.execute('''
        CREATE TABLE IF NOT EXISTS $taskTable (
        $taskIdTTC TEXT PRIMARY KEY NOT NULL,
        $taskContentTTC TEXT NOT NULL,
        $completeStatusTTC INT NOT NULL
      );
    ''');

          await db.execute('''
        CREATE TABLE IF NOT EXISTS $folderTable(
        foldername TEXT NOT NULL
          );
       ''');

          log('notes database created!');
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
    required final NotesModel notesModel,
    required final String selectedFolder,
  }) async {
    try {
      final db = await createDatabase();
      final noteId = notesModel.notesId;
      await db.insert(notesTable, {
        notesIdNTC: notesModel.notesId,
        notesTitleNTC: notesModel.notesTitle,
        modifiedAtNTC: notesModel.modifiedAt.toIso8601String(),
        notesContentHighLightNTC: notesModel.notesContentHighLight,
        noteBackgroundNTC: notesModel.notesBackground
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

      if (selectedFolder == 'All') {
        return;
      } else {
        await db.insert(selectedFolder, {noteId: notesModel.notesId});
      }
      log('save new note called');
    } catch (err) {
      log(err.toString());
      throw Exception(err);
    }
  }

  @override
  Future<List<HomeNotesModel>> getAllNotes({
    required final String selectedFolder,
  }) async {
    try { 


      
      final db = await createDatabase();
      if (selectedFolder == 'All') {
        final getNotesResult = await db.query(notesTable);

        final List<HomeNotesModel> notesList = [];

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

        log('get all notes completed');
        return notesList;
    
    
      } else {
        log('reached here');
        final notesInfolder = await db.query(selectedFolder);
        final List<HomeNotesModel> notesList = [];
        
        for (var item in notesInfolder) {
          final getNotesResult = await db.query(
            notesTable,
            where: '$notesIdNTC = ? ',
            whereArgs: [item['noteId']],
          );

          final note = getNotesResult.first;
          final HomeNotesModel homeNotesModel = HomeNotesModel(
            notesId: note[notesIdNTC] as String,
            notesTitle: note[notesTitleNTC] as String,
            createdAt: DateTime.parse(note[createdAtNTC] as String),
            modifiedAt: DateTime.parse(note[modifiedAtNTC] as String),
            notesContentHighlight: note[notesContentHighLightNTC] as String,
          );

          notesList.add(homeNotesModel);
        }
        log('get $selectedFolder notes completed');
        return notesList; 

      } 
    } catch (err) {
      log(err.toString());
      throw Exception(err);
    }
  }

  @override
  Future<NotesModel> enterEditNote({required final String noteId}) async {
    try {
      final db = await createDatabase();

      final getSectionResult = await db.query(
        sectionTable,
        where: '$notesIdSTC = ?',
        whereArgs: [noteId],
      );

      final getNotesDetail = await db.query(
        notesTable,
        where: '$notesIdNTC=?',
        whereArgs: [noteId],
      );

      final List<SectionModel> sectionModelList = [];

      for (var entry in getSectionResult) {
        final SectionModel sectionModel = SectionModel(
          sectionNo: entry[sectionNoSTC] as int,
          sectionType: entry[typeSTC] as String,
          sectionContnet: entry[contentSTC] as String,
        );
        sectionModelList.add(sectionModel);
      }

      final NotesModel notesModel = NotesModel(
        notesId: noteId,
        createdAt: DateTime.parse(getNotesDetail.first[createdAtNTC] as String),
        modifiedAt: DateTime.parse(
          getNotesDetail.first[modifiedAtNTC] as String,
        ),
        notesTitle: getNotesDetail.first[notesTitleNTC] as String,
        notesContentHighLight:
            getNotesDetail.first[notesContentHighLightNTC] as String,
        sectionList: sectionModelList,
        notesBackground: getNotesDetail.first[noteBackgroundNTC] as String,
      );
      log('enter edit note completed');
      return notesModel;
    } catch (err) {
      log(err.toString());
      throw Exception(err);
    }
  }

  @override
  Future deleteNote({required final String notesId}) async {
    try {
      final db = await createDatabase();
      await db.delete(
        notesTable,
        where: '$notesIdNTC = ?',
        whereArgs: [notesId],
      );

      // here we have to also delete the foole from the folder

      await db.delete(
        sectionTable,
        where: '$notesIdSTC = ?',
        whereArgs: [notesId],
      );

      log('delete note completed');
    } catch (err) {
      log(err.toString());
      throw Exception();
    }
  }

  @override
  Future updateNote({required final NotesModel notesModel}) async {
    try {
      log('update for noteId ${notesModel.notesId} requested');
      log(notesModel.sectionList.first.sectionContnet);
      notesModel.notesContentHighLight != null
          ? log(notesModel.notesContentHighLight!)
          : log('highlight null');
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

      log('update note completed');
    } catch (err) {
      log(err.toString());
      throw Exception();
    }
  }

  @override
  Future<List<HomeNotesModel>> getSearchedNotes({
    required final String searchQuery,
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

  @override
  Future deleteDrawingImage({required final String imagePath}) async {
    final file = File(imagePath);

    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<List<String>> getAllFolders() async {
    final List<String> folders = [];
    final db = await createDatabase();
    final getFolders = await db.query(folderTable);
    for (var item in getFolders) {
      folders.add((item['foldername'] as String));
    }
    return folders;
  }

  @override
  Future createAFolder({required final String folderName}) async {
    final db = await createDatabase();
    await db.insert(folderTable, {'foldername': folderName});
    await db.execute('''
    CREATE TABLE IF NOT EXISTS "$folderName"(
    noteId TEXT NOT NULL
    );
   ''');
    final getFolders = await db.query(folderTable);
    log(getFolders.toString());
  }

  @override
  Future<void> addNoteToFolder({
    required final String foldername,
    required final String noteId,
  }) async {
    try {
      final db = await createDatabase();
      final notes = await db.query(foldername);
      for (var item in notes) {
        if (item['noteId'] == noteId) {
          throw NoteAlreadyExistinFolderException(
            message: 'Note already exist in $foldername!',
          );
        }
      }
      await db.insert(foldername, {'noteId': noteId});
    } catch (err) {
      log(err.toString());
    }
  }
  
  @override
  Future<void> removeFromFolder({
    required final String foldername,
    required final String noteId,
  }) async {
    try {
      final db = await createDatabase();
      await db.delete(foldername, where: 'noteId = ?', whereArgs: [noteId]);
    } catch (err) {
      log(err.toString());
      throw Exception(err.toString());
    }
  }


}
