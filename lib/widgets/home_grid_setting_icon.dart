import 'package:Orbitly/core/constant.dart';
import 'package:Orbitly/providers/settings_pro.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

class HomeGridSettingIcon extends StatelessWidget {
  const HomeGridSettingIcon({super.key});

  @override
  Widget build(final BuildContext context) {
    final settingProvider = Provider.of<SettingsPro>(context);
    return AnimatedRotation(
      duration: const Duration(milliseconds: 500),
      turns: settingProvider.settings[layoutSetKey] == layoutListSetVal
          ? 0.5
          : 0,
      curve: Curves.linear,
      child: IconButton(
        key: ValueKey(settingProvider.settings[layoutSetKey]),
        onPressed: () async {
          settingProvider.settings[layoutSetKey] == layoutGridSetVal
              ? settingProvider.changeSettings(
                  settingKey: layoutSetKey,
                  settingValue: layoutListSetVal,
                )
              : settingProvider.changeSettings(
                  settingKey: layoutSetKey,
                  settingValue: layoutGridSetVal,
                );
        },
        icon: Icon(
          settingProvider.settings[layoutSetKey] == layoutListSetVal
              ? HugeIcons.strokeRoundedGridView
              : HugeIcons.strokeRoundedListView,
        ),
      ),
    );
  }
}
