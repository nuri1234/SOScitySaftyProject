import 'package:path_provider/path_provider.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import '../dbHelper/call_class.dart';
import '../dbHelper/calldb_management.dart';
import 'package:center_side/dbHelper/imagesdb_management.dart';
import 'package:crossplat_objectid/crossplat_objectid.dart';
import 'dart:convert';
import 'dart:async';
import 'dart:io';



class connectionPage extends StatefulWidget {
  const connectionPage({Key? key}) : super(key: key);

  @override
  State<connectionPage> createState() => _connectionPageState();
}

class _connectionPageState extends State<connectionPage> {
  late IO.Socket socket;
  late File fileImg;
  bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //getImag();
    connect();
  }

  void connect() {
    socket = IO.io("http://192.168.1.233:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.onConnect((data) {
      print("Connected");
      socket.emit("centerSignin",1);
      socket.on("message", (msg) {
        print(msg);
      });

      socket.on("SOS", (msg){
        print("SOS alert here");
        print(msg);


      });


    });
    print(socket.connected);
    print("here99");



  }

  @override
  void dispose() {
    socket.disconnect();
    super.dispose();
  }

  void sendMessage(String message, int sourceId, int targetId) {
    socket.emit("message",
        {"message": message, "sourceId": sourceId, "targetId": targetId});
    print("send");
  }


  void SoS() {
    socket.emit("SOS",
        {"call.toMap()"});
    print("send");
  }


  void getImag() async{


   var imgs= await searchImages("ObjectId(\"6245f2ba87c326dc4d3d65ed\")");

   print(imgs.base64image1);
   final decodedBytes = base64Decode(imgs.base64image1);
   final directory = await getApplicationDocumentsDirectory();

   fileImg = File('${directory.path}/testImage.png');

   print(fileImg.path);

   fileImg.writeAsBytesSync(List.from(decodedBytes));






   



  }

  Widget photo()=>Container(
    padding: const EdgeInsets.all(5),
    color: Colors.black54,
    child: Image.file(fileImg),
  );


  @override
  Widget build(BuildContext context) {
    int i=0;
    return Scaffold(


        body: Center(
          child: Column(
            children: [
              IconButton(onPressed: ()async{
                getImag();
                i++;},
                icon: const Icon(Icons.volume_up),
              ),


            ],
          ),
        ));
  }
}
