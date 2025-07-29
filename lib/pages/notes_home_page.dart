import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/providers/navbar_pro.dart';
import 'package:noted_d/providers/search_box_pro.dart';
import 'package:noted_d/providers/task_pro.dart';
import 'package:noted_d/widgets/home_app_bar_actions.dart';
import 'package:noted_d/widgets/home_bottom_nav_bar.dart';
import 'package:noted_d/widgets/home_floating_action_button.dart';
import 'package:noted_d/widgets/home_notes_body_section.dart';
import 'package:noted_d/widgets/home_notes_tasks_section.dart';
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

    return Scaffold(
      backgroundColor: scaffoldBackgroudColor,
      body: Column(
        children: [
          const Gap(10),
          HomeAppBarActions(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 20, top: 30, right: 20),
              child: Consumer<NavbarPro>(
                builder: (final context, final value, final child) {
                  return value.index == 0
                      ? Consumer<SearchBoxPro>(
                          builder: (final context, final value, final child) {
                            if (value.isSearchBoxOpened) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                context.push('/search');
                              });
                              return const SizedBox.shrink();
                            } else {
                              return const HomeNotesBodySection();
                            }
                          },
                        )
                      : const HomeNotesTasksSection();
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: bottomNavbar(navIndexPro: navIndexProvider),
      floatingActionButton: homefloatingActionButton(
        context: context,
        navIndexPro: navIndexProvider,
        taskPro: taskProvider,
      ),
    );
  }
}
