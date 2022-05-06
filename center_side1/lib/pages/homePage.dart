import 'package:center_side/compount/center_text.dart';
import 'package:center_side/compount/colors.dart';
import 'package:center_side/compount/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/app.dart';
import '../compount/drawer.dart';
import 'package:center_side/pages/signin_page.dart';
import 'package:center_side/uses/share_data.dart';

class HomePage extends StatefulWidget {
  State<StatefulWidget> createState() {
    return HomeState();
  }
}

class HomeState extends State<HomePage> {

  Widget languageButton()=> PopupMenuButton(
      color: Colors.grey,
      child: Icon(Icons.language,color:app_colors.languageButton,size: 40,) ,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Text("עברית"),
          value: 1,
          onTap: (){print("change to hebrow");
          setState(() {
            my_texts2.changeToHebrew();
            data.language=1;
          });


          },
        ),
        PopupMenuItem(
          child: const Text("English"),
          value: 1,
          onTap: (){
            print("change to english");
            setState(() {
              my_texts2.changeToEnglish();
              data.language=0;
            });


          },
        ),
        PopupMenuItem(
          child: const Text("عربيه"),
          value: 1,
          onTap: (){
            print("change to english");
            setState(() {
              my_texts2.changeToArabic();
              data.language=2;
            });


          },
        ),
      ]
  );


  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: Text(my_texts2.Welcome),
            actions: [
              languageButton()

            ],
            backgroundColor: app_colors.app_bar_background,
            centerTitle: true,
            elevation: 6,
            automaticallyImplyLeading: false,
          ),

          body: Container(
              color: app_colors.background,
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
                    child: Text(my_texts2.SignIn,style: TextStyle(fontSize: 20,color: Colors.black),),

                    backgroundColor: app_colors.app_bar_background,
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