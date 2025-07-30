import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/providers/search_box_pro.dart';
import 'package:noted_d/providers/settings_pro.dart';
import 'package:noted_d/widgets/home_folder_list.dart';
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
  Widget build(final BuildContext context) {
    final searchBoxProvider = Provider.of<SearchBoxPro>(context);
    final settingsProvider = Provider.of<SettingsPro>(context);
    return Column(
      children: [
        InkWell(
          onTap: () async {
            queryallTable();
          },
          child: Text(
            'Notes',
            style: textStyleOS(
              fontSize: settingsProvider.getFontSize() * 3,
              fontColor: Colors.black,
            ).copyWith(fontWeight: FontWeight.w300),
          ),
        ),
        const Gap(10),
        InkWell(
          onTap: () {
            searchBoxProvider.toggelSearchBox();
          },
          child: const HomeScreenSearchbox(isWithInputField: false),
        ),
        const Gap(10),
        const HomeFolderList(),
        Consumer<NotesPro>(
          builder: (final context, final value, final child) {
            if (value.notesList.isEmpty) {
              return Expanded(
                child: Center(
                  child: Text(
                    'Click on add icon below to start creating notes!',
                    textAlign: TextAlign.center,
                    style: textStyleOS(
                      fontSize: 12,
                      fontColor: Colors.grey.shade500,
                    ),
                  ),
                ),
              );
            } else {
              return Expanded(
                child: ListView(
                  children: [
                    GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                      shrinkWrap: true,
                      itemCount: value.notesList.length,
                      itemBuilder: (final context, final index) {
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
        const Gap(20),
      ],
    );
  }
}
