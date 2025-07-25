
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/search_box_pro.dart';
import 'package:noted_d/widgets/home_note_widget.dart';
import 'package:noted_d/widgets/home_screen_searchbox.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});
  @override
  Widget build(final BuildContext context) {
    final searchBoxPro = Provider.of<SearchBoxPro>(context);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (final didPop, final result) {
        if (!didPop) {
          searchBoxPro.searchController.clear();
          searchBoxPro.clearSearchedNotes();
          searchBoxPro.toggelSearchBox();
        }
      },
      child: Scaffold(
        backgroundColor: scaffoldBackgroudColor,
        body: Selector<SearchBoxPro, bool>(
          selector: (final p0, final p1) => p1.isSearchBoxOpened,
          builder: (final context, final value, final child) {
            if (!value) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pop();
              });
              return const SizedBox.shrink();
            }
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
              child: Column(
                children: [
                  const Gap(20),
                  const HomeScreenSearchbox(isWithInputField: true),
                  Expanded(
                    child: Consumer<SearchBoxPro>(
                      builder: (final context, final value, final child) {
                        final listOfSearchedNotes = searchBoxPro.searchNotes;
                        if (searchBoxPro.searchController.text.trim().isEmpty) {
                          return  Center(
                            child: Text('Search to find notes!', 
                             textAlign: TextAlign.center,
                    style: textStyleOS(fontSize: 12, fontColor: Colors.grey.shade500),
                             ),
                          );
                        }
                        if (searchBoxPro.searchController.text
                                .trim()
                                .isNotEmpty &&
                            listOfSearchedNotes.isEmpty) {
                          return  Center(child: Text('No note found!', 
                           textAlign: TextAlign.center,
                    style: textStyleOS(fontSize: 12, fontColor: Colors.grey.shade500),
                          ));
                        } else {
                          return GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                            itemCount: listOfSearchedNotes.length,
                            itemBuilder: (final context, final index) {
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
