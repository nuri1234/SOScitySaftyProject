
import 'package:mongo_dart/mongo_dart.dart';


class WorkerModel{
  ObjectId id;
  String fullName;
  String userName;
  String password;

  WorkerModel({required this.id, required this.fullName,required this.userName,required this.password,});

  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      "fullName": fullName,
      'userName': userName,
      'password': password,
    };
  }


}
