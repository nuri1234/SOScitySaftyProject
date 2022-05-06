import 'package:center_side/pages/main_page.dart';
import 'package:center_side/statistic/statistic_page.dart';
import 'package:flutter/material.dart';
import 'package:center_side/pages/maneger.dart';
import 'dbHelper/mongodb.dart';
import 'socket_class.dart';

import 'pages/signin_page.dart';
import 'pages/homePage.dart';
import 'compount/drawer.dart';

import 'package:center_side/pages/workPage.dart';
import 'package:center_side/pages/addWorker.dart';
import 'package:center_side/pages/workerList.dart';
import 'package:center_side/pages/viewMessage.dart';
import 'package:center_side/sos/sos_main_page.dart';





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
      home:HomePage(),
      // home:SOS(),
      routes: {
        'homePage':(context){
          return HomePage();
        },
        'login':(context){
          return SignIn();
        },
        'maneger':(context){
          return ManagerPage();
        },
        'workPage':(context){
          return WorkPage();
        },
        'addUser':(context){
          return AddWorker();
        },
        'workerList':(context)=>WorkerList(),

        'messageList':(context)=>MessageList(),
      },
    );
  }
}
