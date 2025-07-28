import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

class TaskModel {
  TaskModel({
    final String? taskId,
    required this.taskName,
    required this.isComplete,
  }) : taskId = taskId ?? const Uuid().v4();

  String? taskId;
  int isComplete;
  String taskName;
}

class DisplayTaskModel extends TaskModel {
  DisplayTaskModel({
    super.taskId,
    required super.taskName,
    required super.isComplete,
  }) : textEditingController = TextEditingController(text: taskName);

  final TextEditingController textEditingController;
}
