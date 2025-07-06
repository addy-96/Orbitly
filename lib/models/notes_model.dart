class NotesModel {
  final int notesId;
  final DateTime createdAt;
  final String? notesTitle;
  final DateTime modifiedAt;

  final String? notesContent;

  NotesModel({
    required this.createdAt,
    required this.modifiedAt,
    required this.notesId,
    required this.notesTitle,
    required this.notesContent,
  });
}
