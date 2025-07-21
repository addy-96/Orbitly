import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/providers/navbar_pro.dart';
import 'package:noted_d/providers/task_pro.dart';

Widget homefloatingActionButton({
  required final BuildContext context,
  required final NavbarPro navIndexPro,
  required final TaskPro taskPro,
}) => FloatingActionButton(
  onPressed: () async {
    if (navIndexPro.index == 0) {
      context.push('/create_notes');
    } else {
      taskPro.onAddTask();
    }
  },
  backgroundColor: Colors.deepOrange,
  shape: const CircleBorder(),
  child: const Icon(HugeIcons.strokeRoundedAdd02, color: Colors.white),
);
