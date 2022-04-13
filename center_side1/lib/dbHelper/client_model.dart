import 'package:mongo_dart/mongo_dart.dart';
import 'message_model.dart';


class Client{
  final String userName;
  final String phone;
  final double lat ;
  final double long ;
  final DateTime dateTime;
  int STATUS=0; //0-new 1-opened/received 2-canceled 3-disconnected 4-call end
  final String socketId;
 List<MessageModel>  messages=[];



  Client({required this.userName,required this.phone,required this.lat,required this.long,required this.socketId,required this.dateTime});

  void changeStatus(int status){
    STATUS=status;
  }

  void addMessage(MessageModel msg){
    messages.add(msg);
  }







}