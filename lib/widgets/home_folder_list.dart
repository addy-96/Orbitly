import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/notes_pro.dart';
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

  @override
  Widget build(final BuildContext context) {
    final notesProvider = Provider.of<NotesPro>(context);
    final selectedFolder = notesProvider.selectedFolder;
    return SizedBox(
      height: MediaQuery.of(context).size.height / 20,
      child: Row(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              notesProvider.selectFolder(selectedFolderName: 'All');
            },
            child: Material(
              elevation: selectedFolder == 'All' ? 3 : 1,
              borderRadius: BorderRadius.circular(14),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    'All',
                    style:
                        textStyleOS(
                          fontSize: 18,
                          fontColor: selectedFolder == 'All'
                              ? Colors.deepOrange
                              : Colors.grey.shade400,
                        ).copyWith(
                          fontWeight: selectedFolder == 'All'
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
                      elevation: selectedFolder == folder ? 3 : 1,
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            folder,
                            style:
                                textStyleOS(
                                  fontSize: 18,
                                  fontColor: selectedFolder == folder
                                      ? Colors.deepOrange
                                      : Colors.grey.shade400,
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
          IconButton(
            onPressed: () {},
            icon: const Icon(HugeIcons.strokeRoundedGridView),
          )
        ],
      ),
    );
  }
}
