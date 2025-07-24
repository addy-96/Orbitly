import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noted_d/core/snackbr.dart';
import 'package:noted_d/core/util_functions.dart';
import 'package:noted_d/models/notes_model.dart';
import 'package:noted_d/models/sketch_model.dart';
import 'package:noted_d/services/notes_local_service.dart';


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
  final List<SketchModel> sketchList;
  final String drawingId;

  DrawingBlock({
    required this.drawingImagePath,
    required this.sketchList,
    required this.drawingId,
  });
}

final class GestureBlock extends NoteBlocks {}




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
    log('reset called');
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










  //add drawing section to notes
  Future<void> addDrawingSection({
    required final DrawingBlock drawingBlock,
    required final BuildContext context,
  }) async {
    try {
      log('add drawing section called..........');
      if (_sectionList.length == 1) {
        log('length==1..........');
        log(drawingBlock.drawingImagePath);
        _sectionList.insert(
          0,
          DrawingBlock(
            drawingImagePath: drawingBlock.drawingImagePath,
            sketchList: drawingBlock.sketchList,
            drawingId: drawingBlock.drawingId,
          ),
        );
        log('After insert: sectionList has ${_sectionList.length} items');
        for (var block in _sectionList) {
          log('Block type: ${block.runtimeType}');
        }
        log('_sectionList.length');
        log(_sectionList.length.toString());
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

      log('drawing saved and added');
      Navigator.of(context).pop();
      notifyListeners();
      return;
    } catch (err) {
      log('erroe ${err.toString()}');
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










  //save note ----> called add note inside
  Future<void> saveNote({
    required final BuildContext context,
    required final bool isForEditPage,
    required final String? noteId,

  }) async {
    try {
      final bool isContentPresent = validateContent();
      List<SketchModel> sketchlist = [];

      if (!isContentPresent) {
        if (isForEditPage && noteId != null) {
          await deleteNote(notesId: noteId);
        }

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
              sectionContnet: '${section.textEditingController.text}~0~',
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
            log('_a_-a_AD_a found ${section.sketchList.length}');
            sketchlist = List<SketchModel>.from(section.sketchList);
            log('__-_____--__-_-_drawing Section found ${sketchlist.length}');
            final sectionModel = SectionModel(
              sectionNo: i,
              sectionType: 'drawing',
              sectionContnet: section.drawingId,
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
        );
        !isForEditPage
            ? await addNote(notesModel: notesModel, sketcList: sketchlist)
            : await updateNote(notesModel: notesModel, sketcList: sketchlist);
      }

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
    _notesList = await notesLocalServiceInterface.getAllNotes();
    notifyListeners();
  }











  //add note <---- called from save note inside
  Future addNote({
    required final NotesModel notesModel,
    required final List<SketchModel> sketcList,
  }) async {
    await notesLocalServiceInterface.saveNewNote(
      notesModel: notesModel,
      sketchList: sketcList
    );
    await loadAllNotes();
  }

  Future<void> editNoteInitialization({required final String noteId}) async {
    final restorePreviusNote = await notesLocalServiceInterface.enterEditNote(
      noteId: noteId,
    );
    _titleController.text = restorePreviusNote.notesTitle ?? '';
    _sectionList.clear();

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
    loadAllNotes();
    notifyListeners();
  }






  Future updateNote({
    required final NotesModel notesModel,
    required final List<SketchModel>? sketcList,
  }) async {
    await notesLocalServiceInterface.updateNote(
      notesModel: notesModel,
      sketchList: sketcList,
    );
    loadAllNotes();
    notifyListeners();
  }
}




