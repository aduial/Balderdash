import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class UserPreferences {

  static final navigatorKey = GlobalKey<NavigatorState>();
  static SharedPreferences? _preferences;

  static const _keyShowMinui = 'ShowMinui';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setShowMinui(bool showMinui) async =>
      await _preferences?.setBool(_keyShowMinui, showMinui);

  static bool? getShowMinui() => _preferences?.getBool(_keyShowMinui);

  static bool getShowMinuiNotNull(){
    if (getShowMinui() != null) {
      return getShowMinui()!;
    } else {
      return true;
    }
  }

  static Future reset() async {
    await _preferences?.clear();
  }

}