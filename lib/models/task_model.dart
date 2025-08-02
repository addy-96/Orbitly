import 'package:flutter/widgets.dart';
import 'package:uuid/uuid.dart';

class TaskModel {
  TaskModel({
    final String? taskId,
    required this.taskController,
    required this.isComplete,
    required this.completedAt,
    required this.createdAt,
  }) : taskId = taskId ?? const Uuid().v4();

  final String? taskId;
  int isComplete;
  final DateTime createdAt;
  DateTime? completedAt;
  final TextEditingController taskController;
}
