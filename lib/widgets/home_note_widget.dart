import 'package:flutter/material.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/edit_notes.dart';
import 'package:noted_d/models/notes_model.dart';

class HomeNoteWidget extends StatelessWidget {
  const HomeNoteWidget({super.key, required this.notesModel});
  final NotesModel notesModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(19),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditNotes(notesModel: notesModel),
            ),
          );
        },
        child: Hero(
          tag: notesModel.notesId,
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            height: double.minPositive,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(19),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                notesModel.notesTitle != null
                    ? Text(
                        notesModel.notesTitle!,
                        style: textStyleOS(
                          fontSize: 18,
                          fontColor: Colors.black,
                        ).copyWith(fontWeight: FontWeight.w600),
                      )
                    : SizedBox.shrink(),
                notesModel.notesContent != null
                    ? Text(
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        notesModel.notesContent!,
                        style: textStyleOS(
                          fontSize: 15,
                          fontColor: Colors.grey.shade500,
                        ).copyWith(fontWeight: FontWeight.w400),
                      )
                    : SizedBox.shrink(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
