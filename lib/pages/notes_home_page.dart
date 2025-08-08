import 'package:Orbitly/core/constant.dart';
import 'package:Orbitly/providers/navbar_pro.dart';
import 'package:Orbitly/providers/notes_pro.dart';
import 'package:Orbitly/providers/settings_pro.dart';
import 'package:Orbitly/providers/task_pro.dart';
import 'package:Orbitly/widgets/home_app_bar_actions.dart';
import 'package:Orbitly/widgets/home_bottom_nav_bar.dart';
import 'package:Orbitly/widgets/home_floating_action_button.dart';
import 'package:Orbitly/widgets/home_notes_body_section.dart';
import 'package:Orbitly/widgets/home_notes_tasks_section.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'package:provider/provider.dart';

class NotesAppHome extends StatefulWidget {
  const NotesAppHome({super.key});

  @override
  State<NotesAppHome> createState() => _NotesAppHomeState();
}

class _NotesAppHomeState extends State<NotesAppHome> {
  @override
  Widget build(final BuildContext context) {
    final navIndexProvider = Provider.of<NavbarPro>(context);
    final taskProvider = Provider.of<TaskPro>(context);
    final settingsProvider = Provider.of<SettingsPro>(context);
    final notesProvider = Provider.of<NotesPro>(context, listen: false);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (final didPop, final result) async {
        if (!didPop) {
          if (navIndexProvider.index == 1) {
            await taskProvider.saveCurrentTasks();
          }
          Navigator.of(context).pop();
        }
      },
      child: Scaffold(
        backgroundColor: scaffoldBackgroudColor,
        body: Column(
          children: [
            const Gap(10),
            const HomeAppBarActions(),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
                child: navIndexProvider.index == 0
                    ? const HomeNotesBodySection()
                    : const HomeNotesTasksSection(),
              ),
            ),
          ],
        ),
        bottomNavigationBar: bottomNavbar(
          navIndexPro: navIndexProvider,
          taskPro: taskProvider,
          settingsprovider: settingsProvider,
        ),
        floatingActionButton: homefloatingActionButton(
          context: context,
          navIndexPro: navIndexProvider,
          taskPro: taskProvider,
          notesPro: notesProvider,
        ),
      ),
    );
  }
}
