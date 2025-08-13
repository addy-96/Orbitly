import 'package:Orbitly/core/constant.dart';
import 'package:Orbitly/providers/notes_pro.dart';
import 'package:Orbitly/services/settings_local_service.dart';
import 'package:flutter/widgets.dart';

class SettingsPro with ChangeNotifier {
  final SettingsLocalService settingsLocalService;
  final NotesPro notesPro;

  SettingsPro({required this.settingsLocalService, required this.notesPro}) {
    initializeSettings();
  }
  final Map<String, String> _settings = {
    themeSetKey: '',
    fontSizeSetKey: '',
    sortSetKey: '',
    layoutSetKey: '',
  };

  Map<String, String> get settings => _settings;

  Future<void> initializeSettings() async {
    await settingsLocalService.initalizeSettings();
    _settings[themeSetKey] = await settingsLocalService.getSetting(
      settingKey: themeSetKey,
    );
    _settings[fontSizeSetKey] = await settingsLocalService.getSetting(
      settingKey: fontSizeSetKey,
    );
    _settings[sortSetKey] = await settingsLocalService.getSetting(
      settingKey: sortSetKey,
    );
    _settings[layoutSetKey] = await settingsLocalService.getSetting(
      settingKey: layoutSetKey,
    );
    notifyListeners();
  }

  void changeSettings({
    required final String settingKey,
    required final String settingValue,
  }) async {
    settingsLocalService.changeSetting(
      settingKey: settingKey,
      settingValue: settingValue,
    );

    await initializeSettings();

    //to sort the home notes accordingly
    rearrangeNotes();
    notifyListeners();
  }

  double getFontSize() {
    return _settings[fontSizeSetKey] == 'Small'
        ? 12
        : _settings[fontSizeSetKey] == 'Medium'
        ? 14
        : 16;
  }

  Future<void> resetSettings() async {
    await settingsLocalService.resetSettings();
    initializeSettings();
    notifyListeners();
  }

  void rearrangeNotes() {
    final config = _settings[sortSetKey];
    if (config == 'OF') {
      notesPro.notesList.sort(
        (final a, final b) => a.createdAt.compareTo(b.createdAt),
      );
    } else {
      notesPro.notesList.sort(
        (final a, final b) => b.modifiedAt.compareTo(a.modifiedAt),
      );
    }
  }
}
