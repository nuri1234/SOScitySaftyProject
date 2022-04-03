import 'mongodb.dart';
import 'package:flutter/material.dart';
import 'package:center_side/dbHelper/images_class.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'images_class.dart';

ObjectId objId(){
  return ObjectId();
}


dynamic searchImages(String id) async{
  List l=await MongoDB.getImagesDocuments();
  int i;
  print(id);

  for(i=0;i<l.length;i++){
    print(l[i]['_id'].toString());
    if(l[i]['_id'].toString()==id){
      print("found");
      final imgs=ImagesClass(
        id: l[i]['_id'],
        base64image1:l[i]['base64image1'],
        base64image2:l[i]['base64image2'],
        base64image3:l[i]['base64image3'],
        base64image4:l[i]['base64image4'],
        base64image5:l[i]['base64image5'],
      );
      return imgs;
    }
  }

return null;
}






