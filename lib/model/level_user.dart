class LevelUser {
  int level;
  bool isUnlock;
  int winCombination;

  LevelUser({
    required this.level,
    required this.isUnlock,
    required this.winCombination,
  });

  factory LevelUser.fromJson(Map<String, dynamic> json) {
    var level = json['level'] as int;
    var isUnlock = json['isUnlock'] as bool;
    var winCombination = json['winCombination'] as int;

    return LevelUser(level: level, isUnlock: isUnlock, winCombination: winCombination);
  }

  Map<String, dynamic> toJson() => {
        'level': level,
        'isUnlock': isUnlock,
        'winCombination': winCombination
      };
}
