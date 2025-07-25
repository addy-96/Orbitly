
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/textstyle.dart';
import 'package:noted_d/providers/search_box_pro.dart';
import 'package:provider/provider.dart';

class HomeScreenSearchbox extends StatelessWidget {
  const HomeScreenSearchbox({super.key, required this.isWithInputField});
  final bool isWithInputField;

  @override
  Widget build(final BuildContext context) {
    final searchBoxUiPro = Provider.of<SearchBoxPro>(context);
    if (isWithInputField) {
      return Row(
        children: [
          Expanded(
            child: Hero(
              tag: 'search-box',
              child: Material(
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 0,
                    ),
                    child: TextField(
                      style: textStyleOS(fontSize: 18, fontColor: Colors.black),
                      onChanged: (final value) {
                        if (searchBoxUiPro.searchController.text
                            .trim()
                            .isEmpty) {
                          return;
                        }
                        searchBoxUiPro.clearSearchedNotes();
                        searchBoxUiPro.onSearch(
                          searchedString: searchBoxUiPro.searchController.text
                              .trim(),
                        );
                      },
                      autofocus: true,
                      controller: searchBoxUiPro.searchController,
                      keyboardType: TextInputType.text,
                      cursorColor: Colors.black,
                      decoration: InputDecoration(
                        hintText: 'Search notes',
                        border: InputBorder.none,
                        hintStyle: textStyleOS(
                          fontSize: 14,
                          fontColor: Colors.grey.shade400,
                        ).copyWith(fontWeight: FontWeight.w500),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              searchBoxUiPro.searchController.clear();
              searchBoxUiPro.clearSearchedNotes();
              searchBoxUiPro.toggelSearchBox();
            },
            child: Text(
              'Cancel',
              style: textStyleOS(
                fontSize: 15,
                fontColor: Colors.deepOrange,
              ).copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      );
    } else {
      return Hero(
        tag: 'search-box',
        child: Material(
          elevation: 1,
          borderRadius: BorderRadius.circular(50),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300.withOpacity(0.4),
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
                    color: Colors.grey.shade400,
                  ),
                  const Gap(10),
                  Text(
                    'Search notes',
                    style: textStyleOS(
                      fontSize: 14,
                      fontColor: Colors.grey.shade400,
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


