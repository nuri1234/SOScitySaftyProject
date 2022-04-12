// import 'package:center_side/nuri/connection_page.dart';
// import 'package:center_side/nuri/sos_page.dart';
// import 'package:flutter/material.dart';
// import 'package:objectid/objectid.dart';
// import 'example.dart';
// import 'dbHelper/mongodb.dart';
// import 'package:flutter/gestures.dart';
// import 'socket_class.dart';
// import 'example2.dart';
//
//
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await MongoDB.connect();
//   await my_socket.connect();
//
//
//   runApp(const MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       home:examplePage2(),
//     );
//   }
// }
//
// import 'package:center_side/nuri/connection_page.dart';
// import 'package:center_side/nuri/sos_page.dart';
// import 'package:flutter/material.dart';
// import 'package:objectid/objectid.dart';
// import 'example.dart';
// import 'dbHelper/mongodb.dart';
// import 'package:flutter/gestures.dart';
// import 'socket_class.dart';
//
// import 'LoginPage.dart';
//
//
//
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized();
//   await MongoDB.connect();
//   await my_socket.connect();
//
//
//   // runApp( MyApp());
//   runApp(const MyApp());
// }
//
//
// class MyApp extends StatelessWidget {
//   const MyApp({Key? key}) : super(key: key);
//
//
//   @override
//   Widget build(BuildContext context) {
//     return const MaterialApp(
//       title: 'Flutter Demo',
//       debugShowCheckedModeBanner: false,
//       home:examplePage(),
//       // home: LoginPage(),
//     );
//   }
// }
//
import 'package:flutter/material.dart';
import 'LoginPage.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {

    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}