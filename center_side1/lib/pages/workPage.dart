import 'package:center_side/compount/drawer.dart';
import 'dart:convert';
import 'dart:io';
import 'package:center_side/compount/colors.dart';
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


  int i=0;
  List<Client> _clients = [];
  late Client _client;
  bool clientPage=false;
  String street="";


  void GetAddressFromLatLong() async{
    List<Placemark> placemark= await placemarkFromCoordinates(_client.lat,_client.long);
    print(placemark);
    setState(() {
      street=placemark.first.street.toString();
    });
  }


  void openCall(Client client){
    print("open call");
    setState(() {
      client.changeStatus(1);
      _client=client;
      clientPage=true;
      GetAddressFromLatLong();

    });}

  Widget callBox(Client client) => Container(
    height: 80,
    width:100,
    padding: const EdgeInsets.all(5),
    // color: Colors.blue,
    alignment: Alignment.center,
    decoration: BoxDecoration(
        color:(client.STATUS==0)? Colors.lightGreenAccent :(client.STATUS==1)?Colors.grey:Colors.red,
        border: Border.all(color: Colors.black,width: 10)
    ),
    child: IconButton(
      onPressed: () {
        if(client.STATUS==0)openCall(client);
        else{
          setState(() {
            _client=client;
            clientPage=true;
          });


        }

      },
      icon: Text("SOS call from ${client.userName}"),
      iconSize: 200,


    ),

  );



  Widget mangeCallsContainer()=>Container(
    height: 350,
    width: 500,
    padding: EdgeInsets.all(20),
    color: Colors.green,
    child: CallListView(),
  );
  Widget CallListView() => ListView(
    children: <Widget>[
      for(Client client in _clients)
        callBox(client),

    ],


  );


  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
        appBar: AppBar(
        title: Text("דף העבודה"),backgroundColor: Colors.blue,
        centerTitle: true,
        elevation: 6,
        ),
        drawer: MyDrawer(),
        body:Container(
          child: mangeCallsContainer(),
        )

        ));
  }
}
