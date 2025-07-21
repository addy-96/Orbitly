import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:provider/provider.dart';

class TaskInsideNote extends StatefulWidget {
  const TaskInsideNote({
    super.key,
    required this.textController,
    required this.index,
  });
  final TextEditingController textController;
  final int index;

  @override
  State<TaskInsideNote> createState() => _TaskInsideNoteState();
}

class _TaskInsideNoteState extends State<TaskInsideNote> {
  late FocusNode taskFocusNode;

  @override
  void initState() {
    super.initState();
    taskFocusNode = FocusNode();
    taskFocusNode.addListener(() {
      setState(() {}); // Rebuild on focus change
    });
  }



  @override
  Widget build(final BuildContext context) {
    final notesSectionProvider = Provider.of<NotesPro>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Gap(MediaQuery.of(context).size.width / 30),
          IconButton(
            onPressed: () {},
            icon: const Icon(HugeIcons.strokeRoundedSquare, size: 18),
          ),
          const Gap(10),
          Expanded(
            child: TextField(
              focusNode: taskFocusNode,
              style: textStyleOS(fontSize: 15, fontColor: Colors.black),
              controller: widget.textController,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                ),
              ),
            ),
          ),
          taskFocusNode.hasFocus
              ? IconButton(
                  onPressed: () {
                    notesSectionProvider.removeImageOrTask(index: widget.index);
                  },
                  icon: const Icon(
                    HugeIcons.strokeRoundedMultiplicationSign,
                    size: 10,
                  ),
                )
              : const SizedBox.shrink(),
          Gap(MediaQuery.of(context).size.width / 30),
        ],
      ),
    );
  }
}
