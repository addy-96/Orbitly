import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/settings_pro.dart';
import 'package:provider/provider.dart';

class SettingsBottomOptions extends StatelessWidget {
  const SettingsBottomOptions({super.key});

  @override
  Widget build(final BuildContext context) {
    final SettingsPro settingProvider = Provider.of<SettingsPro>(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        InkWell(
          borderRadius: BorderRadius.circular(18),
          splashColor: Colors.deepOrange.withOpacity(0.1),
          onTap: () async {
            await settingProvider.resetSettings();
          },
          child: Container(
            height: MediaQuery.of(context).size.height / 19,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(width: 2, color: Colors.deepOrange),
            ),
            child: Center(
              child: Text(
                'Reset Settings',
                style: textStyleOS(fontSize: 18, fontColor: Colors.deepOrange),
              ),
            ),
          ),
        ),
        const Gap(20),
        InkWell(
          borderRadius: BorderRadius.circular(18),
          splashColor: Colors.deepOrange.withOpacity(0.1),
          onTap: () {},
          child: Container(
            height: MediaQuery.of(context).size.height / 19,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              border: Border.all(width: 2, color: Colors.deepOrange),
            ),
            child: Center(
              child: Text(
                'Delete all notes!',
                style: textStyleOS(fontSize: 18, fontColor: Colors.deepOrange),
              ),
            ),
          ),
        ),
        const Gap(30),
      ],
    );
  }
}
