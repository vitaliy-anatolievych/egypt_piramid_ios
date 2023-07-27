import 'package:flutter/material.dart';
import '/widgets/web_widget.dart';

import '../controller/player_controller.dart';

class GameFragment extends StatelessWidget {
  final String _link;
  final PlayerController _controller;

  const GameFragment(this._link, this._controller, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WebWidget(_link, _controller),
    );
  }
}
