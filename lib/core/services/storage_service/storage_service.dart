import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  Future<SharedPreferences> _getInstance() {
    _prefs = SharedPreferences.getInstance();
    return _prefs;
  }

  Future<void> clearPref() async {
    await _getInstance().then((value) => value.clear());
  }

  Future<bool> setBool({@required String? key, @required bool? value}) async {
    return await _getInstance().then((sp) => sp.setBool(key!, value!));
  }

  Future<bool> getBool({@required String? key}) async {
    return await _getInstance().then((value) => value.getBool(key!)!);
  }

  Future<void> setInteger({@required String? key, @required int? value}) async {
    await _getInstance().then((sp) => sp.setInt(key!, value!));
  }

  Future<int> getInteger({@required String? key}) async {
    return await _getInstance().then((value) => value.getInt(key!)!);
  }

  Future<void> setString({@required String? key, @required String? value}) async {
    return await _getInstance().then((sp) => sp.setString(key!, value!));
  }

  Future<String> getString({@required String? key}) async {
    return await _getInstance().then((value) => value.getString(key!) ?? '');
  }

  Future<void> setObject({@required String? key, @required Map<String, dynamic>? value}) async {
    return await setString(key: key, value: json.encode(value));
  }

  Future<Map<String, dynamic>> getObject({@required String? key}) async {
    try {
      final _map = await getString(key: key);
      return _map.isEmpty ? {} : json.decode(_map);
    } catch (e) {
      return {};
    }
  }

  Future<bool> isExist({@required String? key}) async {
    if ((await _getInstance()).get(key!) != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<bool> remove({@required String? key}) async {
    return await _getInstance().then((value) => value.remove(key!));
  }

  Future<bool> clearKey({@required String? key}) async {
    return await _getInstance().then((value) => value.remove(key!));
  }
}
