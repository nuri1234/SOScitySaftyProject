import 'package:client_side/first_screen.dart';
import 'package:flutter/material.dart';
import 'sos_screen.dart';
import 'camera_page.dart';
import 'home_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'local_data.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:client_side/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'texts.dart';
import 'colors.dart';
import 'registration_screen.dart';
import 'dbHelper/mongodb.dart';
import 'images.dart';
import 'connection_page.dart';

import 'dbHelper/calldb_management.dart';




void main() async{
 WidgetsFlutterBinding.ensureInitialized();
  await MongoDB.connect();
  await Firebase.initializeApp();
runApp(const MyApp());}


class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
      return const MaterialApp(

        title: 'home page',
        debugShowCheckedModeBanner: false,
        home:Sos(),
      );

  }


}