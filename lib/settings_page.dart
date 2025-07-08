import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/notes_app_home.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ScrollController scrollController = ScrollController();
  String appbarText = '';

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    log('build');
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => NotesAppHome()),
            );
          },
          icon: Icon(Icons.arrow_back),
        ),
        title: Text(appbarText),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          physics: ScrollPhysics(parent: BouncingScrollPhysics()),
          controller: scrollController,

          children: [
            ListTile(
              contentPadding: EdgeInsets.all(0),
              title: Text(
                'Notes',
                style: textStyleOS(
                  fontSize: 32,
                  fontColor: Colors.black,
                ).copyWith(fontWeight: FontWeight.w500),
              ),
            ),
            Gap(30),
            Text(
              'Cloud Service',
              style: textStyleOS(
                fontSize: 14,
                fontColor: Colors.grey.shade500,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
            ListTile(
              contentPadding: EdgeInsets.all(0),
              onTap: () {},
              leading: Text(
                'Cloud',
                style: textStyleOS(
                  fontSize: 18,
                  fontColor: Colors.black87,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Setup',
                    style: textStyleOS(
                      fontSize: 12,
                      fontColor: Colors.grey.shade700,
                    ).copyWith(fontWeight: FontWeight.w400),
                  ),
                  Gap(4),
                  Icon(HugeIcons.strokeRoundedArrowRight01, size: 15),
                ],
              ),
            ),
            Divider(thickness: 2, color: Colors.grey.shade300),
            Gap(10),
            Text(
              'Style',
              style: textStyleOS(
                fontSize: 14,
                fontColor: Colors.grey.shade500,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
            ListTile(
              contentPadding: EdgeInsets.all(0),
              onTap: () {},
              leading: Text(
                'Font Size',
                style: textStyleOS(
                  fontSize: 18,
                  fontColor: Colors.black87,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Mediuim',
                    style: textStyleOS(
                      fontSize: 12,
                      fontColor: Colors.grey.shade700,
                    ).copyWith(fontWeight: FontWeight.w400),
                  ),
                  Gap(4),
                  Icon(HugeIcons.strokeRoundedArrowRight01, size: 15),
                ],
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.all(0),
              onTap: () {},
              leading: Text(
                'Sort',
                style: textStyleOS(
                  fontSize: 18,
                  fontColor: Colors.black87,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'By modifiaction date',
                    style: textStyleOS(
                      fontSize: 12,
                      fontColor: Colors.grey.shade700,
                    ).copyWith(fontWeight: FontWeight.w400),
                  ),
                  Gap(4),
                  Icon(HugeIcons.strokeRoundedArrowRight01, size: 15),
                ],
              ),
            ),
            ListTile(
              contentPadding: EdgeInsets.all(0),
              onTap: () {},
              leading: Text(
                'Layout',
                style: textStyleOS(
                  fontSize: 18,
                  fontColor: Colors.black87,
                ).copyWith(fontWeight: FontWeight.w700),
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Grid View',
                    style: textStyleOS(
                      fontSize: 12,
                      fontColor: Colors.grey.shade700,
                    ).copyWith(fontWeight: FontWeight.w400),
                  ),
                  Gap(4),
                  Icon(HugeIcons.strokeRoundedArrowRight01, size: 15),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
