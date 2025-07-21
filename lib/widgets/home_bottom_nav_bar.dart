import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/navbar_pro.dart';

Widget bottomNavbar({
  required final NavbarPro navIndexPro,
}) => BottomNavigationBar(
  backgroundColor: scaffoldBackgroudColor,
  currentIndex: navIndexPro.index,
  onTap: (final value) async {
    navIndexPro.changeIndex(value);
    if (navIndexPro.index == 1 && value == 0) {
      //to save current tasks
    }
  },
  unselectedLabelStyle: textStyleOS(
    fontSize: 8,
    fontColor: Colors.grey.shade900,
  ),
  selectedIconTheme: const IconThemeData(size: 22, color: Colors.deepOrange),
  unselectedIconTheme: IconThemeData(size: 18, color: Colors.grey.shade900),
  selectedItemColor: Colors.deepOrange,
  unselectedItemColor: Colors.grey.shade700,
  unselectedFontSize: 11,

  selectedFontSize: 12,
  selectedLabelStyle: textStyleOS(fontSize: 12, fontColor: Colors.deepOrange),
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
