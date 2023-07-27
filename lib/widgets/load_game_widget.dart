import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:liquid_progress_indicator/liquid_progress_indicator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../game_data/game_controller.dart';
import '../model/level_user.dart';
import '../screens/levels_screen.dart';
import '../screens/result_screen.dart';
import '../screens/rules_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/start_game.dart';
import '../test/new_game.dart';
import '../test/test_vector.dart';
import 'package:timer_count_down/timer_count_down.dart';

class LoadGameWidget extends StatefulWidget {
  const LoadGameWidget({super.key});

  @override
  State<LoadGameWidget> createState() => _GameWidgetState();
}

class _GameWidgetState extends State<LoadGameWidget>
    with SingleTickerProviderStateMixin {
  var _progress = 0.0;
  late AnimationController controller;
  late Animation<double> rotation;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1000));
    rotation = Tween(begin: 0.0, end: .2).animate(controller);

    controller.addListener(() {
      if (controller.status == AnimationStatus.completed) {
        controller.reverse();
      } else if (controller.status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.forward();
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Image(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/start_bg.png'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 30, right: 30),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: SizedBox(
                    height: 40,
                    child: Countdown(
                      seconds: 4,
                      build: (context, time) => LiquidLinearProgressIndicator(
                        value: _progress += 0.005,
                        backgroundColor: const Color.fromRGBO(16, 63, 117, 1),
                        valueColor:
                            const AlwaysStoppedAnimation(Color.fromARGB(251, 166, 41, 1)),
                        direction: Axis.horizontal,
                      ),
                      interval: const Duration(milliseconds: 18),
                      onFinished: () {
                        _runGame();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

void _runGame() async {
    Flame.device.setPortrait();
    await Flame.device.fullScreen();
    
    TestVector.audioService.playMusic();
    GameController gameController = await initComponents();

    runApp(
      MaterialApp(
        home: const StartScreen(),
        routes: {
          'StartScreen': (context) => const StartScreen(),
          'StartGame': (context) =>
              LevelsScreen(gameController: gameController),
          'GameScreen': (context) => GameWidget(
                game: MyBoxGame(
                  onGameEnd: ((bool isWin, int progress, LevelUser levelUser,
                      int score) {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResultScreen(
                                isWin: isWin,
                                progress: progress,
                                levelUser: levelUser,
                                gameController: gameController,
                                score: score,
                              )),
                      (route) => false,
                    );
                  }),
                ),
              ),
          'RulesScreen': (context) => const RulesScreen(),
          'SettingsScreen': (context) => SettingsScreen(gameController, TestVector.audioService),
        },
      ),
    );
  }

  Future<GameController> initComponents() async {
    var prefs = await SharedPreferences.getInstance();
    return GameController(prefs);
  }
}
