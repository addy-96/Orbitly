import 'dart:developer';
import 'package:Orbitly/core/snackbar.dart';
import 'package:Orbitly/core/util_functions.dart';
import 'package:Orbitly/models/notes_model.dart';
import 'package:Orbitly/services/notes_local_service.dart'
    show NotesLocalServiceInterface;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

abstract class NoteBlocks {}

final class TextBlock extends NoteBlocks {
  final TextEditingController textEditingController;

  TextBlock({required this.textEditingController});
}

final class TaskBlock extends NoteBlocks {
  final int isComplete;

  final TextEditingController textEditingController;

  TaskBlock({required this.textEditingController, required this.isComplete});
}

final class Imageblock extends NoteBlocks {
  final String imagePath;

  Imageblock({required this.imagePath});
}

final class DrawingBlock extends NoteBlocks {
  final String drawingImagePath;

  final String drawingId;

  DrawingBlock({required this.drawingImagePath, required this.drawingId});
}

final class GestureBlock extends NoteBlocks {}

//

// provider for notes home and edit notes
class NotesPro with ChangeNotifier {
  final NotesLocalServiceInterface notesLocalServiceInterface;

  NotesPro({required this.notesLocalServiceInterface});

  // for homepage
  List<HomeNotesModel> _notesList = [];

  List<HomeNotesModel> get notesList => _notesList;

  // for note edit section
  final List<NoteBlocks> _sectionList = [GestureBlock()];

  List<NoteBlocks> get sectionList => _sectionList;

  final TextEditingController _titleController = TextEditingController();

  TextEditingController get titleController => _titleController;

  //for folders section
  List<String> _folderList = [];

  List<String> get folderList => _folderList;

  String _selectedFolder = 'All';

  String get selectedFolder => _selectedFolder;

  //for background avatar
  bool _showBackgroundAvatarMenu = false;

  bool get showBackgroundAvatarMenu => _showBackgroundAvatarMenu;

  String _currentNoteBackground = 'default';

  String get currentNoteBackground => _currentNoteBackground;

  DateTime? _createdAt;

  DateTime? get createdAt => _createdAt;

  DateTime? _editedAt;

  DateTime? get editedAt => _editedAt;

  Color _noteThemeColor = Colors.black;

  Color get noteThemeColor => _noteThemeColor;

  @override
  void dispose() {
    _titleController.dispose();
    for (var item in _sectionList) {
      if (item is TextBlock) {
        item.textEditingController.dispose();
      } else if (item is TaskBlock) {
        item.textEditingController.dispose();
      }
    }
    _sectionList.clear();
    super.dispose();
  }

  void reset() {
    _titleController.clear();
    for (var item in _sectionList) {
      if (item is TextBlock) {
        item.textEditingController.dispose();
      } else if (item is TaskBlock) {
        item.textEditingController.dispose();
      }
    }
    _sectionList
      ..clear()
      ..add(GestureBlock());
    notifyListeners();
  }

  // add text section to notes
  void addTextsection() {
    final listSize = _sectionList.length;
    if (listSize == 1) {
      _sectionList.insert(
        _sectionList.length - 1,
        TextBlock(textEditingController: TextEditingController()),
      );
      notifyListeners();
      return;
    }
    final secondLast = _sectionList[listSize - 2];
    if (secondLast is! TextBlock) {
      if (secondLast is TaskBlock) {
        if (secondLast.textEditingController.text.trim().isEmpty) {
          _sectionList[_sectionList.length - 2] = TextBlock(
            textEditingController: TextEditingController(),
          );
          notifyListeners();
          return;
        } else {
          _sectionList.insert(
            _sectionList.length - 1,
            TextBlock(textEditingController: TextEditingController()),
          );
          notifyListeners();
          return;
        }
      }
      _sectionList.insert(
        _sectionList.length - 1,
        TextBlock(textEditingController: TextEditingController()),
      );
      notifyListeners();
      return;
    }
  }

