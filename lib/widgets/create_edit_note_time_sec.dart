import 'package:flutter/material.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/providers/settings_pro.dart';
import 'package:provider/provider.dart';

class CreateEditNoteTimeSec extends StatelessWidget {
  const CreateEditNoteTimeSec({super.key, required this.isEditPage});
  final bool isEditPage;

  String formatDateTime(final DateTime dateTime) {
    final hour = dateTime.hour > 12
        ? dateTime.hour - 12
        : dateTime.hour == 0
        ? 12
        : dateTime.hour;
    final minute = dateTime.minute < 10
        ? '0${dateTime.minute}'
        : '${dateTime.minute}';
    final period = dateTime.hour >= 12 ? 'PM' : 'AM';
    final monthName = '${months[dateTime.month]!.substring(0, 3)},';
    return '${dateTime.day} $monthName $hour:$minute  $period';
  }

  @override
  Widget build(final BuildContext context) {
    final settingspro = Provider.of<SettingsPro>(context);
    final notesPro = Provider.of<NotesPro>(context);
    final createdAt = notesPro.createdAt;
    final editedAt = notesPro.editedAt;

    if (isEditPage && createdAt != null && editedAt != null) {
      return Column(
        children: [
          Text(
            'Created: ${formatDateTime(createdAt)}\nLast Edited: ${formatDateTime(editedAt)}',
            style: textStyleOS(
              fontSize: settingspro.getFontSize(),
              fontColor: notesPro.currentNoteBackground == 'default'
                  ? Colors.grey.shade400
                  : Colors.white,
            ).copyWith(fontWeight: FontWeight.w400),
          ),
        ],
      );
    } else {
      final now = DateTime.now();
      return Text(
        formatDateTime(now),
        style: textStyleOS(
          fontSize: settingspro.getFontSize(),
          fontColor: notesPro.currentNoteBackground == 'default'
              ? Colors.grey.shade400
              : Colors.white,
        ).copyWith(fontWeight: FontWeight.w400),
      );
    }
  }
}
