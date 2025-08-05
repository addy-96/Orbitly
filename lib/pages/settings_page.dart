import 'dart:developer';
import 'dart:io';
import 'package:go_router/go_router.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/widgets/settings_bottom_options.dart';
import 'package:noted_d/widgets/settings_options.dart';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/settings_pro.dart' hide ListView;
import 'package:path_provider/path_provider.dart';
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
  Widget build(final BuildContext context) {
    final settingsProvider = provider.Provider.of<SettingsPro>(context);
    return Scaffold(
      backgroundColor: scaffoldBackgroudColor,
      appBar: AppBar(
        forceMaterialTransparency: true,
        leading: IconButton(
          onPressed: () {
            context.pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              final docsDirectory = await getApplicationDocumentsDirectory();
              if (docsDirectory.existsSync()) {
                for (var item in docsDirectory.listSync()) {
                  if (item.path ==
                      '/data/user/0/com.example.noted_d/app_flutter/flutter_assets') {
                    continue;
                  }
                  final file = File(item.path);
                  await file.delete();
                }
                log('appicaltion directory cleared');
              }
            },
            icon: const Icon(Icons.delete_outline),
          ),
          IconButton(
            onPressed: () async {
              final dbPath = await getDatabasesPath();
              final path = p.join(dbPath, 'notes.db');
              await deleteDatabase(path);
              log('deleted $path');
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                physics: const ScrollPhysics(parent: BouncingScrollPhysics()),
                controller: scrollController,
                children: [
                  ListTile(
                    contentPadding: const EdgeInsets.all(0),
                    title: Text(
                      'Notes',
                      style: textStyleOS(
                        fontSize: 2 * settingsProvider.getFontSize(),
                        fontColor: Colors.black,
                      ).copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  const Gap(30),
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
                          builder: (final context, final value, final child) {
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
                        const Gap(4),
                        const Icon(
                          HugeIcons.strokeRoundedArrowRight01,
                          size: 15,
                        ),
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
                          builder: (final context, final value, final child) {
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
                        const Gap(4),
                        const Icon(
                          HugeIcons.strokeRoundedArrowRight01,
                          size: 15,
                        ),
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
                          builder: (final context, final value, final child) {
                            final settingValue =
                                value.settings[layoutSetKey] ?? '';
                            return Text(
                              '$settingValue view',
                              style: textStyleOS(
                                fontSize: settingsProvider.getFontSize(),
                                fontColor: Colors.grey.shade700,
                              ).copyWith(fontWeight: FontWeight.w400),
                            );
                          },
                        ),
                        const Gap(4),
                        const Icon(
                          HugeIcons.strokeRoundedArrowRight01,
                          size: 15,
                        ),
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
                          builder: (final context, final value, final child) {
                            var settingValue =
                                value.settings[sortBMDSetVal] ?? '';
                            settingValue = settingValue == sortBMDSetVal
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
                        const Gap(4),
                        const Icon(
                          HugeIcons.strokeRoundedArrowRight01,
                          size: 15,
                        ),
                      ],
                    ),
                  ),
                  const Gap(10),
                ],
              ),
            ),
            const SettingsBottomOptions(),
          ],
        ),
      ),
    );
  }

  void showOptionSheet({
    required final List<String> options,
    required final String topic,
  }) {
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
      builder: (final context) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            border: Border.all(width: 5, color: Colors.grey.shade200),
          ),
          height: options.length * 100,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(width: 10),
                  Text(
                    topic,
                    style: textStyleOS(
                      fontSize: settingsProvider.getFontSize() + 8,
                      fontColor: Colors.black,
                    ).copyWith(fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(HugeIcons.strokeRoundedMultiplicationSign),
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
