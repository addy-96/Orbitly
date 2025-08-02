import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:provider/provider.dart';

class NotesBackgroundImageOption extends StatelessWidget {
  const NotesBackgroundImageOption({super.key});

  @override
  Widget build(final BuildContext context) {
    final notesPro = Provider.of<NotesPro>(context);
    return SizedBox(
      height: MediaQuery.of(context).size.height / 5,
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(14),
            onTap: () {
              notesPro.toggleAvatarBackgroundMenu();
            },
            child: Material(
              borderRadius: BorderRadius.circular(50),
              elevation: 5,
              child: const CircleAvatar(
                backgroundColor: themeOrange,
                radius: 15,
                child: Icon(
                  HugeIcons.strokeRoundedMultiplicationSign,
                  size: 15,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const Gap(10),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (final context, final index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () {
                      notesPro.setNoteBackground(
                        path: 'assets/avatar/av$index.png',
                      );
                    },
                    child: Material(
                      borderRadius: BorderRadius.circular(18),
                      elevation: 5,
                      child: Container(
                        height: 30,
                        width: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadiusGeometry.circular(14),
                          child: Image.asset(
                            'assets/avatar/av$index.png',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
