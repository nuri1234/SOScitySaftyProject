import 'package:center_side/dbHelper/contacts_model.dart';
import 'package:center_side/pages/viewMessage.dart';
import 'package:center_side/pages/workerList.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'homePage.dart';

class ManagerPage extends StatefulWidget {
  const ManagerPage({Key? key}) : super(key: key);

  @override
  State<ManagerPage> createState() => _ManagerPageState();
}

class _ManagerPageState extends State<ManagerPage> {
  static final DateTime now=DateTime(DateTime.now().year,DateTime.now().month,DateTime.now().day);

  @override
  Widget build(BuildContext context) {
    return Row(
        children: <Widget>[
          Container(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.indigo[400],
                  borderRadius: BorderRadius.only(topRight: Radius.circular(50),bottomRight: Radius.circular(50))
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
                      Text("Workers List",style: TextStyle(fontSize: 20),),
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
                      Text("Messages List",style: TextStyle(fontSize: 20),),
                    ],)
                    ),
                  ),
                  Container(
                    height:300,
                  ),
                  Container(
                    margin: EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black,width:3),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: FlatButton(
                        onPressed: (){
                          Navigator.pushNamed(context, 'homePage');

                        }
                        , child: Row(children: [
                      Icon(Icons.logout),
                      Container(width:10,),
                      Text("logout",style: TextStyle(fontSize: 20),),
                    ],)
                    ),),
                ],
              ),
            ),
            width: MediaQuery.of(context).size.width * 0.25,
            color: Colors.white,


          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15.0,horizontal: 15.0),
            width: MediaQuery.of(context).size.width * 0.75,
            decoration: BoxDecoration(
              color: Colors.white,
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


    );
  }
}