  //add image section to notes
  Future<void> addImageSection() async {
    final selectedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (selectedImage == null) {
      return;
    }

    if (sectionList.length == 1) {
      _sectionList.insert(
        _sectionList.length - 1,
        Imageblock(imagePath: selectedImage.path),
      );
      notifyListeners();
      return;
    }

    final secondLastSection = sectionList[_sectionList.length - 2];

    if (secondLastSection is TextBlock) {
      if (secondLastSection.textEditingController.text.trim().isEmpty) {
        sectionList[_sectionList.length - 2] = Imageblock(
          imagePath: selectedImage.path,
        );
        notifyListeners();
        return;
      }
    } else if (secondLastSection is TaskBlock) {
      if (secondLastSection.textEditingController.text.trim().isEmpty) {
        sectionList[_sectionList.length - 2] = Imageblock(
          imagePath: selectedImage.path,
        );
        notifyListeners();
        return;
      }
    }
    _sectionList.insert(
      _sectionList.length - 1,
      Imageblock(imagePath: selectedImage.path),
    );
    notifyListeners();
    return;
  }

  //add task section to notes
  void addTaskSection(final BuildContext context) {
    if (_sectionList.length == 1) {
      _sectionList.insert(
        0,
        TaskBlock(
          textEditingController: TextEditingController(),
          isComplete: 0,
        ),
      );
      notifyListeners();
      return;
    }

    final secondLastSection = sectionList[_sectionList.length - 2];

    if (secondLastSection is TextBlock) {
      if (secondLastSection.textEditingController.text.trim().isEmpty) {
        sectionList[_sectionList.length - 2] = TaskBlock(
          isComplete: 0,
          textEditingController: TextEditingController(),
        );
        notifyListeners();
        return;
      }
    } else if (secondLastSection is TaskBlock) {
      if (secondLastSection.textEditingController.text.trim().isEmpty) {
        cSnack(
          message: 'You missed the last task, fill the last task to add more.',
          backgroundColor: Colors.white,
          context: context,
        );
        return;
      }
    }
    _sectionList.insert(
      _sectionList.length - 1,
      TaskBlock(isComplete: 0, textEditingController: TextEditingController()),
    );
    notifyListeners();
    return;
  }

  void updateTaskStatus({
    required final int index,
    required final int isComplete,
  }) {
    sectionList[index] = TaskBlock(
      textEditingController:
          (sectionList[index] as TaskBlock).textEditingController,
      isComplete: isComplete,
    );
    notifyListeners();
  }

  //add drawing section to notes
  Future<void> addDrawingSection({
    required final DrawingBlock drawingBlock,
    required final BuildContext context,
  }) async {
    try {
      if (_sectionList.length == 1) {
        log(drawingBlock.drawingImagePath);
        _sectionList.insert(
          0,
          DrawingBlock(
            drawingImagePath: drawingBlock.drawingImagePath,
            drawingId: drawingBlock.drawingId,
          ),
        );
        context.pop();
        notifyListeners();
        return;
      }

      final secondLastSection = sectionList[_sectionList.length - 2];
      if (secondLastSection is TextBlock) {
        if (secondLastSection.textEditingController.text.trim().isEmpty) {
          sectionList[_sectionList.length - 2] = drawingBlock;
          Navigator.of(context).pop();
          notifyListeners();
          return;
        }
      } else if (secondLastSection is TaskBlock) {
        if (secondLastSection.textEditingController.text.trim().isEmpty) {
          sectionList[_sectionList.length - 2] = drawingBlock;
          Navigator.of(context).pop();
          notifyListeners();
          return;
        }
      }
      _sectionList.insert(_sectionList.length - 1, drawingBlock);

      Navigator.of(context).pop();
      notifyListeners();
      return;
    } catch (err) {
      log('error ${err.toString()}');
    }
  }

  // remove image or task section from notes
  void removeImageOrTask({required final int index}) {
    if (_sectionList.length != 2) {
      final beforeSection = _sectionList[index - 1];
      final afterSection = _sectionList[index + 1];

      if (beforeSection is TextBlock && afterSection is TextBlock) {
        _sectionList.removeAt(index);
        beforeSection.textEditingController.text +=
            afterSection.textEditingController.text;
        _sectionList.remove(afterSection);
        notifyListeners();
        return;
      }
    }
    _sectionList.removeAt(index);
    notifyListeners();
    return;
  }

