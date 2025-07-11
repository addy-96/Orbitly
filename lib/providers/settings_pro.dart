import 'dart:developer';

import 'package:flutter/widgets.dart';
import 'package:noted_d/services%20/settings_local_service.dart';

class SettingsPro with ChangeNotifier {
  final SettingsLocalService settingsLocalService;
  SettingsPro({required this.settingsLocalService});
  final Map<String, String> _settings = {
    'cloud-set': '',
    'font-size-set': '',
    'sort-set': '',
    'layout-set': '',
  };

  Map<String, String> get settings => _settings;

  void initializeSettings() async {
    log('initalization called');
    await settingsLocalService.initalizeSettings();
    _settings['cloud-set'] = await settingsLocalService.getSetting(
      settingKey: 'cloud-set',
    );
    _settings['font-size-set'] = await settingsLocalService.getSetting(
      settingKey: 'font-size-set',
    );
    _settings['sort-set'] = await settingsLocalService.getSetting(
      settingKey: 'sort-set',
    );
    _settings['layout-set'] = await settingsLocalService.getSetting(
      settingKey: 'layout-set',
    );
    log(_settings.toString());
    notifyListeners();
  }

  void changeSettings({
    required String settingKey,
    required String settingValue,
  }) {
    settingsLocalService.changeSetting(
      settingKey: settingKey,
      settingValue: settingValue,
    );
    initializeSettings();
    notifyListeners();
  }

  double getFontSize() {
    return _settings['font-size-set'] == 'Small'
        ? 10
        : _settings['font-size-set'] == 'Medium'
        ? 14
        : 18;
  }

  Future<void> resetSettings() async {
    await settingsLocalService.resetSettings();
    initializeSettings();
    notifyListeners();
  }
}
