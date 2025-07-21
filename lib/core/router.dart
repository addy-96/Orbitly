import 'package:go_router/go_router.dart';
import 'package:noted_d/pages/create_notes_page.dart';
import 'package:noted_d/pages/drawing_page.dart';
import 'package:noted_d/pages/folder_page.dart';
import 'package:noted_d/pages/notes_home_page.dart';
import 'package:noted_d/pages/search_page.dart';
import 'package:noted_d/pages/settings_page.dart';

final GoRouter goRouterConfig = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      name: 'home',
      builder: (final context, final state) => const NotesAppHome(),
    ),
    GoRoute(
      path: '/folder',
      name: 'folder',
      builder: (final context, final state) => const FolderPage(),
    ),
    GoRoute(
      path: '/setting',
      name: 'setting',
      builder: (final context, final state) => const SettingsPage(),
    ),
    GoRoute(
      path: '/create_notes',
      name: 'create_notes',
      builder: (final context, final state) => const CreateNotesPage(),
    ),
    GoRoute(
      path: '/search',
      name: 'search',
      builder: (final context, final state) => const SearchPage(),
    ),
    GoRoute(
      path: '/drawing',
      name: 'drawing',
      builder: (final context, final state) => const DrawingPage(),
    ),
  ],
);
