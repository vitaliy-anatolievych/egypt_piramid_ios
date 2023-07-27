import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/experimental.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'dart:math';

class TestComponent extends BodyComponent with TapCallbacks {
  final Vector2 position;
  TestComponent({required this.position});

  @override
  void onTapDown(TapDownEvent event) {
    print("tap");
  }

  @override
  void onLongTapDown(TapDownEvent event) {
    print("tap");
  }

  @override
  void onTapUp(TapUpEvent event) {
    print("tap");
  }

  @override
  void onTapCancel(TapCancelEvent event) {
    print("tap");
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;
    var box = SpriteComponent(
      sprite: await gameRef.loadSprite('ic_block.png'),
      size: Vector2.all(6.0),
      anchor: Anchor.center,
    );

    var rotate = RotateEffect.by(
        pi, InfiniteEffectController(LinearEffectController(2.0)));
    box.add(rotate);
    add(box);
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
    final bodyDef =
        BodyDef(userData: this, position: position, type: BodyType.static);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}