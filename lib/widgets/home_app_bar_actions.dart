import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/constant.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart' as p;

class HomeAppBarActions extends StatelessWidget {
  const HomeAppBarActions({super.key});

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () async {
              final path = await getDatabasesPath();
              final dbPath = p.join(path, 'notes.db');
              final db = await openDatabase(dbPath);
              final response = await db.query(drawingTable);
              log(response.toString());
              // context.push('/folder');
            },
            icon: const Icon(HugeIcons.strokeRoundedFolder01),
          ),
          IconButton(
            onPressed: () async {
              context.push('/setting');
            },
            icon: const Icon(HugeIcons.strokeRoundedSettings03),
          ),
        ],
      ),
    );
  }
}
