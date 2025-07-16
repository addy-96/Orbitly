import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/providers/search_box_pro.dart';
import 'package:noted_d/widgets/home_note_widget.dart';
import 'package:noted_d/widgets/home_screen_searchbox.dart';
import 'package:provider/provider.dart';

class HomeNotesBodySection extends StatefulWidget {
  const HomeNotesBodySection({super.key});

  @override
  State<HomeNotesBodySection> createState() => _HomeNotesBodySectionState();
}

class _HomeNotesBodySectionState extends State<HomeNotesBodySection> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<NotesPro>(context, listen: false).loadAllNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final searchBoxUiProvider = Provider.of<SearchBoxPro>(context);
    return Column(
      children: [
        Text(
          'Notes',
          style: textStyleOS(
            fontSize: screenWidth / 12,
            fontColor: Colors.black,
          ).copyWith(fontWeight: FontWeight.w300),
        ),
        Gap(10),
        InkWell(
          onTap: () {
            searchBoxUiProvider.toggelSearchBox();
          },
          child: HomeScreenSearchbox(isWithInputFIeld: false),
        ),
        Consumer<NotesPro>(
          builder: (context, value, child) {
            if (value.notesList.isEmpty) {
              return Expanded(
                child: Center(
                  child: Text(
                    'Click on add icon below to start creating notes!',
                  ),
                ),
              );
            } else {
              return Expanded(
                child: ListView(
                  children: [
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                      ),
                      shrinkWrap: true,
                      itemCount: value.notesList.length,
                      itemBuilder: (context, index) {
                        return HomeNoteWidget(
                          homeNotesModel: value.notesList[index],
                          isSearchedResult: false,
                        );
                      },
                    ),
                  ],
                ),
              );
            }
          },
        ),
        Gap(20),
      ],
    );
  }
}
