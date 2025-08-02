import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/providers/settings_pro.dart';
import 'package:noted_d/widgets/home_grid_setting_icon.dart';
import 'package:provider/provider.dart';

class HomeFolderList extends StatefulWidget {
  const HomeFolderList({super.key});

  @override
  State<HomeFolderList> createState() => _HomeFolderListState();
}

class _HomeFolderListState extends State<HomeFolderList> {
  @override
  void initState() {
    final notesProvider = Provider.of<NotesPro>(context, listen: false);
    notesProvider.loadAllFolders();
    super.initState();
  }

  final all = 'All';

  @override
  Widget build(final BuildContext context) {
    final notesProvider = Provider.of<NotesPro>(context);
    final settingsProvider = Provider.of<SettingsPro>(context);
    final selectedFolder = notesProvider.selectedFolder;
    final BorderRadius borderRadius = BorderRadius.circular(14);
    return SizedBox(
      height: MediaQuery.of(context).size.height / 18,
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              notesProvider.selectFolder(selectedFolderName: all);
            },
            child: Material(
              elevation: selectedFolder == all ? 3 : 0,
              borderRadius: borderRadius,
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    all,
                    style:
                        textStyleOS(
                          fontSize: settingsProvider.getFontSize() * 1.2,
                          fontColor: selectedFolder == all ? themeOrange : grey,
                        ).copyWith(
                          fontWeight: selectedFolder == all
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                  ),
                ),
              ),
            ),
          ),
          const Gap(4),
          Expanded(
            child: ListView.builder(
              itemCount: notesProvider.folderList.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (final context, final index) {
                final folder = notesProvider.folderList[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 0,
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      notesProvider.selectFolder(selectedFolderName: folder);
                    },
                    child: Material(
                      elevation: selectedFolder == folder ? 3 : 0,
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            folder,
                            style:
                                textStyleOS(
                                  fontSize:
                                      settingsProvider.getFontSize() * 1.3,
                                  fontColor: selectedFolder == folder
                                      ? themeOrange
                                      : grey,
                                ).copyWith(
                                  fontWeight: selectedFolder == folder
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsetsGeometry.only(top: 10, bottom: 10),
            child: VerticalDivider(color: Colors.grey.shade400),
          ),
          const HomeGridSettingIcon(),
        ],
      ),
    );
  }
}
