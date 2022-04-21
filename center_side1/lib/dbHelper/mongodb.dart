import 'dart:developer';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:center_side/dbHelper/constants.dart';
import 'package:center_side/dbHelper/user_model.dart';
import 'worker_model.dart';

class MongoDB{
  static var db,UserCollection,WorkerCollectin;
  static connect() async {
    db = await Db.create(MONGO_CONN_URL);
    await db.open();
    //inspect(db);
    UserCollection=db.collection(USER_COLLECTION);
    WorkerCollectin=db.collection(WORKER_COLLECTION);
  }




  static insertUser(User user) async {
    await UserCollection.insertAll([user.toMap()]);

  }


  static insertWorker(WorkerModel worker) async {
    await WorkerCollectin.insertAll([worker.toMap()]);

  }





  static Future<List<Map<String, dynamic>>> getUsers() async {
    try {
      final users = await UserCollection.find().toList();
      return users;
    } catch (e) {
      print(e);
      throw Future.value(e);
    }
  }


  static Future<List<Map<String, dynamic>>> getWorkers() async {
    try {
      final workers = await WorkerCollectin.find().toList();
      return workers;
    } catch (e) {
      print(e);
      throw Future.value(e);
    }
  }


  /*static update(Call call) async {
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
  }*/


}