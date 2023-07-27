class PlayerInfo {
  bool isFirstRedir;
  bool isAnalysis;
  int counter;

  PlayerInfo({this.isFirstRedir = true, this.isAnalysis = true, this.counter = 5});

  factory PlayerInfo.fromJson(Map<String, dynamic> json) {
    var redir = json['isFirstRedir'] as bool;
    var alysis = json['isAnalysis'] as bool;
    var count = json['counter'] as int;

    return PlayerInfo(isFirstRedir: redir,isAnalysis: alysis, counter: count);
  }

  Map<String, dynamic> toJson() => {'isFirstRedir': isFirstRedir, 'isAnalysis': isAnalysis, 'counter': counter};
}