import 'package:client_side/local_data.dart';

class MessageModel {
  int type;
  String message;
  String time;
  final String client=data.user_name;

  MessageModel({required this.type,required this.message, required this.time});

/// DateTime.now().toString().substring(10, 16));
  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'message':message,
      'time':time
    };
  }

}