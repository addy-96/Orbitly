import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:noted_d/core/textstyle.dart';

class HomeScreenSearchbox extends StatelessWidget {
  const HomeScreenSearchbox({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(50),
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade300.withOpacity(0.7),
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
              Gap(10),
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
    );
  }
}


/*TextField(
          style: textStyleOS(
            fontSize: 16,
            fontColor: Colors.black,
          ).copyWith(fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: 'Search notes',
            hintStyle: textStyleOS(
              fontSize: 18,
              fontColor: Colors.grey.shade400,
            ).copyWith(fontWeight: FontWeight.w500),
            prefixIcon: HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              size: MediaQuery.of(context).size.width / 25,
              color: Colors.grey.shade400,
            ),
          ),
        ),*/