  void removeDrawingSection({
    required final String drawingImagePath,
    required final int index,
  }) async {
    if (_sectionList.length != 2) {
      final beforeSection = _sectionList[index - 1];
      final afterSection = _sectionList[index + 1];

      if (beforeSection is TextBlock && afterSection is TextBlock) {
        _sectionList.removeAt(index);
        beforeSection.textEditingController.text +=
            afterSection.textEditingController.text;
        _sectionList.remove(afterSection);
        notifyListeners();
        return;
      }
    }
    _sectionList.removeAt(index);
    notifyListeners();

    notesLocalServiceInterface.deleteDrawingImage(imagePath: drawingImagePath);
    /*    final dir = await getApplicationDocumentsDirectory();
    if (dir.listSync().isNotEmpty) {
      for (var item in dir.listSync()) {
        log(item.path);
      }
    } */
    return;
  }

  //save note ----> called add note inside
  Future<void> saveNote({
    required final BuildContext context,
    required final bool isForEditPage,
    required final String? noteId,
  }) async {
    try {
      final bool isContentPresent = validateContent();
      if (!isContentPresent) {
        if (isForEditPage && noteId != null) {
          await deleteNote(notesId: noteId);
        }
        Future.delayed(const Duration(seconds: 1));
        context.pop();

        return;
      } else {
        final List<SectionModel> sectionModelList = [];
        final String notesContentHighlight = getNoteContentHiglight();
        for (var i = 0; i <= _sectionList.length - 1; i++) {
          final section = _sectionList[i];
          if (section is TextBlock) {
            final sectionModel = SectionModel(
              sectionNo: i,
              sectionType: 'text',
              sectionContnet: section.textEditingController.text,
            );

            sectionModelList.add(sectionModel);
          } else if (section is Imageblock) {
            final sectionModel = SectionModel(
              sectionNo: i,
              sectionType: 'image',
              sectionContnet: section.imagePath,
            );
            sectionModelList.add(sectionModel);
          } else if (section is TaskBlock) {
            final sectionModel = SectionModel(
              sectionNo: i,
              sectionType: 'task',
              sectionContnet:
                  '${section.textEditingController.text}~${section.isComplete}~',
            );
            sectionModelList.add(sectionModel);
          } else if (section is GestureBlock) {
            final sectionModel = SectionModel(
              sectionNo: i,
              sectionType: 'gesture',
              sectionContnet: '',
            );
            sectionModelList.add(sectionModel);
          } else if (section is DrawingBlock) {
            log('found a drawing block');
            final sectionModel = SectionModel(
              sectionNo: i,
              sectionType: 'drawing',
              sectionContnet: section
                  .drawingImagePath, // here to store drawing id for futher feature
            );
            sectionModelList.add(sectionModel);
          }
        }
        final NotesModel notesModel = NotesModel(
          notesId: noteId,
          createdAt: DateTime.now(),
          modifiedAt: DateTime.now(),
          notesTitle: _titleController.text,
          notesContentHighLight: notesContentHighlight,
          sectionList: sectionModelList,
          notesBackground: _currentNoteBackground,
        );
        !isForEditPage
            ? await addNote(notesModel: notesModel)
            : await updateNote(notesModel: notesModel);
      }
      _currentNoteBackground = 'default';
      Future.delayed(const Duration(seconds: 1));
      context.pop();
      return;
    } catch (err) {
      throw Exception(err);
    }
  }

  // validate if note has content
  bool validateContent() {
    if (_titleController.text.trim().isNotEmpty) {
      return true;
    }
    final result = _sectionList.any((final e) {
      if (e is Imageblock) {
        return true;
      }
      if (e is TextBlock) {
        if (e.textEditingController.text.trim().isNotEmpty) {
          return true;
        }
      }
      if (e is TaskBlock) {
        if (e.textEditingController.text.trim().isNotEmpty) {
          return true;
        }
      }
      if (e is DrawingBlock) {
        return true;
      }
      return false;
    });

    return result;
  }

  // get notehighlight that has to be entered in local database
  String getNoteContentHiglight() {
    String highlight = '';
    for (var item in _sectionList) {
      if (item is Imageblock) {
        highlight = 'Image Block';
      }
      if (item is TextBlock) {
        if (item.textEditingController.text.trim().length < 30) {
          highlight = item.textEditingController.text.substring(
            0,
            item.textEditingController.text.length,
          );
        } else {
          highlight = item.textEditingController.text.substring(0, 30);
        }
        break;
      }
      if (item is TaskBlock) {
        if (item.textEditingController.text.trim().length < 10) {
          highlight = item.textEditingController.text.substring(
            0,
            item.textEditingController.text.length,
          );
        } else {
          highlight = item.textEditingController.text.substring(0, 10);
        }
        break;
      }
    }
    return highlight;
  }

