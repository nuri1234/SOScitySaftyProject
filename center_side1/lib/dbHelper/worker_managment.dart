import 'package:flutter/material.dart';
import 'package:center_side/dbHelper/worker_model.dart';
import 'mongodb.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'user_model.dart';
import 'package:bson/src/classes/object_id.dart' ;




Future<WorkerModel> newWorker(String fullName,String userName, String password)async{
  final id =ObjectId();
  print("ff");
  final  worker = WorkerModel(
    id: id,
    fullName:fullName,
    userName: userName,
    password:password,

  );


  await MongoDB.insertWorker(worker);


  return worker;
}



dynamic searchUser(String userName)async{
  List l=await MongoDB.getUsers();
  int i;
  for(i=0;i<l.length;i++){
    if(l[i]['userName']==userName){
      print("found");
      final user=User(
        id: l[i]['_id'],
        userName:l[i]['userName'],
        password: l[i]['password'],

      );
      return user;
    }
  }

  return null;
}




