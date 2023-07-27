import 'package:flame/components.dart';

import '../test/test_vector.dart';

class HookComponent extends SpriteComponent {
  @override
  final Sprite sprite;

  HookComponent({required this.sprite});

  @override
  Future<void> onLoad() async {
    size = Vector2(15, 30);
    position = Vector2(13.5, 0);

    await super.onLoad();
  }

  @override
  void update(double dt) {
    position.x = TestVector.position.x - 7.5;
  }
}
