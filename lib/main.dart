import 'package:flutter/material.dart';
import 'package:noted_d/providers/drawing_pro.dart';
import 'package:noted_d/providers/navbar_pro.dart';
import 'package:noted_d/providers/notes_pro.dart';
import 'package:noted_d/providers/search_box_pro.dart';
import 'package:noted_d/providers/settings_pro.dart';
import 'package:noted_d/providers/task_pro.dart';
import 'package:noted_d/services/notes_local_service.dart';
import 'package:noted_d/services/settings_local_service.dart';
import 'package:noted_d/services/tasks_local_service.dart';
import 'package:provider/provider.dart';
import 'package:noted_d/core/router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (final context) => NavbarPro()),
        ChangeNotifierProvider(
          create: (final context) => NotesPro(
            notesLocalServiceInterface: NotesLocalServiceInterfaceImpl(),
          ),
        ),
        ChangeNotifierProvider(
          create: (final context) =>
              SettingsPro(settingsLocalService: SettingsLocalServiceImpl()),
        ),
        ChangeNotifierProvider(
          create: (final context) => SearchBoxPro(
            notesLocalServiceInterface: NotesLocalServiceInterfaceImpl(),
          ),
        ),
        ChangeNotifierProvider(
          create: (final context) => DrawingPro(
            notesPro: NotesPro(
              notesLocalServiceInterface: NotesLocalServiceInterfaceImpl(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (final context) => TaskPro(
            tasksLocalServiceInterface: TasksLocalServiceInterfaceImpl(),
          ),
        ),
      ],      
      child: const MyApp(),
    ),
  );
}


class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
  Widget build(final BuildContext context) {
    return MaterialApp.router(
      routerConfig: goRouterConfig,
      debugShowCheckedModeBanner: false,
    );
  }
}
