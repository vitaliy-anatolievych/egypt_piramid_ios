import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  final AudioPlayer audioPlayer = AudioPlayer();
  var isBeenRun = true;

  factory AudioService() {
    return _instance;
  }

  AudioService._internal();

  void playMusic() async {
    audioPlayer.setReleaseMode(ReleaseMode.loop);
    await audioPlayer.play(AssetSource('sounds/sound.wav'));
    isBeenRun = true;
  }

  void pauseMusic() {
    audioPlayer.pause();
  }

  void resumeMusic() {
    audioPlayer.resume();
  }

  void stopMusic() {
    audioPlayer.stop();
    isBeenRun = false;
  }
}
