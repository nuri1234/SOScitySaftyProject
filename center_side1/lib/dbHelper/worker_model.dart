// To parse this JSON data, do
//
//     final workerModel = workerModelFromJson(jsonString);

import 'dart:convert';

import 'package:crossplat_objectid/crossplat_objectid.dart';

WorkerModel workerModelFromJson(String str) => WorkerModel.fromJson(json.decode(str));

String workerModelToJson(WorkerModel data) => json.encode(data.toJson());

class WorkerModel {
  WorkerModel({
    required this.id,
    required this.fullName,
    required this.userName,
    required this.password,
  });

  ObjectId id;
  String fullName;
  String userName;
  String password;

  factory WorkerModel.fromJson(Map<String, dynamic> json) => WorkerModel(
    id: json["_id"],
    fullName: json["fullName"],
    userName: json["userName"],
    password: json["password"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "fullName": fullName,
    "userName": userName,
    "password": password,
  };
}
