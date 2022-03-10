import 'dart:convert';

import 'package:huzz/model/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharePref {
  static String isLogin = "App is Login";
  static String firstTimeAppOpen = " First Time  app open";
  static String dateTokenExpired = " Time when token expired";
  static String selectedLastBusiness = "Selected Last Business";
  static String miscellanous = "Miscellanous";
  SharedPreferences? _preferences;
  SharePref() {
    //print("sharepref init");
    init();
  }
  Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  void setUser(User user) {
    _preferences!.setString(isLogin, jsonEncode(user.toJson()));
  }

  void logout() {
    _preferences!.setString(isLogin, "");
  }

  String read() {
    final key = 'token';
    String value = _preferences!.getString(key)!;
    print('read: $value');
    return value.isEmpty ? "0" : value;
  }

  saveToken(String value) {
    _preferences!.setString("token", value);
  }

  User? getUser() {
    var user = _preferences!.getString(isLogin);
    print("user value $user");
    if (user != null && user.isNotEmpty) {
      var json = jsonDecode(user);
      User uservalue = User.fromJson(json);
      return uservalue;
    } else {
      return null;
    }
  }

  void setFirstTimeOpen(bool value) {
    _preferences!.setBool(firstTimeAppOpen, value);
  }

  bool getFirstTimeOpen() {
    var value = _preferences!.getBool(firstTimeAppOpen);
    print("Am I a new User?  $value");
    return value == null ? true : value;
  }

  void setDateTokenExpired(DateTime time) {
    _preferences!.setString(dateTokenExpired, time.toIso8601String());
  }

  void setLastSelectedBusiness(String id) {
    _preferences!.setString(selectedLastBusiness, id);
  }

  void setMiscellaneous(String data) {
    _preferences!.setString(miscellanous, data);
  }

  String getMiscellaneous() {
    var value = _preferences!.getString(miscellanous);
    return value == null ? "" : value;
  }

  String getLastSelectedBusiness() {
    var value = _preferences!.getString(selectedLastBusiness);
    return value == null ? "" : value;
  }

  DateTime getDateTokenExpired() {
    var expireTime = _preferences!.getString(dateTokenExpired);
    return expireTime == null ? DateTime.now() : DateTime.parse(expireTime);
  }
}
