import 'package:flame_forge2d/flame_forge2d.dart';

class Ground extends BodyComponent {
  final Vector2 gameSize;

  Ground(this.gameSize) : super(renderBody: false) {
    debugMode = true;
  }
  
  @override
  Body createBody() {
    final shape = EdgeShape()
      ..set(
        Vector2(0, gameSize.y * .91),
        Vector2(gameSize.x, gameSize.y * .91),
      );

    final fixtureDef = FixtureDef(shape, friction: 0.3);
    final bodyDef = BodyDef(userData: this, position: Vector2.zero());
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }
}
