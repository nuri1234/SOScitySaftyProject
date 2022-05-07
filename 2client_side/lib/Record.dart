import 'package:flutter/material.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'dart:async';
import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:audioplayers/audioplayers.dart' as ap;

class Record extends StatefulWidget {
  const Record({Key? key}) : super(key: key);

  @override
  State<Record> createState() => _RecordState();
}

class _RecordState extends State<Record> {
  final recorder =FlutterSoundRecorder() ;
  late String recordFilePath;
  bool isRecorderReady=false;
  final audioPlayer=ap.AudioPlayer();
  bool isPlaying=false;
  Duration duration=Duration.zero;
  Duration position=Duration.zero;
  late File audioFile;



  Future record() async{
    await recorder.startRecorder(toFile:'audio');
  }

  Future stopRecording() async{
    if(!isRecorderReady) return;
    final path=await recorder.stopRecorder();
    audioFile=File(path!);
    print('Recorder audio: $audioFile');

      audioPlayer.setUrl(path,isLocal: true);

      await audioPlayer.seek(position);
    setState(() {
      position=Duration.zero;
    });


    print("yoyo");
  }

  Future initRecorder()async{
    print("record init");
    final status=await Permission.microphone.request();
    print("record init1");
    if(status!=PermissionStatus.granted){
      throw 'microphone permission not granted';
    }
    print("record init2");
    await recorder.openRecorder();
    isRecorderReady=true;
    print("record init3");
    recorder.setSubscriptionDuration(
      const Duration(milliseconds:500),
    );
  }

  String formatTime(Duration duration){
    String toDigits(int n)=>n.toString().padLeft(2,'0');
    final Seconds=toDigits(duration.inSeconds.remainder(60));
    final minutes=toDigits(duration.inMinutes.remainder(60));
    final hours=toDigits(duration.inHours);
    return [
      if(duration.inHours>0) hours,
      minutes,
      Seconds,
    ].join(':');

  }





  @override
  void initState(){
    super.initState();
    initRecorder();

    audioPlayer.onPlayerStateChanged.listen((state) {
     setState(() {
       isPlaying=state==ap.PlayerState.PLAYING;});
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {duration=newDuration;});

    });

    audioPlayer.onAudioPositionChanged.listen((newPosition) {
      setState(() {position=newPosition;});

    });




  }

  @override
  void dispose(){
    recorder.closeRecorder();
    audioPlayer.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: Colors.white,
        appBar: AppBar(
        title: Text('helloo'),
    backgroundColor: Colors.transparent,
    elevation: 0.0,
    ),
    body: Center(
    child: Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      SizedBox(
        height:100,
      ),
      StreamBuilder<RecordingDisposition>(
          stream: recorder.onProgress,
          builder:(context,snapshot){
            final duration=snapshot.hasData
                ? snapshot.data!.duration
                : Duration.zero;
          //  return Text('${duration.inSeconds} s',style: TextStyle(color: Colors.black,fontSize: 50),);
            String toDigits(int n)=>n.toString().padLeft(2,'0');
            final toDigitMinures=toDigits(duration.inMinutes.remainder(60));
            final toDigitSeconds=toDigits(duration.inSeconds.remainder(60));
            return Text(
              '$toDigitMinures:$toDigitSeconds',
              style: const TextStyle(
                fontSize: 80,
                fontWeight: FontWeight.bold,
              ),
            );
          }
      ),
      SizedBox(
        height: 20,
      ),
      ElevatedButton(
          onPressed: () async {
            if(recorder.isRecording) {await stopRecording();}
            else {
              await record();}
            setState(() {

            });
          },
          child: Icon(recorder.isRecording? Icons.stop: Icons.mic)),

      SizedBox(
        height: 20,
      ),
      Slider(
        min: 0,
          max: duration.inSeconds.toDouble(),
          value: position.inSeconds.toDouble(),
          onChanged: (value)async{
          final position=Duration(seconds: value.toInt());
          await audioPlayer.seek(position);
          await audioPlayer.resume();



      }),
      Row(children: [
        Text(formatTime(position)),
        SizedBox(
          width: 50,
        ),
        Text(formatTime(duration-position)),
      ],),
      SizedBox(
        height: 20,
      ),
      ElevatedButton(
          onPressed: () async {
            if(isPlaying){
              await audioPlayer.pause();
            }
            else{
            //  String url='https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3';
              audioPlayer.resume();

            }
          },
          child: Icon(isPlaying? Icons.stop :Icons.play_arrow)),


    ]),
    ),
    );
  }
}
