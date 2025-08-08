import 'package:Orbitly/core/constant.dart';
import 'package:Orbitly/core/snackbar.dart';
import 'package:Orbitly/core/textstyle.dart';
import 'package:Orbitly/providers/notes_pro.dart';
import 'package:Orbitly/providers/search_box_pro.dart';
import 'package:Orbitly/providers/settings_pro.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

class HomeScreenSearchbox extends StatefulWidget {
  const HomeScreenSearchbox({
    super.key,
    required this.isWithInputField,
    this.searchController,
  });
  final bool isWithInputField;
  final TextEditingController? searchController;

  @override
  State<HomeScreenSearchbox> createState() => _HomeScreenSearchboxState();
}

class _HomeScreenSearchboxState extends State<HomeScreenSearchbox> {
  void _onChanged(final SearchBoxPro searchBoxProvider) {
    final searchText = widget.searchController!.text.trim();
    if (searchText.isNotEmpty) {
      searchBoxProvider.onSearch(query: searchText);
    } else {
      searchBoxProvider.searchResults.clear();
    }
  }

  void _onCancel() {
    widget.searchController!.clear();
    final searchBoxProvider = Provider.of<SearchBoxPro>(context, listen: false);
    searchBoxProvider.searchResults.clear();
    context.pop();
  }

  @override
  Widget build(final BuildContext context) {
    final searchBoxProvider = Provider.of<SearchBoxPro>(context);
    final settingsProvider = Provider.of<SettingsPro>(context);
    final notesprovider = Provider.of<NotesPro>(context, listen: false);
    final fontSize = settingsProvider.getFontSize();
    if (widget.isWithInputField) {
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
                    controller: widget.searchController,
                    style: textStyleOS(
                      fontSize: fontSize * 1.2,
                      fontColor: Colors.black,
                    ),
                    onChanged: (final value) {
                      _onChanged(searchBoxProvider);
                    },
                    autofocus: true,
                    keyboardType: TextInputType.text,
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      hintText: 'Search notes',
                      border: InputBorder.none,
                      hintStyle: textStyleOS(
                        fontSize: fontSize,
                        fontColor: darkkgrey,
                      ).copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              _onCancel();
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
      return InkWell(
        borderRadius: BorderRadius.circular(50),
        onTap: () {
          if (notesprovider.notesList.isEmpty) {
            cSnack(
              message:
                  'What are you planning to search?🤔 you dont have any notes!',
              backgroundColor: Colors.white,
              context: context,
            );
            return;
          }
          context.push('/search');
        },
        child: Material(
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
        ),
      );
    }
  }
}
