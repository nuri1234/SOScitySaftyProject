import 'package:center_side/compount/center_text.dart';
import 'package:center_side/compount/colors.dart';
import 'package:center_side/compount/texts.dart';
import 'package:center_side/dbHelper/contacts_model.dart';
import 'package:center_side/pages/viewMessage.dart';
import 'package:center_side/pages/workerList.dart';
import 'package:center_side/sos/sos_main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:center_side/pages/homePage.dart';
import 'package:center_side/uses/share_data.dart';
import 'homePage.dart';

class ManagerPage extends StatefulWidget {
  const ManagerPage({Key? key}) : super(key: key);

  @override
  State<ManagerPage> createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  TextEditingController _textFieldController = TextEditingController();
  late String _phoneNum="106";

  Widget languageButton()=> PopupMenuButton(
      color: Colors.grey,
      child: Icon(Icons.language,size: 40,),
      //color:app_colors.languageButton,size: 40,) ,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Text("עברית"),
          value: 1,
          onTap: (){print("change to hebrow");
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
          child: const Text("عربيه"),
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
    return Scaffold(
        body:Row(
            children: <Widget>[
              Container(
                child: Container(
                  decoration: BoxDecoration(
                      color: app_colors.app_bar_background,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(50),bottomRight: Radius.circular(50))
                  ),
                  child: ListView(
                    children: [
                      Container(
                        alignment: Alignment.topLeft,
                        margin: EdgeInsets.only(left: 20,right: 20,top: 20),
                        child:languageButton(),),
                      Container(height:20,),
                      Container(
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black,width:3),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: FlatButton(
                            onPressed: (){
                              Navigator.pushNamed(context, 'workerList');                            }
                            , child: Row(children: [
                          Icon(Icons.person),
                          Container(width:10,),
                          Text(my_texts.WorkersList,style: TextStyle(fontSize: 20),),
                        ],)
                        ),),
                      Container(
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black,width:3),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: FlatButton(
                            onPressed: (){
                              Navigator.pushNamed(context, 'messageList');                        }
                            , child: Row(children: [
                          Icon(Icons.drafts),
                          Container(width:10,),
                          Text(my_texts.Drafts,style: TextStyle(fontSize: 20),),
                        ],)
                        ),
                      ),
                      Container( margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black,width:3),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: FlatButton(
                            onPressed: (){
                              Navigator.pushReplacement(context,MaterialPageRoute(builder:(context){return SOS();}));
                            }
                            , child: Row(children: [
                          Icon(Icons.message),
                          Container(width:10,),
                          Text(my_texts.SOS,style: TextStyle(fontSize: 20),),
                        ],)
                        ),),

                      Container(
                        height:220,
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black,width:3),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: FlatButton(
                            onPressed: (){
                              Navigator.pushReplacement(context,MaterialPageRoute(builder:(context){return HomePage();}));
                            }
                            , child: Row(children: [
                          Icon(Icons.logout),
                          Container(width:10,),
                          Text(my_texts.Logout,style: TextStyle(fontSize: 20),),
                        ],)
                        ),),
                    ],
                  ),
                ),
                width: MediaQuery.of(context).size.width * 0.25,
                color: app_colors.background,


              ),
              Container(
                padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
                width: MediaQuery.of(context).size.width * 0.75,
                decoration: BoxDecoration(
                  color: app_colors.background,
                  //border: Border.all(color: Colors.black,width: 7),
                  // borderRadius: BorderRadius.only(topLeft: Radius.circular(50),bottomLeft: Radius.circular(50))
                ),
                child: ListView(children: [
                  Container(
                    height: 200,
                    // width: double.infinity,
                    child: const Image(
                      image: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                  Container(
                    height: 200,
                    child: const Image(
                      image: AssetImage('assets/images/newLogo.png'),
                    ),
                  ),

                ]),
              ),


            ]


        )
    );
  }
}