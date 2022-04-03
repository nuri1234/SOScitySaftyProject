import 'dart:io';
import 'package:mongo_dart/mongo_dart.dart';

class ImagesClass{
  final ObjectId id;
  final String base64image1;
  final String base64image2;
  final String base64image3;
  final String base64image4;
  final String base64image5;

  const ImagesClass({required this.id,required this.base64image1,required this.base64image2,required this.base64image3,required this.base64image4,required this.base64image5,});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'base64image1':base64image1,
      'base64image2':base64image2,
      'base64image3':base64image3,
      'base64image4':base64image4,
      'base64image5':base64image5,
    };
  }

}