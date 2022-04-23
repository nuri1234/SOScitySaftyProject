import 'mongodb.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'worker_model.dart';





Future<WorkerModel> newWorker(String fullName,String userName, String password)async{
  final id =ObjectId();
  final  worker = WorkerModel(
    id: id,
    fullName:fullName,
    userName: userName,
    password:password,

  );
  await MongoDB.insertWorker(worker);
  return worker;
}



dynamic searchWorker(String userName)async{
  List l=await MongoDB.getWorkers();
  int i;
  for(i=0;i<l.length;i++){
    if(l[i]['userName']==userName){
      print("found");
      final worker=WorkerModel(
        id: l[i]['_id'],
        fullName:l[i]['fullName'],
        userName:l[i]['userName'],
        password: l[i]['password'],

      );
      return worker;
    }
  }

  return null;
}




