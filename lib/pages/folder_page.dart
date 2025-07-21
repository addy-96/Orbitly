import 'package:flutter/material.dart';
import 'package:noted_d/core/textstyle.dart';

class FolderPage extends StatelessWidget {
  const FolderPage({super.key});

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Folders',
          style: textStyleOS(
            fontSize: 22,
            fontColor: Colors.black,
          ).copyWith(fontWeight: FontWeight.w400),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
        child: ListView(
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(8),
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(width: 3, color: Colors.grey.shade300),
                ),
                padding: const EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    'Make a folder',
                    style: textStyleOS(
                      fontSize: 18,
                      fontColor: Colors.deepOrange,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
