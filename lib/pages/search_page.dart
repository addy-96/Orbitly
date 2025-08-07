import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/models/notes_model.dart';
import 'package:noted_d/providers/search_box_pro.dart';
import 'package:noted_d/widgets/home_note_grid_box.dart';
import 'package:noted_d/widgets/home_screen_searchbox.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(final BuildContext context) {
    final searchBoxPro = context
        .read<SearchBoxPro>(); // Only read, no listening
    log('search page build');
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          searchBoxPro.clearSearchedNotes();
          searchBoxPro.toggelSearchBox();
          context.pop();
        }
      },
      child: Scaffold(
        backgroundColor: scaffoldBackgroudColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            children: [
              const Gap(20),
              const HomeScreenSearchbox(isWithInputField: true),

              /// Main search result area
              Expanded(
                child: Selector<SearchBoxPro, List<HomeNotesModel>>(
                  selector: (_, provider) => provider.searchNotes,
                  builder: (context, searchResults, _) {
                    final searchText = context
                        .read<SearchBoxPro>()
                        .searchController
                        .text
                        .trim();

                    if (searchText.isEmpty) {
                      return _buildMessage('Search to find notes!');
                    }

                    if (searchText.isNotEmpty && searchResults.isEmpty) {
                      return _buildMessage('No note found!');
                    }

                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                      itemCount: searchResults.length,
                      itemBuilder: (context, index) {
                        return HomeNoteGridBox(
                          homeNotesModel: searchResults[index],
                          isSearchedResult: true,
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Reusable widget for empty messages
  Widget _buildMessage(String message) {
    return Center(
      child: Text(
        message,
        textAlign: TextAlign.center,
        style: textStyleOS(fontSize: 12, fontColor: Colors.grey.shade500),
      ),
    );
  }
}
