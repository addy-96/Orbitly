import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/pages/create_notes_page.dart';
import 'package:noted_d/providers/navbar_pro.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/services%20/notes_local_service.dart';
import 'package:noted_d/pages/settings_page.dart';
import 'package:noted_d/widgets/home_note_widget.dart';
import 'package:noted_d/widgets/home_screen_searchbox.dart';
import 'package:provider/provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class NotesAppHome extends StatefulWidget {
  const NotesAppHome({super.key});

  @override
  State<NotesAppHome> createState() => _NotesAppHomeState();
}

class _NotesAppHomeState extends State<NotesAppHome> {
  var scaffoldBackgroudCOlor = Colors.grey.shade200;

  bool _isInitialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      Provider.of<NotesPro>(context, listen: false).loadAllNotes();
      _isInitialized = true;
    }
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<NotesPro>(context, listen: false).loadAllNotes();
    });
  }

  @override
  Widget build(BuildContext context) {
    final navIndexPro = Provider.of<NavbarPro>(context);
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: scaffoldBackgroudCOlor,
      body: Column(
        children: [
          Gap(10),
          Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: () async {},
                  icon: Icon(HugeIcons.strokeRoundedFolder01),
                ),
                IconButton(
                  onPressed: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => SettingsPage()),
                    );
                  },
                  icon: Icon(HugeIcons.strokeRoundedSettings03),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
              child: Consumer<NavbarPro>(
                builder: (context, value, child) {
                  return value.index == 0
                      ? notesBody(screenWidth: screenWidth)
                      : taskBody();
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: scaffoldBackgroudCOlor,
        currentIndex: navIndexPro.index,
        onTap: (value) {
          navIndexPro.changeIndex(value);
        },
        unselectedLabelStyle: textStyleOS(
          fontSize: 8,
          fontColor: Colors.grey.shade900,
        ),
        selectedIconTheme: IconThemeData(size: 22, color: Colors.deepOrange),
        unselectedIconTheme: IconThemeData(
          size: 18,
          color: Colors.grey.shade900,
        ),
        selectedItemColor: Colors.deepOrange,
        unselectedItemColor: Colors.grey.shade700,
        unselectedFontSize: 11,

        selectedFontSize: 12,
        selectedLabelStyle: textStyleOS(
          fontSize: 12,
          fontColor: Colors.deepOrange,
        ),
        items: [
          BottomNavigationBarItem(
            label: 'Notes',
            icon: Icon(HugeIcons.strokeRoundedFiles02),
          ),
          BottomNavigationBarItem(
            icon: Icon(HugeIcons.strokeRoundedCheckmarkSquare04),
            label: 'Tasks',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          navIndexPro.index == 0
              ? Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => CreateNotesPage()),
                )
              : log('tasks add');
        },
        backgroundColor: Colors.black87,
        shape: CircleBorder(),
        child: Icon(HugeIcons.strokeRoundedAdd02, color: Colors.deepOrange),
      ),
    );
  }
}

Widget taskBody() => Column(children: [Text('Tasks')]);

Widget notesBody({required double screenWidth}) => ListView(
  children: [
    Text(
      'Notes',
      style: textStyleOS(
        fontSize: screenWidth / 12,
        fontColor: Colors.black,
      ).copyWith(fontWeight: FontWeight.w300),
    ),
    Gap(10),
    HomeScreenSearchbox(),
    Consumer<NotesPro>(
      builder: (context, value, child) {
        if (value.notesList.isEmpty) {
          return SizedBox.shrink();
        } else {
          return GridView.builder(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            shrinkWrap: true,
            itemCount: value.notesList.length,
            itemBuilder: (context, index) {
              log('noteId:  ${value.notesList[index].notesId}');
              return HomeNoteWidget(homeNotesModel: value.notesList[index]);
            },
          );
        }
      },
    ),
    Gap(20),
  ],
);
