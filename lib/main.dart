import 'package:Orbitly/core/router.dart';
import 'package:Orbitly/providers/drawing_pro.dart';
import 'package:Orbitly/providers/navbar_pro.dart';
import 'package:Orbitly/providers/notes_pro.dart';
import 'package:Orbitly/providers/search_box_pro.dart';
import 'package:Orbitly/providers/settings_pro.dart';
import 'package:Orbitly/providers/task_pro.dart';
import 'package:Orbitly/services/notes_local_service.dart';
import 'package:Orbitly/services/settings_local_service.dart';
import 'package:Orbitly/services/tasks_local_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
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
          create: (final context) => SettingsPro(
            notesPro: Provider.of<NotesPro>(context, listen: false),
            settingsLocalService: SettingsLocalServiceImpl(),
          ),
        ),
        ChangeNotifierProvider(
          create: (final context) => SearchBoxPro(
            notesLocalServiceInterface: NotesLocalServiceInterfaceImpl(),
          ),
        ),
        ChangeNotifierProvider(
          create: (final context) => DrawingPro(
            notesPro: Provider.of<NotesPro>(context, listen: false),
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
