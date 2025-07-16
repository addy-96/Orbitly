
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noted_d/core/snackbr.dart';
import 'package:noted_d/models/notes_model.dart';
import 'package:noted_d/providers/notes_pro.dart';

enum SectionType { text, task, image, drawing }

class NotesSectionPro with ChangeNotifier {

NotesSectionPro({required this.notesPro});
  NotesPro notesPro;

  final List<NoteBlocks> _sectionList = [GestureBlock()];

  List<NoteBlocks> get sectionList => _sectionList;

  final TextEditingController _titleController = TextEditingController();

  TextEditingController get titleController => _titleController;

  @override
  void dispose() {
    log('notessctionpro dispose called');
    _titleController.dispose();
    for (var item in _sectionList) {
      if (item is TextBlock) {
        item.textEditingController.dispose();
      } else if (item is TaskBlock) {
        item.textEditingController.dispose();
      }
    }
    log(' _sectionList lenght ${_sectionList.length.toString()}');
    super.dispose();
  }



  addTextsection() {
    final listSize = _sectionList.length;
    if (listSize == 1) {
      _sectionList.insert(
        _sectionList.length - 1,
        TextBlock(
          textEditingController: TextEditingController(),
        ),
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
            TextBlock(
              textEditingController: TextEditingController(),
            ),
          );
          notifyListeners();
          return;
        }
      }
      _sectionList.insert(
        _sectionList.length - 1,
        TextBlock(
          textEditingController: TextEditingController(),
        ),
      );
      notifyListeners();
      return;
    }
  }

  addImageSection() async {
    final selectedImage = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (selectedImage == null) {
      return;
    }

    if (sectionList.length == 1) {
      _sectionList.insert(
        _sectionList.length - 1,
        Imageblock(
          imagePath: selectedImage.path,

        ),
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

  addTaskSection(BuildContext context) {
    if (_sectionList.length == 1) {
      _sectionList.insert(
        0,
        TaskBlock(
          textEditingController: TextEditingController(),
          isComplete: 0
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
      TaskBlock(
        isComplete: 0,
        textEditingController: TextEditingController(),
      ),
    );
    notifyListeners();
    return;
  }

  addDrawingSection() {}

  removeImageOrTask({required int index}) {
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

  saveNote({required BuildContext context}) async {
    try {
      bool isContentPresent = validateContent();

      if (!isContentPresent) {
        Navigator.of(context).pop();
        return;
      } else {
        final List<SectionModel> sectionModelList = [];
        final String notesContentHighlight = getNoteContentHiglight();

        for (var i = 0; i < _sectionList.length - 1; i++) {
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
          }
        }

        final NotesModel notesModel = NotesModel(
          createdAt: DateTime.now(),
          modifiedAt: DateTime.now(),
          notesTitle: _titleController.text,
          notesContentHighLight: notesContentHighlight,
          sectionList: sectionModelList,
        );
        await notesPro.addNote(notesModel: notesModel);
      }

      Navigator.of(context).pop();
      return;
    } catch (err) {
      throw Exception(err);
    }
  }

  bool validateContent() {
    if (_titleController.text.trim().isNotEmpty) {
      return true;
    }
    final result = _sectionList.any((e) {
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
      return false;
    });

    return result;
  }

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
}

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

final class GestureBlock extends NoteBlocks {}
