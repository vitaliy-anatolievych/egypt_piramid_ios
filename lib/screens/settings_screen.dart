import 'package:audioplayers/audioplayers.dart';
import '/game_data/game_controller.dart';
import '/model/level_user.dart';
import '/test/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  AudioService audioPlayer;
  GameController gameController;

  SettingsScreen(this.gameController, this.audioPlayer, {super.key});

  @override
  State<StatefulWidget> createState() =>
      SettingsWidget(gameController, audioPlayer);
}

class SettingsWidget extends State<SettingsScreen> {
  SharedPreferences? prefs;
  GameController gameController;
  AudioService audioPlayer;
  SettingsWidget(this.gameController, this.audioPlayer);

  String soundState = "";

  @override
  void initState() {
    if (audioPlayer.audioPlayer.state == PlayerState.stopped ||
        audioPlayer.audioPlayer.state == PlayerState.paused) {
      soundState = "OFF";
    } else {
      soundState = "ON";
    }
    super.initState();
  }

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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: Text(
                  "Sound $soundState",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(
                height: 100,
                child: IconButton(
                  iconSize: 170.0,
                  onPressed: () {
                    if (audioPlayer.audioPlayer.state == PlayerState.stopped ||
                        audioPlayer.audioPlayer.state == PlayerState.paused) {
                      setState(() {
                        soundState = "ON";
                      });
                      audioPlayer.playMusic();
                    } else {
                      setState(() {
                        soundState = "OFF";
                      });
                      audioPlayer.stopMusic();
                    }
                  },
                  icon: Image.asset('assets/images/btn_volume.png'),
                ),
              ),
              SizedBox(
                height: 100,
                child: IconButton(
                  iconSize: 170.0,
                  onPressed: () {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.warning,
                      headerAnimationLoop: false,
                      animType: AnimType.bottomSlide,
                      title: 'Reset Progress',
                      desc: 'Are you sure you want to reset progress?',
                      buttonsTextStyle: const TextStyle(color: Colors.black),
                      showCloseIcon: true,
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        List<LevelUser> levels = <LevelUser>[
                          LevelUser(
                              level: 1, isUnlock: true, winCombination: 7),
                          LevelUser(
                              level: 2, isUnlock: false, winCombination: 10),
                          LevelUser(
                              level: 3, isUnlock: false, winCombination: 12),
                          LevelUser(
                              level: 4, isUnlock: false, winCombination: 16),
                          LevelUser(
                              level: 5, isUnlock: false, winCombination: 18),
                          LevelUser(
                              level: 6, isUnlock: false, winCombination: 24),
                          LevelUser(
                              level: 7, isUnlock: false, winCombination: 40),
                        ];
                        gameController.saveProgress(levels);
                      },
                    ).show();
                  },
                  icon: Image.asset('assets/images/btn_reset.png'),
                ),
              ),
            ],
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
