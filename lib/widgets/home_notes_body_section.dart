import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/providers/settings_pro.dart';
import 'package:noted_d/widgets/home_folder_list.dart';
import 'package:noted_d/widgets/home_note_grid_box.dart';
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
    final settingsProvider = Provider.of<SettingsPro>(context);
    final notesProvider = Provider.of<NotesPro>(context);
    return Column(
      children: [
        Text(
          'Notes',
          style: textStyleOS(
            fontSize: settingsProvider.getFontSize() * 3,
            fontColor: Colors.black,
          ).copyWith(fontWeight: FontWeight.w300),
        ),
        const Gap(10),
        InkWell(
          borderRadius: BorderRadius.circular(50),
          onTap: () {},
          child: const HomeScreenSearchbox(isWithInputField: false),
        ),
        const Gap(10),
        notesProvider.notesList.isNotEmpty
            ? const HomeFolderList()
            : const SizedBox.shrink(),
        const Gap(10),
        Consumer<NotesPro>(
          builder: (final context, final value, final child) {
            if (value.notesList.isEmpty) {
              return Expanded(
                child: Center(
                  child: Text(
                    'Click on add icon below to start creating notes!',
                    textAlign: TextAlign.center,
                    style: textStyleOS(
                      fontSize: settingsProvider.getFontSize(),
                      fontColor: Colors.grey.shade500,
                    ),
                  ),
                ),
              );
            } else {
              return Expanded(
                child: settingsProvider.settings[layoutSetKey] == 'Grid'
                    ? ListView(
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
                              return HomeNoteGridBox(
                                homeNotesModel: value.notesList[index],
                                isSearchedResult: false,
                              );
                            },
                          ),
                        ],
                      )
                    : ListView.builder(
                        itemCount: value.notesList.length,
                        itemBuilder: (final context, final index) =>
                            HomeNoteGridBox(
                              homeNotesModel: value.notesList[index],
                              isSearchedResult: false,
                            ),
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
