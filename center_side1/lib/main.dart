import 'package:flutter/material.dart';
import 'package:center_side/pages/maneger.dart';
import 'dbHelper/mongodb.dart';
import 'socket_class.dart';
import 'example2.dart';
import 'pages/signin_page.dart';
import 'pages/homePage.dart';
import 'compount/drawer.dart';
import 'package:center_side/pages/login.dart';
import 'package:center_side/pages/workPage.dart';
import 'package:center_side/pages/addWorker.dart';
import 'package:center_side/pages/workerList.dart';




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
      home:WorkerList(),
      routes: {
        'homePage':(context){
          return HomePage();
        },
        'login':(context){
          return SignIn();
        },
        'maneger':(context){
          return Maneger();
        },
        'workPage':(context){
          return WorkPage();
        },
        'addUser':(context){
          return AddWorker();
        }
      },
    );
  }
}

