import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:noted_d/core/snackbar.dart';
import 'package:noted_d/pages/create_notes_page.dart';
import 'package:noted_d/pages/drawing_page.dart';
import 'package:noted_d/pages/edit_notes_page.dart';
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
      path: '/edit_notes/:noteId',
      name: 'edit_notes',
      builder: (final context, final state) {
        final noteId = state.pathParameters['noteId'];
        if (noteId == null) {
          cSnack(
            message: 'Sorry no note id proovided',
            backgroundColor: Colors.white,
            context: context,
          );
          return const NotesAppHome();
        }
        return EditNotes(noteId: noteId);
      },
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
