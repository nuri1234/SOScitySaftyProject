import 'package:client_side/images.dart';
import 'mongodb.dart';
import 'package:flutter/material.dart';
import 'package:client_side/dbHelper/images_class.dart';
import 'package:mongo_dart/mongo_dart.dart';

ObjectId objId(){
  return ObjectId();
}

Future<ImagesClass> newImages()async{

  final id = ObjectId();
  List<String> base64EncodeImages=my_images.getputbase64EncodeImagess();
  String b1="non";
  String b2="non";
  String b3="non";
  String b4="non";
  String b5="non";

  int i=0;
  for(String m in base64EncodeImages)
    {
      if (i==0) b1=m;
      if (i==1) b2=m;
      if (i==2) b3=m;
      if (i==3) b4=m;
      if (i==4) b5=m;

      i++;
    }



  final imgs=ImagesClass(id: id,
    base64image1:b1,
    base64image2: b2,
    base64image3: b3,
    base64image4: b4,
    base64image5: b5,
  );

  await MongoDB.insertImages(imgs);
  print("hii2");
  print(imgs.base64image1);

  return imgs;
}


