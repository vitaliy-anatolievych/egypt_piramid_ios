import '/model/session_model.dart';
import 'package:flame/components.dart';
import 'package:flame/palette.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/cupertino.dart';

import '/components/block_simple.dart';
import '/components/ground.dart';
import '/components/hook.dart';
import '../game_data/game_controller.dart';
import '../test/new_game.dart';

class GamePlayScreen extends Component with HasGameRef<MyBoxGame> {
  final motorSpeed = 1;
  bool clockWise = true;
  late final BlockSimple simpleBlock;
  late final HookComponent hook;
  late Vector2 holdCameraVector;
  SpriteComponent background = SpriteComponent();
  late Ground ground;
  GameController gameController;

  GamePlayScreen({required this.gameController});

  @override
  void update(double dt) {}

  @override
  void onLoad() async {
    await super.onLoad();
    var level = gameController.getLevel();

    background
      ..sprite = await gameRef.loadSprite('game_bg.png')
      ..size = gameRef.size;
    add(background);

    hook = HookComponent(
      sprite: await gameRef.loadSprite('ic_hook.png'),
    );

    add(hook);
    holdCameraVector = Vector2(
        gameRef.size.x - (gameRef.size.x / 2), game.size.y / 2);

    ground = Ground(gameRef.size);
    add(ground);

    var listOfBlocks = <BlockSimple>[];

    var session = Session();

    add(TimerComponent(
      period: 3,
      repeat: true,
      removeOnFinish: false,
      autoStart: true,
      onTick: (() {
        if (listOfBlocks.isNotEmpty) {
          for (int i = 1; i < listOfBlocks.length; i++) {
            var data = listOfBlocks[i];
            if (data.body.position.y > (gameRef.size.y * .85)) {
              gameRef.gameEnd(false, session.progress, level, session.score);
            }

            if(session.progress == level.winCombination) {
              gameRef.gameEnd(true, session.progress, level, session.score);
            }
          }
        }
      }),
    ));

    final style = TextStyle(color: BasicPalette.black.color, fontSize: 2);
    final regular = TextPaint(style: style);

    var stageText = TextComponent(
        text: "STAGE ${level.level}",
        textRenderer: regular,
        position: Vector2(1, 1));

    add(stageText);

    var spriteScoreBg = SpriteComponent(
      scale: Vector2(0.1, 0.1),
      position: Vector2(1, 4),
      sprite: await gameRef.loadSprite('score_bg.png'),
    );
    add(spriteScoreBg);

    final style2 = TextStyle(
        color: BasicPalette.black.color,
        fontSize: 2,
        fontWeight: FontWeight.w600);
    final regular2 = TextPaint(style: style2);

    var progressText = TextComponent(
      text: "0 / ${level.winCombination}",
      textRenderer: regular2,
      position: Vector2(4.5, 5),
    );

    add(progressText);

    var pointsText = TextComponent(
      text: "Score : 0",
      textRenderer: regular2,
      position: Vector2(20, 1),
    );

    add(pointsText);

    simpleBlock = BlockSimple(
      position: Vector2(20.5, 32),
      sprite: await gameRef.loadSprite('ic_block.png'),
      bodyType: BodyType.static,
      holdCameraVector: holdCameraVector,
      background: background,
      hook: hook,
      ground: ground,
      gameComponent: this,
      listOfBlocks: listOfBlocks,
      spriteScorebg: spriteScoreBg,
      stageText: stageText,
      progressText: progressText,
      pointsText: pointsText,
      levelUser: level,
      session: session,
    );

    add(simpleBlock);

    game.camera.followVector2(holdCameraVector);
  }
}
