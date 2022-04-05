import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:center_side/dbHelper/constants.dart';
import 'package:center_side/dbHelper/call_class.dart';
import 'package:center_side/dbHelper/images_class.dart';

class MongoDB{
  static var db,callCollection,ImagesCollection;
  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    callCollection = db.collection(CALL_COLLECTION);
    ImagesCollection = db.collection(IMAGES_COLLECTION);
  }

  static insertCall(Call call) async {
    await callCollection.insertAll([call.toMap()]);
  }
  static insertImages(ImagesClass imgs) async {
    await  ImagesCollection.insertAll([imgs.toMap()]);
  }



  static Future<List<Map<String, dynamic>>> getCallDocuments() async {
    try {
      final cals = await callCollection.find().toList();
      return cals;
    } catch (e) {
      print(e);
      throw Future.value(e);
    }
  }

  static Future<List<Map<String, dynamic>>> getImagesDocuments() async {
    try {
      final images = await ImagesCollection.find().toList();
      return images;
    } catch (e) {
      print(e);
      throw Future.value(e);
    }
  }


  static update(Call call) async {
    var c = await callCollection.findOne({"_id": call.id});
    c["userName"];
    c["phone"] = call.phone;
    c["lat"] = call.lat;
    c["long"] = call.long;
    c["status"] = call.phone;
    await callCollection.save(c);
  }

  static delete(Call call) async {
    await callCollection.remove(where.id(call.id));
  }


}