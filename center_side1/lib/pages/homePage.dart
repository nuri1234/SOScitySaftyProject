import 'package:center_side/compount/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/material/app.dart';
import '../compount/texts.dart';
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
      child: Icon(Icons.language,color:Colors.black,size: 40,) ,
      itemBuilder: (context) => [
        PopupMenuItem(
          key: Key('hebrew'),
          child: const Text("עברית"),
          value: 1,
          onTap: (){print("change to hebrew");
          setState(() {
            my_texts.changeToHebrew();
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
              my_texts.changeToEnglish();
              data.language=0;
            });


          },
        ),
        PopupMenuItem(
          child: const Text("العربية"),
          value: 1,
          onTap: (){
            print("change to english");
            setState(() {
              my_texts.changeToArabic();
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
            title: Text(my_texts.Welcome,),titleTextStyle: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),
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
                    key: Key("login"),
                    //child: Icon(Icons.ac_unit),
                    child: Text(my_texts.SignIn,style: TextStyle(fontSize: 22,color: Colors.black,fontWeight: FontWeight.bold),),

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