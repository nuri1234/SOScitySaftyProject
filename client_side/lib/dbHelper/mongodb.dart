import 'dart:developer';

import 'package:mongo_dart/mongo_dart.dart';
import 'package:client_side/dbHelper/constants.dart';
import 'package:client_side/dbHelper/call_class.dart';

class MongoDB{
  static var db,callCollection;
  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    callCollection = db.collection(CALL_COLLECTION);
  }

  static insert(Call call) async {
    await callCollection.insertAll([call.toMap()]);

  }


  static Future<List<Map<String, dynamic>>> getDocuments() async {
    try {
      final cals = await callCollection.find().toList();
      return cals;
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