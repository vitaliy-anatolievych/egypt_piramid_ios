import 'package:flutter/material.dart';

class RulesScreen extends StatelessWidget {
  const RulesScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
            image: AssetImage('assets/images/rules_bg.png'),
          ),
          Positioned(
            bottom: 10,
            left: 10,
            child: SizedBox(
              width: 80,
              height: 100,
              child: IconButton(
                iconSize: 170.0,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Image.asset('assets/images/btn_back.png'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
