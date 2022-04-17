import 'package:center_side/pages/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/app.dart';
import 'pages/drawer.dart';
import 'package:carousel_pro/carousel_pro.dart';

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
            title: Text("Home Page"),
            backgroundColor: Colors.blue,
            centerTitle: true,
            elevation: 6,
            actions: [
              IconButton(onPressed: () {}, icon: Icon(Icons.home)),
            ],
          ),
          drawer: MyDrawer(),
          body: Container(
              color: Colors.white,
              child: ListView(children: [
                Container(
                    height: 400,
                    width: double.infinity,
                    child: Container(
                      height: 400,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(
                              'assets/assets/logo.png'),
                          fit: BoxFit.fill,
                        ),
                        shape: BoxShape.circle,
                      ),
                    ),

                ),

              ])
          )
      ),
    );
  }
}
