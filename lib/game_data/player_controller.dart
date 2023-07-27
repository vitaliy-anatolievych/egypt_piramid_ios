import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '/model/player_info.dart';

class PlayerController {
  SharedPreferences prefs;

  PlayerController(this.prefs);

  bool getPlayer() {
    return prefs.getBool(RESULT) ?? false;
  }

  void savePlayer(bool reject) {
    prefs.setBool(RESULT, reject);
  }

  void saveLink(String link) {
    prefs.setString(LINK, link);
  }

  String? getLink() {
    return prefs.getString(LINK);
  }

  void saveKeys(List<String> keys) {
    var data = jsonEncode(keys);
    prefs.setString(KEYS, data);
  }

  List<String>? getKeys() {
    var data = prefs.getString(KEYS);
    if (data != null) {
      return (jsonDecode(data) as List<dynamic>).cast<String>();
    } else {
      return null;
    }
  }

  void saveInfo(PlayerInfo playerInfo) {
    var json = jsonEncode(playerInfo.toJson());
    prefs.setString(INFO, json);
  }

  PlayerInfo getInfo() {
    var data = prefs.getString(INFO);
    if (data != null) {
      return PlayerInfo.fromJson(jsonDecode(data));
    } else {
      return PlayerInfo();
    }
  }

  static const String RESULT = "result";
  static const String KEYS = "keys";
  static const String LINK = "link";
  static const String INFO = "info";
}
