import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/search_box_pro.dart';
import 'package:noted_d/providers/settings_pro.dart';

import 'package:provider/provider.dart';

class HomeScreenSearchbox extends StatelessWidget {
  const HomeScreenSearchbox({super.key, required this.isWithInputField});
  final bool isWithInputField;

  void _onChanged(final SearchBoxPro searchBoxProvider) {
    final searchValue = searchBoxProvider.searchController.text.trim();
    if (searchValue.isEmpty) {
      return;
    }
    searchBoxProvider.clearSearchedNotes();
    searchBoxProvider.onSearch(searchedString: searchValue);
  }

  void _onCancel(final SearchBoxPro searchBoxProvider) {
    searchBoxProvider.searchController.clear();
    searchBoxProvider.clearSearchedNotes();
    searchBoxProvider.toggelSearchBox();
  }

  @override
  Widget build(final BuildContext context) {
    final searchBoxProvider = Provider.of<SearchBoxPro>(context);
    final settingsProvider = Provider.of<SettingsPro>(context);
    final fontSize = settingsProvider.getFontSize();
    log('build outside');
    if (isWithInputField) {
      return Row(
        children: [
          Expanded(
            child: Material(
              borderRadius: BorderRadius.circular(50),
              child: Container(
                decoration: BoxDecoration(
                  color: grey,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: TextField(
                    style: textStyleOS(
                      fontSize: fontSize * 1.2,
                      fontColor: Colors.black,
                    ),
                    onChanged: (final value) {
                      _onChanged(searchBoxProvider);
                    },
                    autofocus: true,
                    controller: searchBoxProvider.searchController,
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'Search notes',
                      border: InputBorder.none,
                      hintStyle: textStyleOS(
                        fontSize: fontSize,
                        fontColor: grey,
                      ).copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
          ),

          TextButton(
            onPressed: () {
              _onCancel(searchBoxProvider);
              FocusScope.of(context).unfocus();
              context.pop();
            },
            child: Text(
              'Cancel',
              style: textStyleOS(
                fontSize: fontSize * 1.1,
                fontColor: themeOrange,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    } else {
      return Material(
        elevation: 2,
        borderRadius: BorderRadius.circular(50),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(50),
          ),

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  HugeIcons.strokeRoundedSearch01,
                  size: MediaQuery.of(context).size.width / 25,
                  color: darkkgrey,
                ),

                const Gap(10),
                Text(
                  'Search notes',
                  style: textStyleOS(
                    fontSize: fontSize,
                    fontColor: darkkgrey,
                  ).copyWith(fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }
}
