import 'package:center_side/compount/drawer.dart';
import 'dart:convert';
import 'dart:io';
import 'package:center_side/compount/colors.dart';
import 'package:center_side/dbHelper/mng_managment.dart';
import 'package:center_side/pages/maneger.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:center_side/compount/texts.dart';
import 'package:center_side/socket_class.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:center_side/dbHelper/message_model.dart';
import 'package:center_side/dbHelper/client_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart';




class WorkPage extends StatefulWidget {
  const WorkPage({Key? key}) : super(key: key);

  @override
  State<WorkPage> createState() => _WorkPageState();
}


class _WorkPageState extends State<WorkPage> {
  TextEditingController _textFieldController = TextEditingController();

  void initState() {
    // TODO: implement initState
    super.initState();
    _textFieldController.text="";
  }
  void chekMng()async{
    var mng=await searchMng(_textFieldController.text);
    if(mng.userName==_textFieldController.text){
      print("ok");
      Navigator.of(context).push(MaterialPageRoute(
          builder: (c) => Scaffold(body: Text('maneger'))
      ));
    }
    else print("no match");

    if(mng==null) print("user not found");
  }
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
        appBar: AppBar(
          title: Text("דף העבודה"),
          backgroundColor: Colors.blue,
          centerTitle: true,
          elevation: 6,

          actions: [
            IconButton(icon: Icon(Icons.home),onPressed: (){
              Navigator.of(context).popAndPushNamed('homePage');
            },),
            IconButton(icon: Icon(Icons.admin_panel_settings),onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text('TextField in Dialog'),
                      content: TextField(
                        decoration: InputDecoration(
                            hintText: "userName",
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
                          child: Text('CANCEL'),
                          onPressed: () {
                            setState(() {
                              Navigator.pop(context);
                            });
                          },
                        ),
                        FlatButton(
                          color: Colors.green,
                          textColor: Colors.white,
                          child: Text('OK'),
                          onPressed: () {
                            chekMng();
                          },
                        ),
                      ],
                    );
                  });
            },)
          ],

        ),

        body:Center(
        child:Text("Manger Page")
    ),
       ),


        );
  }
}
