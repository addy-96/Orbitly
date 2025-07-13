
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:noted_d/providers/search_box_pro.dart';
import 'package:noted_d/widgets/home_note_widget.dart';
import 'package:noted_d/widgets/home_screen_searchbox.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final searchBoxPro = Provider.of<SearchBoxPro>(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          searchBoxPro.searchController.clear();
          searchBoxPro.clearSearchedNotes();
          searchBoxPro.toggelSearchBox();
        }
      },
      child: Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: Selector<SearchBoxPro, bool>(
          selector: (p0, p1) => p1.isSearchBoxOpened,
          builder: (context, value, child) {
            if (!value) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pop();
              });

              return const SizedBox.shrink(); // return something small temporarily
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                children: [
                  Gap(20),
                  HomeScreenSearchbox(isWithInputFIeld: true),
                  Expanded(
                    child: Consumer<SearchBoxPro>(
                      builder: (context, value, child) {
                        final listOfSearchedNotes = searchBoxPro.searchNotes;
                        if (searchBoxPro.searchController.text.trim().isEmpty) {
                          return Center(child: Text('Search to find notes!n'));
                        }
                        if (searchBoxPro.searchController.text
                                .trim()
                                .isNotEmpty &&
                            listOfSearchedNotes.isEmpty) {
                          return Center(child: Text('No note found!'));
                        } else {
                          return GridView.builder(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                            itemCount: listOfSearchedNotes.length,
                            itemBuilder: (context, index) {
                              return HomeNoteWidget(
                                homeNotesModel: listOfSearchedNotes[index],
                                isSearchedResult: true,
                              );
                            },
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
