import 'package:flutter/material.dart';
import 'package:noted_d/pages/notes_home_page.dart';
import 'package:noted_d/providers/navbar_pro.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/providers/search_box_pro.dart';
import 'package:noted_d/providers/settings_pro.dart';
import 'package:noted_d/services%20/notes_local_service.dart';
import 'package:noted_d/services%20/settings_local_service.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => NavbarPro()),
        ChangeNotifierProvider(
          create: (context) => NotesPro(
            notesLocalServiceInterface: NotesLocalServiceInterfaceImpl(),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              SettingsPro(settingsLocalService: SettingsLocalServiceImpl()),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchBoxPro(
            notesLocalServiceInterface: NotesLocalServiceInterfaceImpl(),
          )
        
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  bool _isInitialized = false;
  SettingsPro? settings;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (!_isInitialized) {
      settings = Provider.of<SettingsPro>(context, listen: false);
      settings!.initializeSettings();
      _isInitialized = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Notes',
      home: SafeArea(child: NotesAppHome()),
    );
  }
}
