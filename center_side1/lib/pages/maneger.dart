import 'package:center_side/compount/center_text.dart';
import 'package:center_side/compount/colors.dart';
import 'package:center_side/compount/texts.dart';
import 'package:center_side/dbHelper/contacts_model.dart';
import 'package:center_side/pages/viewMessage.dart';
import 'package:center_side/pages/workerList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:center_side/pages/homePage.dart';

import 'homePage.dart';

class ManagerPage extends StatefulWidget {
  const ManagerPage({Key? key}) : super(key: key);

  @override
  State<ManagerPage> createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  TextEditingController _textFieldController = TextEditingController();
  late String _phoneNum="106";



  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child:Row(
            children: <Widget>[
              Container(
                child: Container(
                  decoration: BoxDecoration(
                      color: app_colors.app_bar_background,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(50),bottomLeft: Radius.circular(50))
                  ),
                  child: ListView(
                    children: [
                      Container(height: 100,),
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
                          Text(my_texts2.WorkersList,style: TextStyle(fontSize: 20),),
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
                          Text(my_texts2.Drafts,style: TextStyle(fontSize: 20),),
                        ],)
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.all(20),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black,width:3),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        child: FlatButton(
                            onPressed: (){
                              showDialog(
                                context: context,
                                builder: (context){
                                  return AlertDialog(
                                    title: Text(my_texts2.AddphoneNumber),
                                    content: TextField(
                                      decoration: InputDecoration(
                                          hintText: "phone",
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: const BorderSide(color:Colors.black, width: 5.0),
                                            borderRadius: BorderRadius.circular(20.0),
                                          ),
                                          focusedBorder:OutlineInputBorder(
                                            borderSide: const BorderSide(color:Colors.black, width: 2.0),
                                            borderRadius: BorderRadius.circular(20.0) ,

                                          ),
                                          fillColor: Colors.white,
                                          filled: true,
                                          prefix: const Padding(
                                            padding: EdgeInsets.all(4),
                                          ) ),
                                      maxLines: 1,
                                      maxLength: 20,
                                      controller: _textFieldController,
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        color: Colors.red,
                                        textColor: Colors.white,
                                        child: Text(my_texts2.Cancel),
                                        onPressed: () {
                                            Navigator.pop(context);
                                        },
                                      ),
                                      FlatButton(
                                        color: Colors.green,
                                        textColor: Colors.white,
                                        child: Text(my_texts2.OK),
                                        onPressed: () {
                                          _phoneNum=_textFieldController.text;
                                          setState(() {
                                            if(_textFieldController.text!="")
                                              Navigator.pop(context);
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                }
                              );
                              print(_phoneNum);
                            }
                            , child: Row(children: [
                          Icon(Icons.phone),
                          Container(width:10,),
                          Text(my_texts.phone,style: TextStyle(fontSize: 20),),
                        ],)
                        ),
                      ),

                      Container(
                        height:200,
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
                          Text(my_texts2.Logout,style: TextStyle(fontSize: 20),),
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