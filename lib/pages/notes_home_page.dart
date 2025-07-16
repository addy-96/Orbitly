import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/pages/create_notes_page.dart';
import 'package:noted_d/pages/folder_page.dart';
import 'package:noted_d/pages/search_page.dart';
import 'package:noted_d/providers/navbar_pro.dart';
import 'package:noted_d/pages/settings_page.dart';
import 'package:noted_d/providers/search_box_pro.dart';
import 'package:noted_d/providers/task_pro.dart';
import 'package:noted_d/widgets/home_notes_body_section.dart';
import 'package:noted_d/widgets/home_notes_tasks_section.dart';
import 'package:provider/provider.dart';

class NotesAppHome extends StatefulWidget {
  const NotesAppHome({super.key});

  @override
  State<NotesAppHome> createState() => _NotesAppHomeState();
}

class _NotesAppHomeState extends State<NotesAppHome> {
  var scaffoldBackgroudCOlor = Colors.grey.shade200;


  @override
  Widget build(BuildContext context) {
    final navIndexPro = Provider.of<NavbarPro>(context);
    final taskPro = Provider.of<TaskPro>(context);
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
                  onPressed: () async {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => FolderPage()),
                    );
                  },
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
                      ? Consumer<SearchBoxPro>(
                          builder: (context, value, child) {
                            if (value.isSearchBoxOpened) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SearchPage(),
                                  ),
                                );
                              });

                              return const SizedBox.shrink(); // return something small temporarily
                            } else {
                              return HomeNotesBodySection();
                            }
                          },
                        )

                      : HomeNotesTasksSection();
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: scaffoldBackgroudCOlor,
        currentIndex: navIndexPro.index,
        onTap: (value) async {
          navIndexPro.changeIndex(value);
          if (navIndexPro.index == 1 && value == 0) {
            await Provider.of<TaskPro>(context).saveCurrentTasks();
          }
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
        onPressed: () async {
          if (navIndexPro.index == 0) {
            Navigator.of(
              context,
            ).push(
                  MaterialPageRoute(builder: (context) => CreateNotesPage()),
                );
          } else {
            taskPro.onAddTask();
          }
              
        },
        backgroundColor: Colors.deepOrange,
        shape: CircleBorder(),
        child: Icon(HugeIcons.strokeRoundedAdd02, color: Colors.white),
      ),
    );
  }
}





