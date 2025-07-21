import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:noted_d/models/task_model.dart';
import 'package:noted_d/services/tasks_local_service.dart';

class TaskPro with ChangeNotifier {
  TaskPro({required this.tasksLocalServiceInterface});

  final TasksLocalServiceInterface tasksLocalServiceInterface;
  List<DisplayTaskModel> _tasksList = [];

  List<DisplayTaskModel> get taskList => _tasksList;

  void onAddTask() async {
    if (_tasksList.isEmpty) {
      _tasksList.add(DisplayTaskModel(taskName: '', isComplete: 0));
      notifyListeners();
    }
    if (_tasksList.isNotEmpty) {
      if (_tasksList.last.textEditingController.text.trim().isNotEmpty) {
        _tasksList.add(DisplayTaskModel(taskName: '', isComplete: 0));

        notifyListeners();
      }
    }
    return;
  }

  void onEditTaskField({
    required final String taskId,
    required final String taskContent,
  }) async {
    if (taskContent.trim().isEmpty) {
      for (var i = 0; i < _tasksList.length; i++) {
        if (_tasksList[i].taskId == taskId) {
          _tasksList.removeAt(i);
          notifyListeners();
        }
      }
    }
  }

  void initializeTask() async {
    log('initialize task called');
    final getalltasks = await tasksLocalServiceInterface.loadAllTasks();
    final List<DisplayTaskModel> storedTaskList = [];
    for (var item in getalltasks) {
      storedTaskList.add(
        DisplayTaskModel(
          taskId: item.taskId,
          taskName: item.taskName,
          isComplete: item.isComplete,
        ),
      );
      _tasksList = storedTaskList;
      log(_tasksList.length.toString());
      notifyListeners();
    }
  }

  Future saveCurrentTasks() async {
    await tasksLocalServiceInterface.updateTaskTable(
      currentTaskList: _tasksList,
    );
    disposeControllers();
  }

  void disposeControllers() {
    for (var item in taskList) {
      item.textEditingController.dispose();
    }
  }

  Future updateTaskStatus({
    required final String taskid,
    required final int iscomplete,
  }) async {
    await tasksLocalServiceInterface.updateTaskCheckBox(
      isComplete: iscomplete,
      taskId: taskid,
    );
    for (var item in _tasksList) {
      if (item.taskId == taskid) {
        item.isComplete = iscomplete;
        notifyListeners();
        break;
      }
    }
  }
}
