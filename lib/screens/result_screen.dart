import '/model/level_user.dart';
import 'package:flutter/material.dart';

import '../game_data/game_controller.dart';

class ResultScreen extends StatelessWidget {
  bool isWin;
  int progress;
  LevelUser levelUser;
  GameController gameController;
  int score;

  ResultScreen(
      {required this.isWin,
      required this.levelUser,
      required this.progress,
      required this.gameController,
      required this.score,
      super.key});

  @override
  Widget build(BuildContext context) {
    if(isWin && levelUser.level < 7) {
      var levels = gameController.getProgress();
      var newLevel = levels[levelUser.level];
      newLevel.isUnlock = true;
      levels.replaceRange(levelUser.level, levelUser.level + 1, [newLevel]);
      gameController.saveProgress(levels);
    }
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Image(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/game_bg.png'),
          ),
          const Image(
            width: 150,
            height: 100,
            fit: BoxFit.none,
            image: AssetImage('assets/images/result_bg.png'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 100, bottom: 100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  isWin == true ? "COMPLETE" : "LEVEL FAILURE",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 24),
                ),
                Text(
                  "STAGE ${levelUser.level}",
                  style: const TextStyle(
                      fontWeight: FontWeight.w500, fontSize: 18),
                ),
                const Text(
                  "Number of floors",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
                Text(
                  "$progress / ${levelUser.winCombination}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 60,
                      color: Colors.amber),
                ),
                const Text(
                  "Score",
                  style: TextStyle(fontWeight: FontWeight.w400, fontSize: 16),
                ),
                Text(
                  "$score",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 60,
                      color: Colors.amber),
                ),
                SizedBox(
                  height: 80,
                  child: IconButton(
                    iconSize: 170.0,
                    onPressed: () {
                      Navigator.popAndPushNamed(context, 'StartGame');
                    },
                    icon: Image.asset('assets/images/btn_next.png'),
                  ),
                ),
                SizedBox(
                  height: 80,
                  child: IconButton(
                    iconSize: 170.0,
                    onPressed: () {
                      Navigator.popAndPushNamed(context, 'StartScreen');
                    },
                    icon: Image.asset('assets/images/btn_menu.png'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
