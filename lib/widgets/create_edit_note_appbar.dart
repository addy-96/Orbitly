import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/widgets/folder_container_folder_page.dart';

PreferredSizeWidget createEditNoteAppBar({
  required final bool isCreate,
  required final NotesPro notesPro,
  required final BuildContext context,
  required final String? noteId,
}) {
  //final DrawingPro drawingPro = Provider.of<DrawingPro>(context);
  return AppBar(
    surfaceTintColor: Colors.transparent,
    forceMaterialTransparency: true,
    leading: IconButton(
      onPressed: () async {
        if (isCreate) {
          await notesPro.saveNote(
            context: context,
            isForEditPage: false,
            noteId: noteId,
          );
        } else {
          await notesPro.saveNote(
            context: context,
            isForEditPage: true,
            noteId: noteId,
          );
        }
      },
      icon: const Icon(HugeIcons.strokeRoundedArrowLeft02),
    ),
    actions: [
      IconButton(
        onPressed: () async {},
        icon: const Icon(HugeIcons.strokeRoundedShare01),
      ),
      IconButton(
        onPressed: () {},
        icon: const Icon(HugeIcons.strokeRoundedTShirt),
      ),
      noteId != null
          ? PopupMenuButton(
              icon: const Icon(HugeIcons.strokeRoundedMenu01),
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              itemBuilder: (final context) {
                return [
                  PopupMenuItem(
                    onTap: () {},
                    child: Text(
                      'Delete',
                      style: textStyleOS(fontSize: 15, fontColor: Colors.black),
                    ),
                  ),
                  PopupMenuItem(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) => Dialog(
                          backgroundColor: scaffoldBackgroudColor,
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height / 2,
                            child: Center(
                              child: Scrollbar(
                                child: Padding(
                                  padding: const EdgeInsetsGeometry.symmetric(
                                    horizontal: 20,
                                    vertical: 2,
                                  ),
                                  child: Column(
                                    children: [
                                      const Gap(20),
                                      const Text('Folders'),
                                      const Gap(20),
                                      Expanded(
                                        child: ListView.builder(
                                          itemCount: notesPro.folderList.length,
                                          itemBuilder:
                                              (final context, final index) {
                                                return InkWell(
                                                  borderRadius:
                                                      BorderRadius.circular(14),
                                                  onTap: () {},
                                                  child:
                                                      FolderContainerFolderPage(
                                                        foldername: notesPro
                                                            .folderList[index],
                                                      ),
                                                );
                                              },
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          context.pop();
                                        },
                                        child: Container(
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height /
                                              18,
                                          decoration: BoxDecoration(
                                            color: Colors.deepOrange,
                                            borderRadius: BorderRadius.circular(
                                              14,
                                            ),
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Cancel',
                                              style:
                                                  textStyleOS(
                                                    fontSize: 18,
                                                    fontColor: Colors.white,
                                                  ).copyWith(
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Gap(20),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                    child: Text(
                      'Add to folder',
                      style: textStyleOS(fontSize: 15, fontColor: Colors.black),
                    ),
                  ),
                ];
              },
            )
          : const SizedBox.shrink(),
    ],
  );
}
