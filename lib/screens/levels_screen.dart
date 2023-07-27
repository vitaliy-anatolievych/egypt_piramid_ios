import 'package:flutter/material.dart';
import 'package:scaled_list/scaled_list.dart';

import '../game_data/game_controller.dart';

class LevelsScreen extends StatefulWidget {
  GameController gameController;
  LevelsScreen({required this.gameController, super.key});

  @override
  State<LevelsScreen> createState() =>
      _LevelsScreenState(gameController: gameController);
}

class _LevelsScreenState extends State<LevelsScreen> {
  GameController gameController;
  _LevelsScreenState({required this.gameController});
  int levelIndex = 0;

  @override
  Widget build(BuildContext context) {
    var levels = gameController.getProgress();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Image(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/game_bg.png'),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ScaledList(
                itemCount: 7,
                itemColor: (index) {
                  return const Color.fromARGB(0, 219, 117, 0);
                },
                itemBuilder: (index, selectedIndex) {
                  levelIndex = selectedIndex;
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      Image(
                        width: 300,
                        height: 300,
                        fit: BoxFit.fill,
                        image: levels[index].isUnlock == true
                            ? const AssetImage('assets/images/selected_bg.png')
                            : const AssetImage(
                                'assets/images/lock_level_bg.png'),
                      ),
                      Center(
                        child: Text(
                          levels[index].isUnlock == true
                              ? "${index + 1} \nLevel\nOPEN"
                              : "${index + 1} \nLevel\nLOCKED",
                          style: TextStyle(
                              color: selectedIndex == index
                                  ? levels[index].isUnlock == true
                                      ? Colors.green
                                      : Colors.red
                                  : Colors.black,
                              fontSize: selectedIndex == index ? 25 : 20),
                          textAlign: TextAlign.center,
                        ),
                      )
                    ],
                  );
                },
              ),
              IconButton(
                iconSize: 170.0,
                onPressed: () {
                  var level = levels[levelIndex];
                  if (level.isUnlock) {
                    gameController.putLevel(level);
                    Navigator.popAndPushNamed(context, 'GameScreen');
                  }
                },
                icon: Image.asset('assets/images/btn_play.png'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
