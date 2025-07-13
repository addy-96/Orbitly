import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/pages/edit_notes_page.dart';
import 'package:noted_d/models/notes_model.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/providers/search_box_pro.dart';
import 'package:provider/provider.dart';

class HomeNoteWidget extends StatelessWidget {
  const HomeNoteWidget({
    super.key,
    required this.homeNotesModel,
    required this.isSearchedResult,
  });
  final HomeNotesModel homeNotesModel;
  final bool isSearchedResult;

  List<TextSpan> highlightWords(SearchBoxPro searchProvider) {
    final List<TextSpan> characters = [];
    for (var i = 0; i <= homeNotesModel.notesContentHighlight.length - 1; i++) {
      characters.add(
        TextSpan(
          text: homeNotesModel.notesContentHighlight[i],
          style: textStyleOS(
            fontSize: 15,
            fontColor:
                homeNotesModel.notesContentHighlight[i] ==
                    searchProvider.searchController.text.trim()
                ? Colors.deepOrange
                : Colors.deepOrange,
          ),
        ),
      );
    }
    log(characters.toString());
    return characters;
  }

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesPro>(context);
    final seachProvider = Provider.of<SearchBoxPro>(context);


    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(19),
        onTap: () async {
          final res = await notesProvider.editNote(
            homeNotesModel: homeNotesModel,
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditNotes(notesModel: res),
            ),
          ); 

        },
        child: Hero(
          tag: homeNotesModel.notesId,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            height: double.minPositive,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(19),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                homeNotesModel.notesTitle != null
                    ? Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        homeNotesModel.notesTitle!,
                        style: textStyleOS(
                          fontSize: 18,
                          fontColor: Colors.black,
                        ).copyWith(fontWeight: FontWeight.w600),
                      )
                    : SizedBox.shrink(),
                homeNotesModel.notesContentHighlight.isNotEmpty
                    ? Center(
                        child: !isSearchedResult
                            ? Text(
                          maxLines: 4,
                          textAlign: TextAlign.center,
                          overflow: TextOverflow.ellipsis,
                          homeNotesModel.notesContentHighlight,
                          style: textStyleOS(
                            fontSize: 15,
                            fontColor: Colors.grey.shade500,
                          ).copyWith(fontWeight: FontWeight.w400),
                              )
                            : Consumer(
                                builder: (context, value, child) {
                                  return RichText(
                                    text: TextSpan(
                                      text: '',
                                      children: highlightWords(seachProvider),
                                    ),
                                  );
                                },
                     
                              ),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
