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


Contact creatContact(var c){

  print("creatContact");
  print(c);
  Contact contact=Contact(
      id: c['_id'],
      worker_userName: c['worker_userName'],
      date: c['date'],
      client_userName:c['client_userName'],
      client_phone:c['client_phone'],
      city: c['city'],
      street: c['street'],
      event_type:c['event_type'],
      description: c['description']);

  return contact;
}


//Future<List<Map<String, dynamic>>> getContacts()async{
Future<List<Contact>> getContacts()async{
  List<Contact> contacts = [];
  var DBcontacts=await MongoDB.getContacts();
  for(var c in DBcontacts){
    print(c);
    Contact contact=creatContact(c);
    contact.loadDateTimeData();
    contacts.add(contact);

  }

  return contacts;
}
