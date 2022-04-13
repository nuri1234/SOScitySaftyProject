import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:client_side/colors.dart';
import 'package:google_fonts/google_fonts.dart';
import 'texts.dart';
import 'colors.dart';
import 'socket_class.dart';
import 'home_page.dart';
import 'registration_page.dart';



void main() async{
  runApp(const splashScreen());
 WidgetsFlutterBinding.ensureInitialized();
 my_socket.connect();
 await Firebase.initializeApp();

runApp(const MyApp());}

class splashScreen extends StatelessWidget {
  const splashScreen({Key? key}) : super(key: key);


  Widget loading()=>const Center(child: CircularProgressIndicator(color: Colors.white, ));
  Widget logo()=>Container(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      child: const Image(
        image: AssetImage('assets/images/logo.png'),
        height: 200,
        width: 200,
      )

  );
  Widget welcome()=> DefaultTextStyle(
    style: GoogleFonts.pacifico(fontSize: 60,fontWeight: FontWeight.w300,color: app_colors.Welcome),
    child: Text(my_texts.welcome),

  );
  Widget WelcomeContainer()=>Container(
    // color: Colors.red,
      height: 250,
      width:400,
      child:Stack(children: [
        Align(alignment: Alignment.topCenter,child: welcome(),),
        Align(alignment: const Alignment(0.0,1),child: logo(),),

      ],)

  );

  @override
  Widget build(BuildContext context) {
    return  MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Container(
      color: app_colors.background,
      child: Center(
        child: Column(children: [
          const SizedBox(height: 100,),
          WelcomeContainer(),
          loading(),

        ],),
      ),

    ));
  }
}

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
        home: Home(),
      );
  }


}