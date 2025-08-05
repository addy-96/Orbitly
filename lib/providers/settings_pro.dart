import 'dart:developer';
import 'package:flutter/widgets.dart';
import 'package:noted_d/core/constant.dart';
import 'package:noted_d/services/settings_local_service.dart';

class SettingsPro with ChangeNotifier {
  final SettingsLocalService settingsLocalService;
  SettingsPro({required this.settingsLocalService});
  final Map<String, String> _settings = {
    cloudSetKey: '',
    fontSizeSetKey: '',
    sortSetKey: '',
    layoutSetKey: '',
  };

  Map<String, String> get settings => _settings;

  void initializeSettings() async {
    log('settings provider initalization called');
    await settingsLocalService.initalizeSettings();
    _settings[cloudSetKey] = await settingsLocalService.getSetting(
      settingKey: cloudSetKey,
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
    log(_settings.toString());
    notifyListeners();
  }

  void changeSettings({
    required final String settingKey,
    required final String settingValue,
  }) {
    settingsLocalService.changeSetting(
      settingKey: settingKey,
      settingValue: settingValue,
    );
    initializeSettings();
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
}
