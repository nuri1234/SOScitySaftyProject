import 'mongodb.dart';
import 'package:flutter/material.dart';
import 'package:mongo_dart/mongo_dart.dart';
import 'package:center_side/dbHelper/contacts_model.dart';


Future<Contact> newContact(String worker_userName,String date, String client_userName,String client_phone, String city, String street,String event_type, String description)async{
  final id =ObjectId();
  final  contact = Contact(
      id: id,
      worker_userName: worker_userName,
      date: date,
      client_userName: client_userName,
      client_phone:client_phone,
      city: city,
      street: street,
      event_type: event_type,
      description: description
  );
  await MongoDB.insertContact(contact);
  return contact;
}




