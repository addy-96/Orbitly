import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/models/task_model.dart';
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

  void getDivederIndent(final int length) {}

  @override
  Widget build(final BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          'Tasks',
          style: textStyleOS(
            fontSize: screenWidth / 12,
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
                      fontSize: 12,
                      fontColor: Colors.grey.shade500,
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
                                    task: task,
                                    index: index,
                                  )
                                : Stack(
                                    children: [
                                      taskTextArea(
                                        taskProvider: taskProvider,
                                        task: task,
                                        index: index,
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
                                                      .textEditingController
                                                      .text
                                                      .trim()
                                                      .length *
                                                  10,
                                              decoration: BoxDecoration(
                                                color: Colors.grey.shade500,
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
    required final DisplayTaskModel task,
    required final int index,
  }) => TextField(
    onChanged: (final text) {
      taskProvider.onEditTaskField(
        taskId: task.taskId!,
        taskContent: text.trim(),
      );
    },
    controller: task.textEditingController,
    style: textStyleOS(
      fontSize: 18,
      fontColor: task.isComplete == 1 ? Colors.grey.shade500 : Colors.black,
    ).copyWith(fontStyle: task.isComplete == 1 ? FontStyle.italic : null),
    decoration: InputDecoration(
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(width: 1, color: Colors.grey.shade500),
      ),
      border: InputBorder.none,
    ),
  );
}
