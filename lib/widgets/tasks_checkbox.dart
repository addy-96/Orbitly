import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/providers/task_pro.dart';
import 'package:provider/provider.dart';

class TasksCheckbox extends StatefulWidget {
  TasksCheckbox({super.key, required this.index});

  int index;

  @override
  State<TasksCheckbox> createState() => _TasksCheckboxState();
}

class _TasksCheckboxState extends State<TasksCheckbox> {
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskPro>(context);
    return IconButton(
      onPressed: () async {
        int isComplete = taskProvider.taskList[widget.index].isComplete;
        isComplete = isComplete == 0 ? 1 : 0;
        await taskProvider.updateTaskStatus(
          taskid: taskProvider.taskList[widget.index].taskId!,
          iscomplete: isComplete,
        );
      },
      icon: Consumer<TaskPro>(
        builder: (context, value, child) {
          return value.taskList[widget.index].isComplete == 0
              ? Icon(HugeIcons.strokeRoundedSquare)
              : Icon(
                  HugeIcons.strokeRoundedCheckmarkSquare02,
                  color: Colors.deepOrange,
                );
        },
      ),
    );
  }
}


/*
!widget.isComplete
          ? Icon(HugeIcons.strokeRoundedSquare)
          : Icon(
              HugeIcons.strokeRoundedCheckmarkSquare02,
              color: Colors.deepOrange,
            ),
*/ 