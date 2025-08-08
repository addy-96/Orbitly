import 'package:Orbitly/core/constant.dart';
import 'package:Orbitly/core/textstyle.dart';
import 'package:Orbitly/providers/settings_pro.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsOptions extends StatefulWidget {
  SettingsOptions({
    super.key,
    required this.settingOptions,
    required this.selectedOption,
    required this.settingkey,
  });
  final List<String> settingOptions;
  String selectedOption;
  final String settingkey;

  @override
  State<SettingsOptions> createState() => _SettingsOptionsState();
}

class _SettingsOptionsState extends State<SettingsOptions> {
  @override
  Widget build(final BuildContext context) {
    final settingsProvider = Provider.of<SettingsPro>(context);
    return Column(
      children: [
        for (var item in widget.settingOptions)
          ListTile(
            onTap: () {
              if (item == widget.selectedOption) {
              } else {
                if (widget.settingkey == themeSetKey ||
                    widget.settingkey == fontSizeSetKey) {
                  settingsProvider.changeSettings(
                    settingKey: widget.settingkey,
                    settingValue: item,
                  );
                } else if (widget.settingkey == layoutSetKey) {
                  if (item == 'Grid view') {
                    settingsProvider.changeSettings(
                      settingKey: widget.settingkey,
                      settingValue: 'Grid',
                    );
                  } else {
                    settingsProvider.changeSettings(
                      settingKey: widget.settingkey,
                      settingValue: 'List',
                    );
                  }
                } else if (widget.settingkey == sortSetKey) {
                  if (item == 'By modification date') {
                    settingsProvider.changeSettings(
                      settingKey: widget.settingkey,
                      settingValue: 'BMD',
                    );
                  } else {
                    settingsProvider.changeSettings(
                      settingKey: widget.settingkey,
                      settingValue: 'OF',
                    );
                  }
                }
                setState(() {
                  widget.selectedOption = item;
                });
              }
            },
            title: Text(
              item,
              style: textStyleOS(
                fontSize: settingsProvider.getFontSize() * 1.2,
                fontColor: item == widget.selectedOption
                    ? themeOrange
                    : Colors.black,
              ),
            ),
          ),
      ],
    );
  }
}
