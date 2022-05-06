import 'mongodb.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:center_side/dbHelper/mng_model.dart';



Future<Mng> newMng(String userName,String password)async{
  final id = ObjectId();
  print("ff");
  final  mng = Mng(
    id:id,
    userName: userName,
    password: password,
  );
  await MongoDB.insertMng(mng);
  return mng;
}



dynamic searchMng(String userName)async{
  List l=await MongoDB.getMng();
  int i;
  print("searchMng() username: $userName");

  for(i=0;i<l.length;i++){
    print(l[i]['userName']);
    print(l[i]['password']);
    if(l[i]['userName']==userName){
      print("found");
      final mng=Mng(
        id: l[i]['_id'],
        userName:l[i]['userName'],
        password:l[i]['password']
      );
      return mng;
    }
  }
  return null;
}




