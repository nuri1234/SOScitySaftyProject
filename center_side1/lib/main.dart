
import 'package:flutter/material.dart';

import 'dbHelper/mongodb.dart';
import 'socket_class.dart';
import 'example2.dart';
import 'signin_page.dart';
import 'homePage.dart';
import 'compount/drawer.dart';
import 'package:center_side/pages/login.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDB.connect();
  await my_socket.connect();


  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
      title: 'HomePage',
      debugShowCheckedModeBanner: false,
      home:SignIn(),
    );
  }
}

