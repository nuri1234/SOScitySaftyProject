import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';


class User{
  final ObjectId id;
  final String userName;
  final String password;


  User({required this.id,required this.userName,required this.password});


  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'userName': userName,
      'password': password,
    };
  }


}