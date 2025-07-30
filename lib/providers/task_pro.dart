import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:noted_d/models/task_model.dart';
import 'package:noted_d/services/tasks_local_service.dart';

class TaskPro with ChangeNotifier {
  TaskPro({required this.tasksLocalServiceInterface});

  final TasksLocalServiceInterface tasksLocalServiceInterface;
  List<TaskModel> _tasksList = [];

  List<TaskModel> get taskList => _tasksList;

  @override
  void dispose() {
    for (var task in _tasksList) {
      task.taskController.dispose();
    }
    super.dispose();
  }

  void onAddTask() async {
    if (_tasksList.isEmpty) {
      _tasksList.add(
        TaskModel(isComplete: 0, taskController: TextEditingController()),
      );
      notifyListeners();
    }
    if (_tasksList.isNotEmpty) {
      if (_tasksList.last.taskController.text.trim().isNotEmpty) {
        _tasksList.add(
          TaskModel(isComplete: 0, taskController: TextEditingController()),
        );
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
    if (getalltasks.isEmpty) {
      return;
    }
    _tasksList = getalltasks;
    notifyListeners();
  }

  Future saveCurrentTasks() async {
    if (_tasksList.isEmpty) {
      return;
    }
    
    await tasksLocalServiceInterface.updateTaskTable(
      currentTaskList: _tasksList,
    );
 
  }

  Future updateTaskStatus({
    required final String taskid,
    required final int iscomplete,
  }) async {
    await tasksLocalServiceInterface.updateTaskCheckBox(
      isComplete: iscomplete,
      taskId: taskid,
    );
    for (var tasks in _tasksList) {
      if (tasks.taskId == taskid) {
        tasks.isComplete = iscomplete;
        notifyListeners();
        break;
      }
    }
  }
}
