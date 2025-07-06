import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/create_notes.dart';
import 'package:noted_d/providers/navbar_pro.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/services%20/notes_local_service.dart';
import 'package:noted_d/widgets/home_note_widget.dart';
import 'package:noted_d/widgets/home_screen_searchbox.dart';
import 'package:provider/provider.dart';

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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () async {
                  await NotesLocalServiceInterfaceImpl().getAllNotes();
                },
                icon: Icon(HugeIcons.strokeRoundedFolder01),
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(HugeIcons.strokeRoundedSettings03),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
            child: Consumer<NavbarPro>(
              builder: (context, value, child) {
                return value.index == 0
                    ? notesBody(screenWidth: screenWidth)
                    : taskBody();
              },
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
        selectedIconTheme: IconThemeData(size: 22, color: Colors.black),
        unselectedIconTheme: IconThemeData(
          size: 18,
          color: Colors.grey.shade900,
        ),
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.grey.shade700,
        unselectedFontSize: 11,

        selectedFontSize: 12,
        selectedLabelStyle: textStyleOS(fontSize: 12, fontColor: Colors.black),
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
        backgroundColor: const Color.fromARGB(255, 230, 216, 93),
        shape: CircleBorder(),
        child: Icon(HugeIcons.strokeRoundedAdd02, color: Colors.white),
      ),
    );
  }
}

Widget taskBody() => Column(children: [Text('Tasks')]);

Widget notesBody({required double screenWidth}) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
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
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            shrinkWrap: true,
            itemCount: value.notesList.length,
            itemBuilder: (context, index) {
              return HomeNoteWidget(notesModel: value.notesList[index]);
            },
          );
        }
      },
    ),
  ],
);
