import 'dart:math';

import '/model/level_user.dart';
import '/model/session_model.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import '/components/ground.dart';
import '/test/test_vector.dart';

class BlockSimple extends BodyComponent with Tappable, HasCollisionDetection {
  final Vector2 position;
  final Sprite sprite;
  late SpriteComponent component;
  final BodyType bodyType;
  Vector2 holdCameraVector;
  SpriteComponent background;
  SpriteComponent hook;
  Ground ground;
  Component gameComponent;
  List<BlockSimple> listOfBlocks;
  SpriteComponent spriteScorebg;
  TextComponent stageText;
  TextComponent progressText;
  TextComponent pointsText;

  LevelUser levelUser;
  Session session;

  var isReverce = false;

  BlockSimple({
    required this.position,
    required this.sprite,
    required this.bodyType,
    required this.holdCameraVector,
    required this.background,
    required this.hook,
    required this.ground,
    required this.gameComponent,
    required this.listOfBlocks,
    required this.spriteScorebg,
    required this.stageText,
    required this.progressText,
    required this.pointsText,
    required this.levelUser,
    required this.session,
  }) : super(renderBody: false) {
    debugMode = false;
  }

  @override
  void update(double dt) {
    if (body.bodyType == BodyType.static) {
      if (!isReverce) {
        body.position.x += 0.12;
        TestVector.position.x = body.position.x;
        if (body.position.x > 23.5) isReverce = true;
      } else {
        body.position.x -= 0.12;
        TestVector.position.x = body.position.x;
        if (body.position.x < 16.5) isReverce = false;
      }
    }

    progressText.text = "${session.progress} / ${levelUser.winCombination}";
    pointsText.text = "Score : ${session.score}";
  }

  Future<void> loadNewCoords() async {
    holdCameraVector.y -= 5.0.toDouble();
    background.position.y -= 5.0.toDouble();
    hook.position.y -= 5.0.toDouble();
    spriteScorebg.position.y -= 5.0.toDouble();
    stageText.position.y -= 5.0.toDouble();
    progressText.position.y -= 5.0.toDouble();
    pointsText.position.y -= 5.0.toDouble();

    await Future.wait([hook.loaded, background.loaded]);
  }

  @override
  bool onTapDown(TapDownInfo info) {
    try {
      if (bodyType == BodyType.static) {
        var simpleBlock = BlockSimple(
          position: Vector2(body.position.x, position.y),
          sprite: sprite,
          bodyType: BodyType.dynamic,
          holdCameraVector: holdCameraVector,
          background: background,
          hook: hook,
          ground: ground,
          gameComponent: gameComponent,
          listOfBlocks: listOfBlocks,
          spriteScorebg: spriteScorebg,
          stageText: stageText,
          progressText: progressText,
          pointsText: pointsText,
          levelUser: levelUser,
          session: session,
        );
        listOfBlocks.add(simpleBlock);
        gameComponent.add(simpleBlock);
        removeFromParent();
        gameComponent.add(
          TimerComponent(
            period: 4,
            repeat: false,
            removeOnFinish: true,
            autoStart: true,
            onTick: () {
              session.progress++;
              if (session.progress < levelUser.winCombination) {
                session.score += Random().nextInt(100) + 10;

                // up camera
                loadNewCoords();
                // add object
                var box = BlockSimple(
                  position: Vector2(body.position.x, position.y - 5.0),
                  sprite: sprite,
                  bodyType: BodyType.static,
                  holdCameraVector: holdCameraVector,
                  background: background,
                  hook: hook,
                  ground: ground,
                  gameComponent: gameComponent,
                  listOfBlocks: listOfBlocks,
                  spriteScorebg: spriteScorebg,
                  stageText: stageText,
                  progressText: progressText,
                  pointsText: pointsText,
                  levelUser: levelUser,
                  session: session,
                );

                gameComponent.add(box);
              }
            },
          ),
        );
      }

      return true;
    } catch (error) {
      return false;
    }
  }

  @override
  Future<void> onLoad() async {
    component = SpriteComponent(
      sprite: sprite,
      size: Vector2.all(6.0),
      anchor: Anchor.center,
    );

    add(component);
    await super.onLoad();
  }

  @override
  Body createBody() {
    final shape = PolygonShape();
    final vertices = [
      Vector2(-3, -3),
      Vector2(3, -3),
      Vector2(-3, 3),
      Vector2(3, 3),
    ];
    shape.set(vertices);
    final fixtureDef = FixtureDef(shape, friction: .3, density: 1);
    final bodyDef = BodyDef(userData: this, position: position, type: bodyType);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