  // load all notes at homscreen
  Future loadAllNotes() async {
    _notesList = await notesLocalServiceInterface.getAllNotes(
      selectedFolder: _selectedFolder,
    );

    notifyListeners();
  }

  //add note <---- called from save note inside
  Future addNote({required final NotesModel notesModel}) async {
    await notesLocalServiceInterface.saveNewNote(
      notesModel: notesModel,
      selectedFolder: _selectedFolder,
    );
    await loadAllNotes();
  }

  Future<void> editNoteInitialization({required final String noteId}) async {
    final restorePreviusNote = await notesLocalServiceInterface.enterEditNote(
      noteId: noteId,
    );

    _createdAt = restorePreviusNote.createdAt;
    _editedAt = restorePreviusNote.modifiedAt;

    _titleController.text = restorePreviusNote.notesTitle ?? '';
    _sectionList.clear();

    _currentNoteBackground = restorePreviusNote.notesBackground;
    _noteThemeColor = _currentNoteBackground == 'default'
        ? Colors.black
        : Colors.white;

    log('current note background is $_currentNoteBackground');
    for (var i = 0; i < restorePreviusNote.sectionList.length; i++) {
      final secton = restorePreviusNote.sectionList[i];

      if (secton.sectionType == 'text') {
        _sectionList.add(
          TextBlock(
            textEditingController: TextEditingController(
              text: secton.sectionContnet,
            ),
          ),
        );
      } else if (secton.sectionType == 'image') {
        _sectionList.add(Imageblock(imagePath: secton.sectionContnet));
      } else if (secton.sectionType == 'drawing') {
        _sectionList.add(
          DrawingBlock(
            drawingId: secton.sectionId,
            drawingImagePath: secton.sectionContnet,
          ),
        );
      } else if (secton.sectionType == 'task') {
        final task = secton.sectionContnet.substring(
          0,
          secton.sectionContnet.length - 3,
        );
        final iscomplete = getTaskCompleteStatus(task: secton.sectionContnet);
        _sectionList.add(
          TaskBlock(
            textEditingController: TextEditingController(text: task),
            isComplete: iscomplete!,
          ),
        );
      } else if (secton.sectionType == 'gesture') {
        _sectionList.add(GestureBlock());
      }
    }

    notifyListeners();
    return;
  }

  Future deleteNote({required final String notesId}) async {
    await notesLocalServiceInterface.deleteNote(notesId: notesId);
    _currentNoteBackground = 'default';
    loadAllNotes();
    notifyListeners();
  }

  Future updateNote({required final NotesModel notesModel}) async {
    await notesLocalServiceInterface.updateNote(notesModel: notesModel);
    loadAllNotes();
    notifyListeners();
  }

  Future loadAllFolders() async {
    _folderList = await notesLocalServiceInterface.getAllFolders();
    notifyListeners();
  }

  Future addaFolder({required final String foldername}) async {
    notesLocalServiceInterface.createAFolder(folderName: foldername);
    loadAllFolders();
  }

  void selectFolder({required final String selectedFolderName}) {
    if (folderList.contains(selectedFolderName)) {
      _selectedFolder = selectedFolderName;
      loadAllNotes();
    } else if (selectedFolderName == 'All') {
      _selectedFolder = 'All';
      loadAllNotes();
    }
    log('selected folder is $selectedFolderName');
    notifyListeners();
  }

  Future<void> addNoteToFolder({
    required final String noteId,
    required final String foldername,
  }) async {
    await notesLocalServiceInterface.addNoteToFolder(
      foldername: foldername,
      noteId: noteId,
    );
  }

  Future<void> removeFromFolder({required final String noteId}) async {
    await notesLocalServiceInterface.removeFromFolder(
      foldername: selectedFolder,
      noteId: noteId,
    );
    _selectedFolder = 'All';
  }

  void toggleAvatarBackgroundMenu() async {
    _showBackgroundAvatarMenu = !_showBackgroundAvatarMenu;
    notifyListeners();
  }

  void setNoteBackground({required final String path}) async {
    _currentNoteBackground = path;
    _noteThemeColor = path == 'default' ? Colors.black : Colors.white;
    notifyListeners();
  }
}
