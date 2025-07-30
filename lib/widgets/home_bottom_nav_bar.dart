
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/navbar_pro.dart';
import 'package:noted_d/providers/settings_pro.dart';
import 'package:noted_d/providers/task_pro.dart';

Widget bottomNavbar({
  required final NavbarPro navIndexPro,
  required final TaskPro taskPro,
  required final SettingsPro settingsprovider,
}) => BottomNavigationBar(
  backgroundColor: scaffoldBackgroudColor,
  currentIndex: navIndexPro.index,
  onTap: (final value) async {
    if (navIndexPro.index == 1 && value == 0) {

      await taskPro.saveCurrentTasks();
    }
    navIndexPro.changeIndex(value);
  },
  unselectedLabelStyle: textStyleOS(
    fontSize: settingsprovider.getFontSize() * 0.7,
    fontColor: Colors.grey.shade900,
  ),
  selectedIconTheme: const IconThemeData(size: 22, color: themeOrange),
  unselectedIconTheme: IconThemeData(size: 18, color: Colors.grey.shade900),
  selectedItemColor: themeOrange,
  unselectedItemColor: Colors.grey.shade700,
  unselectedFontSize: settingsprovider.getFontSize() * 0.90,

  selectedFontSize: settingsprovider.getFontSize(),
  selectedLabelStyle: textStyleOS(
    fontSize: settingsprovider.getFontSize(),
    fontColor: themeOrange,
  ),
  items: const [
    BottomNavigationBarItem(
      label: 'Notes',
      icon: Icon(HugeIcons.strokeRoundedFiles02),
    ),
    BottomNavigationBarItem(
      icon: Icon(HugeIcons.strokeRoundedCheckmarkSquare04),
      label: 'Tasks',
    ),
  ],
);
