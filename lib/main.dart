import 'package:flutter/material.dart';
import 'package:noted_d/pages/notes_home_page.dart';
import 'package:noted_d/providers/navbar_pro.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/services%20/notes_local_service.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavbarPro()),
        ChangeNotifierProvider(
          create: (context) => NotesPro(
            notesLocalServiceInterface: NotesLocalServiceInterfaceImpl(),
          ),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes',
      home: SafeArea(child: NotesAppHome()),
    );
  }
}
