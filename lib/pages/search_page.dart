import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/search_box_pro.dart';
import 'package:noted_d/widgets/home_note_grid_box.dart';
import 'package:noted_d/widgets/home_screen_searchbox.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController searchController = TextEditingController();

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final searchBoxPro = Provider.of<SearchBoxPro>(
      context,
    ); // Only read, no listening
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
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
              HomeScreenSearchbox(
                isWithInputField: true,
                searchController: searchController,
              ),
              const Gap(20),
              Expanded(
                child:
                    (searchBoxPro.searchResults.isEmpty &&
                        searchController.text.trim().isEmpty)
                    ? _buildMessage('Type to search notes')
                    : searchBoxPro.searchResults.isEmpty
                    ? _buildMessage('No results found')
                    : GridView.builder(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                            ),
                        itemBuilder: (final context, final index) {
                          return HomeNoteGridBox(
                            homeNotesModel: searchBoxPro.searchResults[index],
                            isSearchedResult: true,
                          );
                        },
                        itemCount: searchBoxPro.searchResults.length,
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
