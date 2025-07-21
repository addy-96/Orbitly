import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hugeicons/hugeicons.dart';

class HomeAppBarActions extends StatelessWidget {
  const HomeAppBarActions({super.key});

  @override
  Widget build(final BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: () async {
              context.push('/folder');
            },
            icon: const Icon(HugeIcons.strokeRoundedFolder01),
          ),
          IconButton(
            onPressed: () async {
              context.push('/setting');
            },
            icon: const Icon(HugeIcons.strokeRoundedSettings03),
          ),
        ],
      ),
    );
  }
}
