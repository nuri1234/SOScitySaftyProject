import 'mongodb.dart';
import 'package:flutter/material.dart';
import 'package:client_side/dbHelper/call_class.dart';
import 'package:mongo_dart/mongo_dart.dart';



Future<Call> newCall(String userName, String phone,double lat,double long,String msg,int imgSize,ObjectId images )async{

  final id = ObjectId();
  final  call = Call(
      id:id,
        phone: phone,
        userName: userName,
        lat: lat,
        long: long,
        msg: msg,
        imgSize: imgSize,
        images:images
    );
  print("hii");
  print(call.toString());
    await MongoDB.insertCall(call);
    print("hii2");

  return call;
  }


void printACalls() async{
  List l=await MongoDB.getCallDocuments();
  int i;
  for(i=0;i<l.length;i++)debugPrint("${l[i]['userName']} ${l[i]['phone']} ${l[i]['lat']} ${l[i]['long']} ");
}

