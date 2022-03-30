import 'mongodb.dart';
import 'package:flutter/material.dart';
import 'package:center_side/dbHelper/call_class.dart';
import 'package:mongo_dart/mongo_dart.dart';

Future<Call> newCall(String userName, String phone,double lat,double long,int status )async{

  final id = ObjectId();
  final  call = Call(
      id:id,
        phone: phone,
        userName: userName,
        lat: lat,
        long: long,
        status: status

    );
  print("hii");
  print(call.toString());
    await MongoDB.insert(call);
    print("hii2");

  return call;
  }


void printACalls() async{
  List l=await MongoDB.getDocuments();
  int i;
  for(i=0;i<l.length;i++)debugPrint("${l[i]['userName']} ${l[i]['phone']} ${l[i]['lat']} ${l[i]['long']} ${l[i]['status']}");
}

