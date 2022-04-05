import 'package:center_side/nuri/connection_page.dart';
import 'package:center_side/nuri/sos_page.dart';
import 'package:flutter/material.dart';
import 'package:objectid/objectid.dart';
import 'example.dart';
import 'dbHelper/mongodb.dart';
import 'nuri/getimage.dart';
import 'package:flutter/gestures.dart';
import 'socket_class.dart';



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
      home:examplePage(),
    );
  }
}

