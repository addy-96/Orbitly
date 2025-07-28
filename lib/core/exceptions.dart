class NoteAlreadyExistinFolderException implements Exception {
  final String message;

  NoteAlreadyExistinFolderException({required this.message});
}
