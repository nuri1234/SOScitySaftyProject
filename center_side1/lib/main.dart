import 'package:flutter/material.dart';

import 'dbHelper/mongodb.dart';
import 'socket_class.dart';
import 'example2.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await MongoDB.connect();
  await my_socket.connect();


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      home:examplePage2(),
    );
  }
}
