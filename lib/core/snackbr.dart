import 'package:flutter/material.dart';
import 'package:noted_d/core/textstyle.dart';

cSnack({
  required String message,
  required Color backgroundColor,
  required BuildContext context,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar;

  ScaffoldMessenger.of(context).showSnackBar(
    snackBarAnimationStyle: AnimationStyle(
      curve: Curves.bounceInOut,
      duration: Duration(milliseconds: 1500),
    ),
    SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: Duration(seconds: 2),
      elevation: 50,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadiusGeometry.circular(14),
      ),
      backgroundColor: backgroundColor,
      content: Text(
        message,
        style: textStyleOS(fontSize: 15, fontColor: Colors.grey.shade700),
      ),
    ),
  );
}
