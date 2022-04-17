
import 'package:flutter/material.dart';

import 'dbHelper/mongodb.dart';
import 'socket_class.dart';
import 'example2.dart';
import 'signin_page.dart';
import 'homePage.dart';




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
      title: 'Home Page',
      debugShowCheckedModeBanner: false,
      home:HomePage(),
    );
  }
}

