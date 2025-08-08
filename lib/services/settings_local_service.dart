import 'dart:developer';
import 'package:Orbitly/core/constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract interface class SettingsLocalService {
  Future initalizeSettings();
  Future changeSetting({
    required final String settingKey,
    required final String settingValue,
  });
  Future<String> getSetting({required final String settingKey});

  Future resetSettings();
}

final class SettingsLocalServiceImpl implements SettingsLocalService {
  @override
  Future initalizeSettings() async {
    try {
      final sharedPref = await SharedPreferences.getInstance();
      final ifSettingIntialized = await checkIfSettingsExist();
      if (!ifSettingIntialized) {
        await sharedPref.setString(themeSetKey, themLightSetVal);
        await sharedPref.setString(fontSizeSetKey, fontSzieMediumSetVal);
        await sharedPref.setString(sortSetKey, sortBMDSetVal);
        await sharedPref.setString(layoutSetKey, layoutGridSetVal);
      }
      log('settings initializeed in the app');
    } catch (err) {
      log(err.toString());
      throw Exception(err);
    }
  }

  Future<bool> checkIfSettingsExist() async {
    try {
      final sharedPref = await SharedPreferences.getInstance();
      final res = sharedPref.getString(themeSetKey);
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
    required final String settingKey,
    required final String settingValue,
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
  Future<String> getSetting({required final String settingKey}) async {
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
      await sharedPref.setString(themeSetKey, themLightSetVal);
      await sharedPref.setString(fontSizeSetKey, fontSzieMediumSetVal);
      await sharedPref.setString(sortSetKey, sortBMDSetVal);
      await sharedPref.setString(layoutSetKey, layoutGridSetVal);
    } catch (err) {
      log(err.toString());
      throw Exception(err);
    }
  }
}
