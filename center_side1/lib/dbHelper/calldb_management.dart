
import 'mongodb.dart';
import 'package:flutter/material.dart';
import 'package:center_side/dbHelper/call_class.dart';
import 'package:mongo_dart/mongo_dart.dart';



Future<Call> newCall(String userName, String phone,double lat,double long,String msg,int imgSize,String imagesId)async{
final dateTime=DateTime.now();
final id = ObjectId();
print("ff");
  final  call = Call(
      id:id,
        phone: phone,
        userName: userName,
        lat: lat,
        long: long,
        msg: msg,
        imgSize: imgSize,
        imagesId:imagesId,
      dateTime:  dateTime ,
    );
  print("hii");
  print(call.toString());
    await MongoDB.insertCall(call);
    print("hii2");

  return call;
  }



dynamic searchCall(String id)async{
  id="ObjectId(\"${id}\")";

  List l=await MongoDB.getCallDocuments();
  int i;
  print(id);
  for(i=0;i<l.length;i++){
    print(l[i]['_id'].toString());
    if(l[i]['_id'].toString()==id){
      print("found");
      final call=Call(
        id: l[i]['_id'],
        userName:l[i]['userName'],
        phone: l[i]['phone'],
        lat: l[i]['lat'],
        long: l[i]['long'],
        msg: l[i]['msg'],
        imgSize: l[i]['imgSize'],
        imagesId: l[i]['images'],
        dateTime :DateTime.parse(l[i]['dateTime']),


      );
      return call;
    }
  }

  return null;
}


void printACalls() async{
  List l=await MongoDB.getCallDocuments();
  int i;
  for(i=0;i<l.length;i++)debugPrint("${l[i]['userName']} ${l[i]['phone']} ${l[i]['lat']} ${l[i]['long']} ");
}

