import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';


class Contact{
  final ObjectId id;
  final String worker_userName;
  final String date;
  final String client_userName;
  final String client_phone;
  final String city;
  final String street;
  final String event_type;
  final String description;


  Contact({required this.id,required this.worker_userName,required this.date,required this.client_userName,required this.client_phone,required this.city,required this.street,required this.event_type,required this.description});


  Map<String, dynamic> toMap() {
    return {
      '_id': id,
      'worker_userName': worker_userName,
      'date': date,
      'client_userName': client_userName,
      'client_phone':client_phone,
      'city': city,
      'street': street,
      'event_type': event_type,
      'description': description,
    };
  }


}