import 'package:flutter/material.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/edit_notes.dart';
import 'package:noted_d/models/notes_model.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/services%20/notes_local_service.dart';
import 'package:provider/provider.dart';

class HomeNoteWidget extends StatelessWidget {
  const HomeNoteWidget({super.key, required this.homeNotesModel});
  final HomeNotesModel homeNotesModel;

  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesPro>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(19),
        onTap: () async {
          final res = await notesProvider.editNote(
            homeNotesModel: homeNotesModel,
          );
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => EditNotes(notesModel: res),
            ),
          ); 

        },
        child: Hero(
          tag: homeNotesModel.notesId,
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
                homeNotesModel.notesTitle != null
                    ? Text(
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        homeNotesModel.notesTitle!,
                        style: textStyleOS(
                          fontSize: 18,
                          fontColor: Colors.black,
                        ).copyWith(fontWeight: FontWeight.w600),
                      )
                    : SizedBox.shrink(),
                homeNotesModel.notesContentHighlight != null
                    ? Text(
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                        'asdf',
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
