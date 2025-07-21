import 'package:flutter/material.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/textstyle.dart';

class CreateEditNoteTimeSec extends StatelessWidget {
  const CreateEditNoteTimeSec({super.key});

  @override
  Widget build(final BuildContext context) {
    return Text(
      '${getDateTime().day} ${months[getDateTime().month]} ${getDateTime().hour > 12 ? getDateTime().hour - 12 : getDateTime().hour}:${getDateTime().minute < 10 ? '0${getDateTime().minute}' : getDateTime().minute}  ${getDateTime().hour >= 12 && getDateTime().hour <= 24 ? 'PM' : 'AM'} |  Characters',
      style: textStyleOS(
        fontSize: 14,
        fontColor: Colors.grey.shade400,
      ).copyWith(fontWeight: FontWeight.w400),
    );
  }
}
