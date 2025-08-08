import 'package:Orbitly/core/constant.dart';
import 'package:Orbitly/core/snackbar.dart';
import 'package:Orbitly/core/textstyle.dart';
import 'package:Orbitly/providers/settings_pro.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsBottomOptions extends StatelessWidget {
  const SettingsBottomOptions({super.key});

  Future<void> _launchEmail(final BuildContext context) async {
    final Uri emalUri = Uri(
      scheme: 'mailto',
      path: 'adisin009@gmail.com',
      query: 'Write your feedback here',
    );

    if (!await launchUrl(emalUri)) {
      cSnack(
        message: 'Unable to launch Email!',
        backgroundColor: Colors.white,
        context: context,
      );
    }
  }

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
                style: textStyleOS(
                  fontSize: settingProvider.getFontSize() * 1.4,
                  fontColor: themeOrange,
                ),
              ),
            ),
          ),
        ),
        const Gap(10),
        InkWell(
          borderRadius: BorderRadius.circular(18),
          splashColor: Colors.deepOrange.withOpacity(0.1),
          onTap: () async {
            _launchEmail(context);
          },
          child: Container(
            height: MediaQuery.of(context).size.height / 19,
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              color: themeOrange,
            ),
            child: Center(
              child: Text(
                'Send Feedback!',
                style: textStyleOS(
                  fontSize: settingProvider.getFontSize() * 1.4,
                  fontColor: Colors.white,
                ),
              ),
            ),
          ),
        ),
        const Gap(10),
      ],
    );
  }
}
