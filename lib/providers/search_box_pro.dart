import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:noted_d/models/notes_model.dart';
import 'package:noted_d/services%20/notes_local_service.dart';

class SearchBoxPro with ChangeNotifier {
  final NotesLocalServiceInterface notesLocalServiceInterface;

  SearchBoxPro({required this.notesLocalServiceInterface});

  bool _isSearchBoxOpened = false;

  final TextEditingController _searchController = TextEditingController();

  List<HomeNotesModel> _searchedNotes = [];

  List<HomeNotesModel> get searchNotes => _searchedNotes;

  TextEditingController get searchController => _searchController;

  bool get isSearchBoxOpened => _isSearchBoxOpened;

  void toggelSearchBox() {
    _isSearchBoxOpened = !isSearchBoxOpened;
    notifyListeners();
  }

  void clearSearchedNotes() {
    _searchedNotes.clear();
  }

  void onSearch({required String searchedString}) async {
    _searchedNotes = await notesLocalServiceInterface.getSearchedNotes(
      searchQuery: searchedString,
    );
    log(searchNotes.length.toString());
    notifyListeners();
  }
}
