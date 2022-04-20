import 'package:audioplayers/audioplayers.dart';
import 'audio_model.dart';
class MessageModel {
  int senderType; //0-client 1-center
  int messageType;//0-Text 1-photo 2-audio
  String message;
  String describe;
  String time;
  String? _path;
  AudioModel? audio;



  MessageModel({required this.senderType,required this.messageType,required this.message,required this.describe, required this.time});

/// DateTime.now().toString().substring(10, 16));
  Map<String, dynamic> toMap() {
    return {
      'senderType': senderType,
      'messageType': messageType,
      'message':message,
      'describe': describe,
      'time':time
    };
  }

  insert_path(String path){
    _path=path;
  }
  get_path(){
    return _path;
  }




}