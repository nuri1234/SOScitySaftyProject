import 'package:center_side/compount/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/app.dart';
import '../compount/drawer.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:center_side/pages/signin_page.dart';

class HomePage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: Text("ברוכים הבאים"),
            backgroundColor: Colors.blue,
            centerTitle: true,
            elevation: 6,

          ),

          body: Container(
              color: Colors.white,
              child: ListView(children: [
                Container(
                    height: 200,
                    width: double.infinity,
                    child: const Image(
                      image: AssetImage('assets/images/logo.png'),
                    ),
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  child: const Image(
                    image: AssetImage('assets/images/newLogo.png'),
                  ),
                ),
              Container(
                height: 100.0,
                width: 200.0,
                child:
                FloatingActionButton(
                  //child: Icon(Icons.ac_unit),
                  child: Text("כניסה",style: TextStyle(fontSize: 20,color: Colors.black),),

                  backgroundColor: Colors.blue,
                  onPressed: () {
                    print("Next");
                    Navigator.of(context).popAndPushNamed('login');
                  },
                ),
              )


              ])
          )
      ),
    );



  }
}
