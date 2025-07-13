import 'dart:developer';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/pages/notes_home_page.dart';
import 'package:noted_d/providers/settings_pro.dart' hide ListView;
import 'package:provider/provider.dart' as provider;
import 'package:sqflite/sqflite.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final ScrollController scrollController = ScrollController();


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
final settingsProvider = provider.Provider.of<SettingsPro>(context);
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
actions: [
          IconButton(
            onPressed: () async {
              final dbPath = await getDatabasesPath();
              final path = p.join(dbPath, 'notes.db');
              await deleteDatabase(path);
              log('deleted $path');
            },
            icon: Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: ScrollPhysics(parent: BouncingScrollPhysics()),
                controller: scrollController,
                children: [
                  ListTile(
                    contentPadding: EdgeInsets.all(0),
                    title: Text(
                      'Notes',
                      style: textStyleOS(
                        fontSize: 2 * settingsProvider.getFontSize(),
                        fontColor: Colors.black,
                      ).copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Gap(30),
                  Text(
                    'Cloud Services',
                    style: textStyleOS(
                      fontSize: settingsProvider.getFontSize(),
                      fontColor: Colors.grey.shade500,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                  ListTile(
                    onTap: () {
                      showOptionSheet(
                        options: ['Setup', 'Reset'],
                        topic: 'Cloud',
                      );
                    },
                    leading: Text(
                      'Cloud',
                      style: textStyleOS(
                        fontSize: settingsProvider.getFontSize() + 8,
                        fontColor: Colors.black87,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        provider.Consumer<SettingsPro>(
                          builder: (context, value, child) {
                            final settingValue =
                                value.settings['cloud-set'] ?? '';
                            return Text(
                              settingValue,
                              style: textStyleOS(
                                fontSize: settingsProvider.getFontSize(),
                                fontColor: Colors.grey.shade700,
                              ).copyWith(fontWeight: FontWeight.w400),
                            );
                          },
                        ),
                        Gap(4),
                        Icon(HugeIcons.strokeRoundedArrowRight01, size: 15),
                      ],
                    ),
                  ),
                  Divider(thickness: 2, color: Colors.grey.shade300),
                  Text(
                    'Style',
                    style: textStyleOS(
                      fontSize: settingsProvider.getFontSize(),
                      fontColor: Colors.grey.shade500,
                    ).copyWith(fontWeight: FontWeight.w600),
                  ),
                  ListTile(
                    onTap: () {
                      showOptionSheet(
                        options: ['Small', 'Medium', 'Large'],
                        topic: 'Font Size',
                      );
                    },
                    leading: Text(
                      'Font Size',
                      style: textStyleOS(
                        fontSize: settingsProvider.getFontSize() + 8,
                        fontColor: Colors.black87,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        provider.Consumer<SettingsPro>(
                          builder: (context, value, child) {
                            final settingValue =
                                value.settings['font-size-set'] ?? '';
                            return Text(
                              settingValue,
                              style: textStyleOS(
                                fontSize: settingsProvider.getFontSize(),
                                fontColor: Colors.grey.shade700,
                              ).copyWith(fontWeight: FontWeight.w400),
                            );
                          },
                        ),
                        Gap(4),
                        Icon(HugeIcons.strokeRoundedArrowRight01, size: 15),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      showOptionSheet(
                        options: ['Grid view', 'List view'],
                        topic: 'Layout',
                      );
                    },
                    leading: Text(
                      'Layout',
                      style: textStyleOS(
                        fontSize: settingsProvider.getFontSize() + 8,
                        fontColor: Colors.black87,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        provider.Consumer<SettingsPro>(
                          builder: (context, value, child) {
                            final settingValue =
                                value.settings['layout-set'] ?? '';
                            return Text(
                              '$settingValue view',
                              style: textStyleOS(
                                fontSize: settingsProvider.getFontSize(),
                                fontColor: Colors.grey.shade700,
                              ).copyWith(fontWeight: FontWeight.w400),
                            );
                          },
                        ),
                        Gap(4),
                        Icon(HugeIcons.strokeRoundedArrowRight01, size: 15),
                      ],
                    ),
                  ),
                  ListTile(
                    onTap: () {
                      showOptionSheet(
                        options: ['By modification date', 'Oldest first'],
                        topic: 'Sort by',
                      );
                    },
                    leading: Text(
                      'Sort by',
                      style: textStyleOS(
                        fontSize: settingsProvider.getFontSize() + 8,
                        fontColor: Colors.black87,
                      ).copyWith(fontWeight: FontWeight.w700),
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        provider.Consumer<SettingsPro>(
                          builder: (context, value, child) {
                            var settingValue = value.settings['sort-set'] ?? '';
                            settingValue = settingValue == 'BMD'
                                ? 'By modification date'
                                : 'Oldest first';
                            return Text(
                              settingValue,
                              style: textStyleOS(
                                fontSize: settingsProvider.getFontSize(),
                                fontColor: Colors.grey.shade700,
                              ).copyWith(fontWeight: FontWeight.w400),
                            );
                          },
                        ),
                        Gap(4),
                        Icon(HugeIcons.strokeRoundedArrowRight01, size: 15),
                      ],
                    ),
                  ),
                  Gap(10),
                
                ],
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(18),
                    splashColor: Colors.deepOrange.withOpacity(0.1),
                    onTap: () async {
                      await settingsProvider.resetSettings();
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
                            fontSize: 18,
                            fontColor: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap(20),
                  InkWell(
                    borderRadius: BorderRadius.circular(18),
                    splashColor: Colors.deepOrange.withOpacity(0.1),
                    onTap: () {},
                    child: Container(
                      height: MediaQuery.of(context).size.height / 19,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(width: 2, color: Colors.deepOrange),
                      ),
                      child: Center(
                        child: Text(
                          'Delete all notes!',
                          style: textStyleOS(
                            fontSize: 18,
                            fontColor: Colors.deepOrange,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Gap(30),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }


showOptionSheet({required List<String> options, required String topic}) {
    String selectedOptionValue = '';
    final settingsProvider = provider.Provider.of<SettingsPro>(
      context,
      listen: false,
    );
    String settingKey = '';
    if (topic == 'Cloud') {
      settingKey = 'cloud-set';
      selectedOptionValue = settingsProvider.settings[settingKey]!;
    } else if (topic == 'Font Size') {
      settingKey = 'font-size-set';
      selectedOptionValue = settingsProvider.settings[settingKey]!;
    } else if (topic == 'Layout') {
      settingKey = 'layout-set';
      selectedOptionValue = '${settingsProvider.settings[settingKey]!} view';
    } else if (topic == 'Sort by') {
      settingKey = 'sort-set';
      selectedOptionValue = settingsProvider.settings[settingKey]!;
      selectedOptionValue = selectedOptionValue == 'BMD'
          ? 'By modification date'
          : 'Oldest first';
    }

    showModalBottomSheet(
      elevation: 50,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) {
        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(width: 5, color: Colors.grey.shade200),
          ),
          height: options.length * 100,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 10),
                  Text(
                    topic,
                    style: textStyleOS(
                      fontSize: 20,
                      fontColor: Colors.black,
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: Icon(HugeIcons.strokeRoundedMultiplicationSign),
                  ),
                ],
              ),
              SettingsOptions(
                settingOptions: options,
                selectedOption: selectedOptionValue,
                settingkey: settingKey,
              ),
            ],
          ),
        );
      },
    );
  }
}

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
  Widget build(BuildContext context) {
    final settingsProvider = provider.Provider.of<SettingsPro>(context);
    return Column(
      children: [
        for (var item in widget.settingOptions)
          ListTile(
            onTap: () {
              if (item == widget.selectedOption) {
                log('is from before');
              } else {
                if (widget.settingkey == 'cloud-set' ||
                    widget.settingkey == 'font-size-set') {
                  settingsProvider.changeSettings(
                    settingKey: widget.settingkey,
                    settingValue: item,
                  );
                } else if (widget.settingkey == 'layout-set') {
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
                } else if (widget.settingkey == 'sort-set') {
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
                fontSize: 15,
                fontColor: item == widget.selectedOption
                    ? Colors.deepOrange
                    : Colors.black,
              ),
            ),
          ),
      ],
    );
  }
}
