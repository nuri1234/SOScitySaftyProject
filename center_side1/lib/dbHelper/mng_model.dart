import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';


class Mng{
  final ObjectId id;
  final String userName;



  Mng({required this.id,required this.userName});


  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'userName': userName,
    };
  }


}