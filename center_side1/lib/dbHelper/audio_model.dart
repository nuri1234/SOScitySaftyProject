import 'package:audioplayers/audioplayers.dart';

class AudioModel{
  Duration duration = Duration.zero;
  Duration position = Duration.zero;
  AudioPlayer audioPlayer = AudioPlayer();
  bool isPlaying = false;

  AudioModel();

}