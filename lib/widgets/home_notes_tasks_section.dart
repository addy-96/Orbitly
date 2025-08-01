import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/models/task_model.dart';
import 'package:noted_d/providers/settings_pro.dart';
import 'package:noted_d/providers/task_pro.dart';
import 'package:noted_d/widgets/tasks_checkbox.dart';
import 'package:provider/provider.dart';

class HomeNotesTasksSection extends StatefulWidget {
  const HomeNotesTasksSection({super.key});

  @override
  State<HomeNotesTasksSection> createState() => _HomeNotesTasksSectionState();
}

class _HomeNotesTasksSectionState extends State<HomeNotesTasksSection> {
  late TaskPro taskPro;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    taskPro = Provider.of<TaskPro>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<TaskPro>(context, listen: false).initializeTask();
    });
  }

  

  @override
  Widget build(final BuildContext context) {
    final settingsProvider = Provider.of<SettingsPro>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Tasks',
          style: textStyleOS(
            fontSize: settingsProvider.getFontSize() * 3,
            fontColor: Colors.black,
          ),
        ),
        const Gap(30),
        Expanded(
          child: Consumer<TaskPro>(
            builder: (final context, final taskProvider, final child) {
              if (taskProvider.taskList.isEmpty) {
                return Center(
                  child: Text(
                    'Click on add button to add new task!',
                    style: textStyleOS(
                      fontSize: settingsProvider.getFontSize(),
                      fontColor: darkkgrey,
                    ),
                  ),
                );
              } else {
                return ListView.builder(
                  itemCount: taskProvider.taskList.length,
                  itemBuilder: (final context, final index) {
                    final task = taskProvider.taskList[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 1.0,
                        horizontal: 2,
                      ),
                      child: Row(
                        children: [
                          TasksCheckbox(index: index),
                          Expanded(
                            child: taskProvider.taskList[index].isComplete == 0
                                ? taskTextArea(
                                    taskProvider: taskProvider,
                                    taskmodel: task,
                                    index: index,
                                    settingsProvider: settingsProvider
                                  )
                                : Stack(
                                    children: [
                                      taskTextArea(
                                        taskProvider: taskProvider,
                                        taskmodel: task,
                                        index: index,
                                        settingsProvider: settingsProvider
                                      ),
                                      Positioned.fill(
                                        child: Container(
                                          height: 1,
                                          width: 100,
                                          decoration: const BoxDecoration(
                                            color: Colors.transparent,
                                          ),
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Container(
                                              height: 1,
                                              width:
                                                  task
                                                      .taskController
                                                      .text
                                                      .trim()
                                                      .length *
                                                  10,
                                              decoration: BoxDecoration(
                                                color: darkkgrey,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
            },
          ),
        ),
      ],
    );
  }

  Widget taskTextArea({
    required final TaskPro taskProvider,
    required final TaskModel taskmodel,
    required final int index,
    required final SettingsPro settingsProvider,
  }) => TextField(
    onChanged: (final text) {
      
      taskProvider.onEditTaskField(
        taskId: taskmodel.taskId!,
        taskContent: text.trim(),
      );

    },
    controller: taskmodel.taskController,
    style: textStyleOS(
      fontSize: settingsProvider.getFontSize(),
      fontColor: taskmodel.isComplete == 1 ? darkkgrey : Colors.black,
    ).copyWith(fontStyle: taskmodel.isComplete == 1 ? FontStyle.italic : null),
    decoration: InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 1, color: darkkgrey),
      ),
      border: InputBorder.none,
    ),
  );
}
