import 'package:Orbitly/core/textstyle.dart';
import 'package:flutter/material.dart';

class FolderContainerFolderPage extends StatelessWidget {
  const FolderContainerFolderPage({super.key, required this.foldername});
  final String foldername;

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsetsGeometry.symmetric(vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          border: Border.all(width: 4, color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            foldername,
            style: textStyleOS(fontSize: 15, fontColor: Colors.black),
          ),
        ),
      ),
    );
  }
}
