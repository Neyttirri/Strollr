import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'package:strollr/model/picture_categories.dart';

class SharedPrefs {
  static SharedPreferences? _prefs; // initialised in main
  static const _keyCurrentWalkId = 'currentWalkId';
  static const _keyIdToCategory = 'idToCategory';

  static Future init() async {
   if(_prefs == null)
      _prefs = await SharedPreferences.getInstance();
  }

  static Future setCurrentWalkId(int id) async {
    await _prefs!.setInt(_keyCurrentWalkId, id);
  }

  /// get Id of the current walk. Return -1 if there is none
  static int getCurrentWalkId() =>
     _prefs!.getInt(_keyCurrentWalkId) ?? -1;

}