import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';


class Call{
  final ObjectId id;
  final String userName;
  final String phone;
  final double lat ;
  final double long ;
  final String msg;
  final int imgSize;
  final ObjectId images;



  const Call({required this.id,required this.userName,required this.phone,required this.lat,required this.long,required this.msg,required this.imgSize,required this.images});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'userName': userName,
      'phone': phone,
      'lat': lat,
      'long': long,
      'msg':msg,
      'imgSize':imgSize,
      'images':images,


    };
  }


}