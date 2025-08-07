import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/providers/settings_pro.dart';
import 'package:noted_d/widgets/folder_container_folder_page.dart';
import 'package:provider/provider.dart';

class FolderPage extends StatefulWidget {
  const FolderPage({super.key});

  @override
  State<FolderPage> createState() => _FolderPageState();
}

class _FolderPageState extends State<FolderPage> {
  final formkey = GlobalKey<FormState>();
  final TextEditingController foldernameController = TextEditingController();

  @override
  void dispose() {
    foldernameController.dispose();
    super.dispose();
  }

  void _onAddFolder({required final NotesPro notesProvider}) {
    if (formkey.currentState!.validate()) {
      notesProvider.addaFolder(foldername: foldernameController.text.trim());
      foldernameController.clear();
      context.pop();
    }
  }

  @override
  Widget build(final BuildContext context) {
    final notesProvider = Provider.of<NotesPro>(context);
    final settingProvider = Provider.of<SettingsPro>(context);
    return Scaffold(
      backgroundColor: scaffoldBackgroudColor,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(HugeIcons.strokeRoundedArrowLeft01),
          onPressed: () {
            context.pop();
          },
        ),
        forceMaterialTransparency: true,
        centerTitle: true,
        title: Text(
          'Folders',
          style: textStyleOS(
            fontSize: settingProvider.getFontSize() * 1.5,
            fontColor: Colors.black,
          ).copyWith(fontWeight: FontWeight.w400),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: ListView(
          children: [
            for (var folder in notesProvider.folderList)
              FolderContainerFolderPage(foldername: folder),
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (final BuildContext context) {
                    return Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 20,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Gap(20),
                              Text(
                                'Create Folder',
                                style: textStyleOS(
                                  fontSize: settingProvider.getFontSize() * 1.2,
                                  fontColor: Colors.black,
                                ),
                              ),
                              const Gap(10),
                              Form(
                                key: formkey,
                                child: TextFormField(
                                  controller: foldernameController,
                                  maxLength: 20,
                                  validator: (final value) {
                                    if (value == null || value.trim().isEmpty) {
                                      return 'Please enter folder name to proceed!';
                                    }
                                    final alredyExist = notesProvider.folderList
                                        .any((final e) {
                                          if (e.toLowerCase() ==
                                              value.toLowerCase()) {
                                            return true;
                                          }
                                          return false;
                                        });
                                    if (alredyExist) {
                                      return 'Folder with similar name already exist, try something else.';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    errorStyle: textStyleOS(
                                      fontSize:
                                          settingProvider.getFontSize() * 0.7,
                                      fontColor: Colors.red,
                                    ),
                                    hintText: 'Folder name',
                                    hintStyle: textStyleOS(
                                      fontSize:
                                          settingProvider.getFontSize() * 1.2,
                                      fontColor: darkkgrey,
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 2,
                                      ),
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(14),
                                      borderSide: BorderSide(
                                        color: Colors.grey.shade300,
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(10),
                              InkWell(
                                onTap: () {
                                  _onAddFolder(notesProvider: notesProvider);
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 14,
                                  decoration: BoxDecoration(
                                    color: themeOrange,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Add Folder',
                                      style: textStyleOS(
                                        fontSize:
                                            settingProvider.getFontSize() * 1.2,
                                        fontColor: Colors.white,
                                      ).copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              const Gap(10),
                              InkWell(
                                onTap: () {
                                  foldernameController.clear();
                                  context.pop();
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height / 14,
                                  decoration: BoxDecoration(
                                    color: themeOrange,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Cancel',
                                      style: textStyleOS(
                                        fontSize:
                                            settingProvider.getFontSize() * 1.2,
                                        fontColor: Colors.white,
                                      ).copyWith(fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 3, color: themeOrange),
                ),
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    '${notesProvider.folderList.isEmpty ? 'Make' : 'Add'} a folder',
                    style: textStyleOS(
                      fontSize: settingProvider.getFontSize() * 1.2,
                      fontColor: themeOrange,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
