import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
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
              onTap: () {
                showModalBottomSheet(
                  
  isScrollControlled: true,
  context: context,
  builder: (final BuildContext context) {

    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom, 
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Gap(20),
               Text('Enter folder name',style: textStyleOS(fontSize: 18,fontColor: Colors.black),),
              const Gap(10),
              TextField(
                decoration: InputDecoration(
                  hintText: 'Folder name',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 2),
                  ),
                ),
              ),
              const Gap(10),
              Container(
                height: MediaQuery.of(context).size.height / 14,
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Center(child: Text('Add Folder',style: textStyleOS(fontSize: 18, fontColor: Colors.white,).copyWith(fontWeight: FontWeight.bold,),),),
              ),
            ],
          ),
        ),
      ),
    );
  },
);

              },
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
