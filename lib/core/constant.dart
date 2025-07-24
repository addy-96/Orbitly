import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:provider/provider.dart';




//sqflite tables 
const notesTable = 'notes';
const sectionTable = 'sections';
const taskTable = 'tasks';
const drawingTable = 'drawings';

//notes table columns -ntc
const notesIdNTC = 'notesId'; 
const notesTitleNTC = 'notesTitle';
const createdAtNTC = 'createdAt';
const modifiedAtNTC = 'modifiedAt';
const notesContentHighLightNTC = 'notesContentHighLight';

//sections table columns -stc
const sectioonIdSTC = 'sectionId';
const notesIdSTC = 'notesId';
const sectionNoSTC = 'sectionNo';
const typeSTC = 'type';
const contentSTC = 'content';

//tasks table coumn ttc
const taskIdTTC = 'taskId';
const taskContentTTC = 'taskContent';
const completeStatusTTC = 'completeStatus';

//drawing table column dtc
const drawingIdDTC = 'drawingId';
const notesIdDTC = 'noteId';
const sectionNoDTC = 'sectionNo';
const sketchColorDTC = 'sketchColor';
const sketchStrokeDTC = 'sketchStroke';
const sketchPointsDTC = 'sketchPoint';
const sketchNoDTC = 'sketchNo';



//

final scaffoldBackgroudColor = Colors.grey.shade200;

const Map<int, String> months = {
  0: 'January',
  2: 'February',
  3: 'March',
  4: 'April',
  5: 'May',
  6: 'June',
  7: 'July',
  8: 'August',
  9: 'Septemeber',
  10: 'October',
  11: 'November',
  12: 'December',
};

final List<Color> colorPallets = [
  const Color(0xFF000000), // Black
  const Color(0xFFF44336), // Red
  const Color(0xFF4CAF50), // Green
  const Color(0xFF2196F3), // Blue
  const Color(0xFFFFEB3B), // Yellow
  const Color(0xFFFF9800), // Orange
  const Color(0xFF9C27B0), // Purple
  const Color(0xFFE91E63), // Pink
  const Color(0xFF795548), // Brown
  const Color(0xFF9E9E9E), // Grey
  const Color(0xFF81D4FA), // Baby Blue
  const Color(0xFFA5D6A7), // Mint Green
  const Color(0xFFF8BBD0), // Cotton Candy Pink
  const Color(0xFFFFCCBC), // Peach
  const Color(0xFFCE93D8), // Lavender
  const Color(0xFF4FC3F7), // Sky Blue
  const Color(0xFFFFF59D), // Light Yellow
  const Color(0xFFE0E0E0), // Light Grey
  const Color(0xFFFF8A65), // Coral
];



DateTime getDateTime() {
  return DateTime.now();
}


void displaySectionLis(final BuildContext context) {
  final notesPro = Provider.of<NotesPro>(context, listen: false);
  log('-------------------------display section---------------------------');
  for (var section in notesPro.sectionList) {
    if (section is TextBlock) {
      log('TEXT block');
    } else if (section is TaskBlock) {
      log('TASK block');
    } else if (section is GestureBlock) {
      log('GESTURE block');
    } else if (section is DrawingBlock) {
      log('DRAWING block');
    } else if (section is Imageblock) {
      log('IMAGE block');
    }
  }
  log('-------------------------display section---------------------------');
}
