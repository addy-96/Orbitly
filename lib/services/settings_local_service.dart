import 'dart:developer';

import 'package:shared_preferences/shared_preferences.dart';

abstract interface class SettingsLocalService {
  Future initalizeSettings();
  Future changeSetting({
    required String settingKey,
    required String settingValue,
  });
  Future<String> getSetting({required String settingKey});

  Future resetSettings();
}

final class SettingsLocalServiceImpl implements SettingsLocalService {
  @override
  Future initalizeSettings() async {
    try {
      final sharedPref = await SharedPreferences.getInstance();
      final ifSettingIntialized = await checkIfSettingsExist();
      if (!ifSettingIntialized) {
        await sharedPref.setString('cloud-set', 'Setup');
        await sharedPref.setString('font-size-set', 'Medium');
        await sharedPref.setString('sort-set', 'BMD');
        await sharedPref.setString('layout-set', 'Grid');
      }
    } catch (err) {
      log(err.toString());
      throw Exception(err);
    }
  }

  Future<bool> checkIfSettingsExist() async {
    try {
      final sharedPref = await SharedPreferences.getInstance();
      final res = sharedPref.getString('cloud-set');
      if (res == null) {
        return false;
      }
      return true;
    } catch (err) {
      log(err.toString());
      throw Exception(err);
    }
  }

  @override
  Future changeSetting({
    required String settingKey,
    required String settingValue,
  }) async {
    try {
      final sharedPref = await SharedPreferences.getInstance();
      await sharedPref.setString(settingKey, settingValue);
    } catch (err) {
      log(err.toString());
      throw Exception(err);
    }
  }

  @override
  Future<String> getSetting({required String settingKey}) async {
    try {
      final sharedPref = await SharedPreferences.getInstance();

      final result = sharedPref.getString(settingKey);
      if (result == null) {
        throw Exception('Setting $settingKey not found');
      }
      return result;
    } catch (err) {
      log(err.toString());
      throw Exception(err);
    }
  }

  @override
  Future resetSettings() async {
    try {
      log('reset settings called');
      final sharedPref = await SharedPreferences.getInstance();
      await sharedPref.setString('font-size-set', 'Medium');
      await sharedPref.setString('sort-set', 'BMD');
      await sharedPref.setString('layout-set', 'Grid');
    } catch (err) {
      log(err.toString());
      throw Exception(err);
    }
  }
}
