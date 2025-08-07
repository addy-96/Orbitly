import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/models/notes_model.dart';
import 'package:noted_d/providers/settings_pro.dart';
import 'package:provider/provider.dart';

class HomeNoteGridBox extends StatelessWidget {
  const HomeNoteGridBox({
    super.key,
    required this.homeNotesModel,
    required this.isSearchedResult,
  });
  final HomeNotesModel homeNotesModel;
  final bool isSearchedResult;

  @override
  Widget build(final BuildContext context) {
    final settingProvider = Provider.of<SettingsPro>(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        borderRadius: BorderRadius.circular(19),
        onTap: () async {
          context.push('/edit_notes/${homeNotesModel.notesId}');
        },
        child: Hero(
          tag: homeNotesModel.notesId,
          child: Material(
            elevation: 2,
            borderRadius: BorderRadius.circular(19),
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  homeNotesModel.notesTitle != null
                      ? Center(
                          child: Text(
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            homeNotesModel.notesTitle!,
                            style: textStyleOS(
                              fontSize: settingProvider.getFontSize() * 1.2,
                              fontColor: Colors.black,
                            ).copyWith(fontWeight: FontWeight.w600),
                          ),
                        )
                      : const SizedBox.shrink(),
                  homeNotesModel.notesContentHighlight.isNotEmpty
                      ? Center(
                          child: !isSearchedResult
                              ? Text(
                                  maxLines: 4,
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                  homeNotesModel.notesContentHighlight,
                                  style: textStyleOS(
                                    fontSize: settingProvider.getFontSize(),
                                    fontColor: Colors.grey.shade500,
                                  ).copyWith(fontWeight: FontWeight.w400),
                                )
                              : const SizedBox.shrink(),
                        )
                      : const SizedBox.shrink(),
                  settingProvider.settings[layoutSetKey] == 'Grid'
                      ? Expanded(
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Text(
                              '${homeNotesModel.createdAt.day}/${homeNotesModel.createdAt.month}/${homeNotesModel.createdAt.year}',
                              style: textStyleOS(
                                fontSize: settingProvider.getFontSize() * 0.8,
                                fontColor: Colors.grey.shade500,
                              ).copyWith(fontWeight: FontWeight.w400),
                            ),
                          ),
                        )
                      : Align(
                          alignment: Alignment.bottomRight,
                          child: Text(
                            '${homeNotesModel.createdAt.day}/${homeNotesModel.createdAt.month}/${homeNotesModel.createdAt.year}',
                            style: textStyleOS(
                              fontSize: settingProvider.getFontSize() * 0.8,
                              fontColor: Colors.grey.shade500,
                            ).copyWith(fontWeight: FontWeight.w400),
                          ),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
