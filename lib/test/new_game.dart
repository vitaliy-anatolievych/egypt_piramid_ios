import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/gameplay_screen.dart';
import '/game_data/game_controller.dart';
import '/model/level_user.dart';

class MyBoxGame extends Forge2DGame with HasTappables, HasCollisionDetection {
  final Function onGameEnd;
  MyBoxGame({required this.onGameEnd}) : super(gravity: Vector2(0, 5.0));

  void gameEnd(bool isWin, int progress, LevelUser levelUser, int score) {
    onGameEnd(isWin, progress, levelUser, score);
  }

  @override
  void update(double dt) {
    super.update(dt);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    GameController gameController = await initComponents();
    add(GamePlayScreen(gameController: gameController));
  }

  Future<GameController> initComponents() async {
    var prefs = await SharedPreferences.getInstance();
    return GameController(prefs);
  }
}
