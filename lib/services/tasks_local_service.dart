import 'dart:developer';
import 'package:path/path.dart' as p;
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/models/task_model.dart';
import 'package:sqflite/sqflite.dart';

abstract interface class TasksLocalServiceInterface {
  Future<List<TaskModel>> loadAllTasks();

  Future updateTaskCheckBox({
    required final int isComplete,
    required final String taskId,
  });

  Future updateTaskTable({required final List<TaskModel> currentTaskList});
}

final class TasksLocalServiceInterfaceImpl
    implements TasksLocalServiceInterface {
  Future<Database> createDatabase() async {
    try {
      final dbPath = await getDatabasesPath();

      final path = p.join(dbPath, 'notes.db');

      final database = await openDatabase(
        path,
        version: 1,
        onCreate: (final db, final version) async {
          log('task database created!');
        },
      );
      return database;
    } catch (err) {
      log(err.toString());
      throw Exception(err.toString());
    }
  }

  @override
  Future<List<TaskModel>> loadAllTasks() async {
    try {
      final List<TaskModel> taskModelList = [];

      final db = await createDatabase();

      final getTasks = await db.query(taskTable);
      log(getTasks.toString());
      for (var task in getTasks) {
        final TaskModel taskModel = TaskModel(
          taskId: task[taskIdTTC] as String,
          taskName: task[taskContentTTC] as String,
          isComplete: task[completeStatusTTC] as int,
        );
        taskModelList.add(taskModel);
      }
      log('inside task local service : ${taskModelList.length.toString()}');
      return taskModelList;
    } catch (err) {
      log(err.toString());
      throw Exception(err);
    }
  }

  @override
  Future updateTaskTable({
    required final List<TaskModel> currentTaskList,
  }) async {
    try {
      final db = await createDatabase();
      final currentDatabaseTasks = await db.query(taskTable);

      for (var item in currentDatabaseTasks) {
        await db.delete(
          taskTable,
          where: '$taskIdTTC = ?',
          whereArgs: [item[taskIdTTC]],
        );
      }
      for (var item in currentTaskList) {
        await db.insert(taskTable, {
          taskIdTTC: item.taskId,
          taskContentTTC: item.taskName,
          completeStatusTTC: item.isComplete,
        });
      }
    } catch (err) {
      log(err.toString());
      throw Exception(err.toString());
    }
  }

  @override
  Future updateTaskCheckBox({
    required final int isComplete,
    required final String taskId,
  }) async {
    try {
      final db = await createDatabase();
      await db.update(
        taskTable,
        {completeStatusTTC: isComplete},
        where: '$taskIdTTC = ?',
        whereArgs: [taskId],
      );
    } catch (err) {
      log(err.toString());
      throw Exception(err.toString());
    }
  }
}
