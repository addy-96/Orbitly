import 'dart:developer';

import 'package:noted_d/core/constant.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

int? getTaskCompleteStatus({required String task}) {
  if (task.length < 3) {
    return null;
  }
  final endString = task.substring(task.length - 2, task.length - 1);

  return int.parse(endString);
}

void displayNotesTable() async {
  final res = await getDatabasesPath();
  final dbPath = p.join(res, 'notes.db');
  final db = await openDatabase(dbPath);

  final response = await db.query(notesTable);
  for (var item in response) {
    log(item.toString());
  }
}

void displaySectionTable() async {
  final res = await getDatabasesPath();
  final dbPath = p.join(res, 'notes.db');
  final db = await openDatabase(dbPath);

  final response = await db.query(sectionTable);

  for (var item in response) {
    log(item.toString());
  }
}

void displayTasktable() async {
  final res = await getDatabasesPath();
  final dbPath = p.join(res, 'notes.db');
  final db = await openDatabase(dbPath);

  final resposne = await db.query(taskTable);
  for (var item in resposne) {
    log(item.toString());
  }
}

debugprint() => print(
  '\n(----------------------------------debugPrint---------------------------------)\n',
);
