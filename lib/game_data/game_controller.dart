import 'dart:convert';

import '/model/level_user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GameController {
  SharedPreferences prefs;

  GameController(this.prefs);

  void saveProgress(List<LevelUser> levels) {
    var data = jsonEncode(levels);
    print("SaveKeys: $data");
    prefs.setString(PLAYER, data);
  }

  List<LevelUser> getProgress() {
    var data = prefs.getString(PLAYER);
    print("data: $data");
    if (data != null && data.isNotEmpty) {
      List<dynamic> list = (jsonDecode(data));
      return list.map((e) => LevelUser.fromJson(e)).toList();
    } else {
      return createNewGame();
    }
  }

  void putLevel(LevelUser level) {
    var json = jsonEncode(level.toJson());
    prefs.setString(LEVEL, json);
  }

  LevelUser getLevel() {
    var data = prefs.getString(LEVEL);
    return LevelUser.fromJson(jsonDecode(data!));
  }

  List<LevelUser> createNewGame() {
    List<LevelUser> levels = <LevelUser>[
      LevelUser(level: 1, isUnlock: true, winCombination: 7),
      LevelUser(level: 2, isUnlock: false, winCombination: 10),
      LevelUser(level: 3, isUnlock: false, winCombination: 12),
      LevelUser(level: 4, isUnlock: false, winCombination: 16),
      LevelUser(level: 5, isUnlock: false, winCombination: 18),
      LevelUser(level: 6, isUnlock: false, winCombination: 24),
      LevelUser(level: 7, isUnlock: false, winCombination: 40),
    ];
    saveProgress(levels);
    return levels;
  }

  static const String PLAYER = "player";
  static const String LEVEL = "level";
}
