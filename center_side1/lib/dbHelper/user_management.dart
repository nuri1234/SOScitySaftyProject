import 'mongodb.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'user_model.dart';



Future<User> newUser(String userName, String password)async{
  final id = ObjectId();
  print("ff");
  final  user = User(
    id:id,
    userName: userName,
    password:password,

  );


  await MongoDB.insertUser(user);


  return user;
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




