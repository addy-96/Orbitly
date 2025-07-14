import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:noted_d/core/snackbr.dart';

enum SectionType { text, task, image, drawing }

class NotesSectionPro with ChangeNotifier {
  final List<NoteBlocks> _sectionList = [GestureBlock()];

  List<NoteBlocks> get sectionList => _sectionList;

  addTextsection() {
    final listSize = _sectionList.length;
    if (listSize == 1) {
      _sectionList.insert(
        _sectionList.length - 1,
        TextBlock(
          textEditingController: TextEditingController(),
          blokCount: listSize,
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
            blokCount: _sectionList.length,
          );
          notifyListeners();
          return;
        } else {
          _sectionList.insert(
            _sectionList.length - 1,
            TextBlock(
              textEditingController: TextEditingController(),
              blokCount: listSize,
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
          blokCount: listSize,
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
          blokCount: _sectionList.length,
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
          blokCount: _sectionList.length,
        );
        notifyListeners();
        return;
      }
    } else if (secondLastSection is TaskBlock) {
      if (secondLastSection.textEditingController.text.trim().isEmpty) {
        sectionList[_sectionList.length - 2] = Imageblock(
          imagePath: selectedImage.path,
          blokCount: _sectionList.length,
        );
        notifyListeners();
        return;
      }
    }
    _sectionList.insert(
      _sectionList.length - 1,
      Imageblock(imagePath: selectedImage.path, blokCount: _sectionList.length),
    );
    notifyListeners();
    return;
  }

  addTaskSection(BuildContext context) {
    if (_sectionList.length == 1) {
      _sectionList.insert(
        0,
        TaskBlock(
          blockcount: _sectionList.length,
          textEditingController: TextEditingController(),
        ),
      );
      notifyListeners();
      return;
    }

    final secondLastSection = sectionList[_sectionList.length - 2];
    log('reached here 1');
    if (secondLastSection is TextBlock) {
      if (secondLastSection.textEditingController.text.trim().isEmpty) {
        sectionList[_sectionList.length - 2] = TaskBlock(
          blockcount: _sectionList.length,
          textEditingController: TextEditingController(),
        );
        notifyListeners();
        return;
      }
    } else if (secondLastSection is TaskBlock) {
      log('reached here 2');
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
        blockcount: _sectionList.length,
        textEditingController: TextEditingController(),
      ),
    );
    notifyListeners();
    return;
  }

  addDrawingSection() {}
}

abstract class NoteBlocks {}

final class TextBlock extends NoteBlocks {
  final int blokCount;
  final TextEditingController textEditingController;
  TextBlock({required this.textEditingController, required this.blokCount});
}

final class Imageblock extends NoteBlocks {
  final int blokCount;
  final String imagePath;
  Imageblock({required this.imagePath, required this.blokCount});
}

final class TaskBlock extends NoteBlocks {
  final int blockcount;

  final TextEditingController textEditingController;
  TaskBlock({required this.blockcount, required this.textEditingController});
}

final class GestureBlock extends NoteBlocks {}
