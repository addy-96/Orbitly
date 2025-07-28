import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/widgets/folder_container_folder_page.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

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
      log(foldernameController.text);
      notesProvider.addaFolder(foldername: foldernameController.text.trim());
      foldernameController.clear();
      context.pop();
    }
  }

  @override
  Widget build(final BuildContext context) {
    final notesProvider = Provider.of<NotesPro>(context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: InkWell(
          onTap: () async {
            final getdbpath = await getDatabasesPath();
            final dbpath = p.join(getdbpath, 'notes.db');
            final db = await openDatabase(dbpath);
            final res = await db.query(folderTable);
            log(res.toString());
          },
          child: Text(
            'Folders',
            style: textStyleOS(
              fontSize: 22,
              fontColor: Colors.black,
            ).copyWith(fontWeight: FontWeight.w400),
          ),
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
                                'Enter folder name',
                                style: textStyleOS(
                                  fontSize: 18,
                                  fontColor: Colors.black,
                                ),
                              ),
                              const Gap(10),
                              Form(
                                key: formkey,
                                child: TextFormField(
                                  controller: foldernameController,
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
                                    hintText: 'Folder name',
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
                                    color: Colors.deepOrange,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Add Folder',
                                      style: textStyleOS(
                                        fontSize: 18,
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
                                    color: Colors.deepOrange,
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Center(
                                    child: Text(
                                      'Cancel',
                                      style: textStyleOS(
                                        fontSize: 18,
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
                  border: Border.all(width: 3, color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    '${notesProvider.folderList.isEmpty ? 'Make' : 'Add'} a folder',
                    style: textStyleOS(
                      fontSize: 18,
                      fontColor: Colors.deepOrange,
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
