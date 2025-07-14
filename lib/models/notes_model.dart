import 'package:uuid/uuid.dart';

class NotesModel {
  final String notesId; 
  final DateTime createdAt;
  final String? notesTitle;
  final DateTime modifiedAt;
  final String? notesContentHighLight;
  List<SectionModel> sectionList;

  NotesModel({
    String? notesId,
    required this.createdAt,
    required this.modifiedAt,
    required this.notesTitle,
    required this.notesContentHighLight,
    required this.sectionList,
  }) : notesId = notesId ?? Uuid().v4();
}

class SectionModel {
  final String sectionId;

  final int sectionNo;
  final String sectionType;
  final String sectionContnet;
  

  SectionModel({
    String? sectionId,
    required this.sectionNo,
    required this.sectionType,
    required this.sectionContnet,
  }) : sectionId = sectionId ?? Uuid().v4();
}


class HomeNotesModel {
  final String notesId;
  final String? notesTitle;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final String notesContentHighlight;

  HomeNotesModel({
    required this.notesId,
    required this.notesTitle,
    required this.createdAt,
    required this.modifiedAt,
    required this.notesContentHighlight,
  });
}
