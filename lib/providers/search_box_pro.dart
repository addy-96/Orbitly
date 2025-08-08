import 'package:Orbitly/models/notes_model.dart';
import 'package:Orbitly/services/notes_local_service.dart';
import 'package:flutter/material.dart';

class SearchBoxPro with ChangeNotifier {
  final NotesLocalServiceInterface notesLocalServiceInterface;

  SearchBoxPro({required this.notesLocalServiceInterface});

  List<HomeNotesModel> _searchResults = [];
  List<HomeNotesModel> get searchResults => _searchResults;

  void onSearch({required final String query}) async {
    final result = await notesLocalServiceInterface.getSearchedNotes(
      searchQuery: query,
    );
    _searchResults = result;
    notifyListeners();
  }
}
