import '/test/test_vector.dart';
import 'package:flutter/material.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    setState(() {
      if (AppLifecycleState.paused == state) {
        TestVector.audioService.pauseMusic();
      }
      if (AppLifecycleState.resumed == state) {
        if (TestVector.audioService.isBeenRun) {
          TestVector.audioService.resumeMusic();
        }
      }
    });
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          const Image(
            fit: BoxFit.fill,
            image: AssetImage('assets/images/start_bg.png'),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100,
                  child: IconButton(
                    iconSize: 170.0,
                    onPressed: () {
                      Navigator.pushNamed(context, 'StartGame');
                    },
                    icon: Image.asset('assets/images/btn_play.png'),
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: IconButton(
                    iconSize: 170.0,
                    onPressed: () {
                      Navigator.pushNamed(context, 'RulesScreen');
                    },
                    icon: Image.asset('assets/images/btn_rules.png'),
                  ),
                ),
                SizedBox(
                  height: 100,
                  child: IconButton(
                    iconSize: 170.0,
                    onPressed: () {
                      Navigator.pushNamed(context, 'SettingsScreen');
                    },
                    icon: Image.asset('assets/images/btn_settings.png'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
