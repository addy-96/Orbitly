import 'package:flutter/material.dart';
import 'package:noted_d/core/textstyle.dart';

void cSnack({
  required final String message,
  required final Color backgroundColor,
  required final BuildContext context,
}) {
  ScaffoldMessenger.of(context).hideCurrentSnackBar;
  ScaffoldMessenger.of(context).showSnackBar(
    snackBarAnimationStyle: const AnimationStyle(
      curve: Curves.bounceInOut, 
      duration: Duration(milliseconds: 1500),
    ),
    SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(seconds: 2),
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
