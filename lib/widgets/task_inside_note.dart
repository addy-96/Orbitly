import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/textstyle.dart';

class TaskInsideNote extends StatelessWidget {
  const TaskInsideNote({super.key, required this.textController});

  final TextEditingController textController;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Gap(MediaQuery.of(context).size.width / 15),
          IconButton(
            onPressed: () {},
            icon: Icon(HugeIcons.strokeRoundedSquare, size: 18),
          ),
          Gap(10),
          Expanded(
            child: TextField(
              autofocus: true,
              style: textStyleOS(fontSize: 15, fontColor: Colors.black),
              controller: textController,
              decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey.shade400, width: 2),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(HugeIcons.strokeRoundedMultiplicationSign, size: 10),
          ),
          Gap(MediaQuery.of(context).size.width / 15),
        ],
      ),
    );
  }
}
