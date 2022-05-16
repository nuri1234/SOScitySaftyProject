import 'dart:convert';

import 'package:center_side/compount/texts.dart';
import 'dart:io';
import 'package:center_side/compount/colors.dart';
import 'package:center_side/dbHelper/contacts_managment.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../compount/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../compount/texts.dart';
import '../socket_class.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import '../dbHelper/message_model.dart';
import '../dbHelper/client_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:audioplayers/audioplayers.dart';
import '../dbHelper/audio_model.dart';
import 'package:center_side/uses/share_data.dart';
import 'package:center_side/dbHelper/contacts_model.dart';
import 'package:center_side/statistic/statistic_page.dart';


import 'dart:async';

class SOS extends StatefulWidget {
  const SOS({Key? key}) : super(key: key);

  @override
  State<SOS> createState() => _SOSState();
}

class _SOSState extends State<SOS> {
  int i=0;
  List<Client> clients = [];
  List<Client> my_clients = [];
  late Client chosen_client;
  bool clientMainContainerShow=false;
  bool clientChosen=false;
  final MapController _mapController=MapController();
  bool mapInitlaized=false;
  bool saveContainShow=false;
  bool _sendingMessage=false;
  final TextEditingController _message= TextEditingController();
  final TextEditingController _topic= TextEditingController();
  final TextEditingController _description= TextEditingController();
  TextAlign myTextAline=TextAlign.left;
  File? imageFile;
  late MessageModel newMsg;
  late MessageModel newMsgTest;
  bool imageShow=false;
  int photoIndex=0;
  int audioIndex=0;
bool signinEmit=false;
  int indexForClientCancel=0;
  static AudioCache player = AudioCache(prefix:'assets/sounds/');


  /////////functions//////////////
  void fillCalls() async{
    Client c1=Client(userName: "test1",
        phone: "0545567788",
        lat: 31.771959,
        long: 35.217018,
        socketId:"1",
        dateTime: DateTime.now());

  await GetAddressFromLatLong(c1) ;
    Client c2=Client(userName: "test2",
        phone: "0545567788",
        lat: 32.794044,
        long: 34.989571,
        socketId:"2",
        dateTime: DateTime.now());
   await GetAddressFromLatLong(c2) ;
    Client c3=Client(userName: "test3",
        phone: "0545567788",
        lat: 32.721105,
        long: 35.442834,
        socketId:"3",
        dateTime: DateTime.now());

   await GetAddressFromLatLong(c3) ;
    Client c4=Client(userName: "test4",
        phone: "0545567788",
        lat: 31.3925,
        long: 34.7544444440,
        socketId:"4",
        dateTime: DateTime.now());

    await GetAddressFromLatLong(c4) ;
    setState(() {
      clients.add(c1);
      clients.add(c2);
      clients.add(c3);
      clients.add(c4);
    });

  }
  void socketListner() {
    my_socket.socket.on("SOS_Call", (data) async{
      print("SOS Received");

      print(data);

      Client newClient= Client(
          userName: data['client']['userName'],
          phone:data['client']['phone'],
          lat: data['client']['lat'],
          long: data['client']['long'],
          socketId: data['client_socketId'],
          dateTime: DateTime.now()
      );

      await GetAddressFromLatLong(newClient);

      setState(() {
        clients.insert(0, newClient);
      });

      player.play('sosCall.wav',mode: PlayerMode.LOW_LATENCY,
          stayAwake: false);


    });

    my_socket.socket.on("SOS_Call_Respone", (client_socketId) async{
      print("SOS_Call_Respone");
      for(Client client in clients) {
        if (client.socketId == client_socketId) {
          setState(() {
            clients.remove(client);
          });
        }
      }
    });

    my_socket.socket.on("get_message",(data) async{
      MessageModel newMsgtoGet=MessageModel(senderType:data['msg']['senderType'] ,
          messageType: data['msg']['messageType'],
          message: data['msg']['message'],
          describe:data['msg']['describe'],
          time: data['msg']['time']);



      getNewMessage(data['sourceId'],newMsgtoGet);


    });

    my_socket.socket.on("message_send", (data) async{
      print("message_send");
     // addNewMsg();

    });

    my_socket.socket.on("cancel", (sourceId) async{
      print("cancel $sourceId");
      cancel(sourceId);
      print("after cancel");



    });

    my_socket.socket.on("clientDisconnected", (sourceId) async{
      print("clientDisconnected $sourceId");
     clientDisconnected(sourceId);

    });


    my_socket.socket.onDisconnect((_){
      print("Disconnect from server");
      signinEmit=false;
      setState(() {
        my_socket.isconnect=false;
      });
    });

    my_socket.socket.onConnect((data) {

      print("Connected to server2");
      if(!signinEmit){
        my_socket.socket.emit("centerSignin", my_socket.socket.id.toString());
        signinEmit=true;
      }

      setState(() {
        my_socket.isconnect=true;
      });
    });


  }
  void openCall(Client client){
    print("open call");
    setState(() {
      my_clients.insert(0, client);

      clients.remove(client);

    });
    if(client.STATUS!=2 && client.STATUS!=3){
      my_socket.socket.emit("SOS_Call_Respone",client.socketId);
      print("SOS_Call_Respone");

      setState(() {
        client.STATUS=1;

      });

    }







  }
  void endCall(Client client) {
    my_socket.socket.emit("end_call",client.socketId);
    setState(() {
      my_clients.remove(client);
    });

  }
  void cancel(sourceId) async{
    print("canceld");
    for(Client client in my_clients) {
      if (client.socketId == sourceId) {
        setState(() {
          client.STATUS = 2;
          client.boxColor = Colors.red;
          client.socketId=client.socketId+indexForClientCancel.toString();
          indexForClientCancel++;
        });
      }
    }
      for (Client client in clients) {
        if (client.socketId == sourceId) {
          setState(() {
            client.socketId = client.socketId + indexForClientCancel.toString();
            client.STATUS = 2;
            client.boxColor = Colors.red;});
          indexForClientCancel++; }
      }


  }
  void closeContact(Client client)async{
    await saveContact(client);

    setState(() {
      clientMainContainerShow=false;
      if(clientChosen) {
        chosen_client.boxColor=app_colors.clientNitral;
        if(chosen_client.STATUS!=1){
          chosen_client.boxColor=Colors.red;
        }


      }
    });
    endCall(client);

  }
  Future<void> saveContact(Client client) async {
    print("saveContact1");
   var contact=await newContact(data.userName,
        client.dateTime.toString(),
        client.userName, client.phone,
        client.city,client.street, client.topic,client.description);
    print("saveContact2");

    print(contact);

    print("done");


  }
  void clientDisconnected(sourceId) async{
    for(Client client in my_clients) {
      if (client.socketId == sourceId) {

        client.socketId=client.socketId+indexForClientCancel.toString();
        indexForClientCancel++;
        setState(() {
          client.boxColor = Colors.red;
          client.STATUS = 3;
        });
      }

      for (Client client in clients) {
        if (client.socketId == sourceId) {
          client.socketId=client.socketId+indexForClientCancel.toString();
          indexForClientCancel++;
          setState(() {
            client.STATUS = 3;
          });
        }
      }
    }

  }
  Future audioListner(MessageModel msg)async{

    msg.audio!.audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        msg.audio!.isPlaying=state==PlayerState.PLAYING;});
    });

    msg.audio?.audioPlayer.onDurationChanged.listen((newDuration) {
      print("newDuration");
      setState(() {msg.audio!.duration=newDuration;});

    });

    msg.audio?.audioPlayer.onAudioPositionChanged.listen((newPosition) {
      setState(() {msg.audio!.position=newPosition;});

    });

  }

  Future<void> closeAllContacts() async {
    print("closeAllContacts() 1");
    print(my_clients.length);
   for(Client c in my_clients){
     print("closeAllContacts() 2");
     await saveContact(c);
     print("closeAllContacts() 3");

     print("closeAllContacts() 4");
     my_socket.socket.emit("end_call",c.socketId);
   }
 //   endCall(c);

    print("closeAllContacts() after loop");
  }

  /////////////%%%%%%%%%/////////////
  void getNewMessage(String sourceId,MessageModel msg) async {

    print("get msg");
    if (msg.messageType == 1) {
      print("its photo type");
      final decodedBytes = base64Decode(msg.message);
      final directory = await getApplicationDocumentsDirectory();
      File fileImge = File('${directory.path}/testImage${photoIndex}.png');
      print(fileImge.path);
      fileImge.writeAsBytesSync(List.from(decodedBytes));
      msg.insert_path(fileImge.path);
      photoIndex++;
    }
    if(msg.messageType ==2){
      print("its audio");
      final decodedBytes = base64Decode(msg.message);
      final directory = await getApplicationDocumentsDirectory();
      File file= File('${directory.path}/testRecord${audioIndex}.mp3');
      print(file.path);
      file.writeAsBytesSync(List.from(decodedBytes));
      msg.insert_path(file.path);
      audioIndex++;
      msg.audio=AudioModel();
      audioListner(msg);
      msg.audio!.audioPlayer.setUrl(file.path,isLocal: true);
      await msg.audio!.audioPlayer.seek(msg.audio!.position);

    }


    for (Client client in my_clients) {
      if (client.socketId == sourceId) {
        setState(() {
          client.addMessage(msg);
          if(!clientMainContainerShow || client!=chosen_client)client.boxColor=app_colors.clientNewMessage;
        });
      }
    }

  }
  void sendMessage(Client client)async{
    print("sendMessage()");
    print(client.socketId);
    my_socket.socket.emit("message",{'msg':newMsg.toMap(),'targetId':client.socketId});
    setState(() {

      _sendingMessage=false;
      _message.text="";
      client.addMessage(newMsg);

    });

  }
  ///////////////%%%%%%%%////////////
void initLanguage(){
    setState(() {
      my_texts.changeToHebrew();
    });
}
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(my_socket.isconnect){
      signinEmit=true;
      my_socket.socket.emit("centerSignin", my_socket.socket.id.toString());

    }

    player.play('signIn.wav',mode: PlayerMode.LOW_LATENCY,
        stayAwake: false);
  //  if(hebrew=true)initLanguage();
    socketListner();

  // fillCalls();


  }



  @override
  void dispose()async {
    super.dispose();
    await closeAllContacts();
    if(my_socket.isconnect && signinEmit) {
      my_socket.socket.emit("centerSignout", my_socket.socket.id.toString());
    }



  }

/////////////////////
  Future<void> GetAddressFromLatLong(Client client) async{
    print(client.userName);
    List<Placemark> placemark;
 //   print("GetAddressFromLatLong");

  if(data.language==1){
  //  print("data.language==1");
    placemark= await placemarkFromCoordinates(client.lat,client.long,localeIdentifier:'he');}
    if(data.language==2){
   //   print("data.language==2");
      placemark= await placemarkFromCoordinates(client.lat,client.long,localeIdentifier:'ar');}
    else {
  //    print("data.language==0");
      placemark= await placemarkFromCoordinates(client.lat,client.long);
    }
   // print("hahahah");
  print(placemark);





    //print(placemark);
    print("hhhhhhhhhhhhhhhhhhhhhhhhh");
    client.street= placemark.first.street.toString();
    client.city= placemark.first.locality.toString();

  }
  Widget mapContainer(double lat, double long)=>Container(
    height: 300,
    width: 250,
    decoration: BoxDecoration(
        color: app_colors.background,
        borderRadius: BorderRadius.circular(10),

        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(8,5)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(-8,-5)
          ),
        ]
    ),
    padding: EdgeInsets.all(5),
    child: Container(
      height:300 ,
      width: 250,
      padding: EdgeInsets.all(0.5),
      child:
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              center: LatLng(lat,long),
              zoom: 13.0,
            ),
            layers: [
              TileLayerOptions(
                urlTemplate: "https://api.mapbox.com/styles/v1/citysafty/ckzr6bk8m007h15qpnoihdu94/tiles/256/{z}/{x}/{y}@2x?access_token=pk.eyJ1IjoiY2l0eXNhZnR5IiwiYSI6ImNrenI1YnhjYjBlMm4ycHBreGR6aWNscXgifQ.tB3OAhmkkVmY4ztI_cwG9Q",
                additionalOptions: {
                  'accessToken':'pk.eyJ1IjoiY2l0eXNhZnR5IiwiYSI6ImNrenI1YnhjYjBlMm4ycHBreGR6aWNscXgifQ.tB3OAhmkkVmY4ztI_cwG9Q',
                  'id': 'mapbox.mapbox-streets-v8'
                },
                attributionBuilder: (_) {
                  return Text("© OpenStreetMap contributors");
                },
              ),
              MarkerLayerOptions(
                markers: [
                  Marker(
                      width: 80.0,
                      height: 80.0,
                      point: LatLng(lat,long),
                      builder:(_){
                        return Icon(Icons.location_on,size: 50.0,color: Colors.red);
                      }
                  ),
                ],
              ),
            ],

          ),

    ),
  );
  /////////////Buttons//////////////////
  Widget statisticButton()=>IconButton(
    icon: const Icon(Icons.bar_chart_outlined,color: Colors.green,size: 40,),
    onPressed:(){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>(const Statistic())),).then((_) =>setState(() {}) );

    } ,
  );
  Widget languageButton()=> PopupMenuButton(
      color: Colors.grey,
      child: Icon(Icons.language,color:app_colors.languageButton,size: 40,) ,
      itemBuilder: (context) => [
        PopupMenuItem(
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
              data.language=1;
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
  Widget openCallButton(Client client)=>Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(8,5)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(-8,-5)
          ),
        ]
    ),
    child: ElevatedButton(
      onPressed: (){
        openCall(client);
      },
      child: const Icon(Icons.add,size: 20.0,),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary: app_colors.openCall,
        minimumSize:const Size(50.0, 50.0),

      ),
    ),
  );
  Widget ignoreCallButton(Client client)=>Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(8,5)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(-8,-5)
          ),
        ]
    ),
    child: ElevatedButton(
      onPressed: (){
        setState(() {
          clients.remove(client);
        });
      },
      child: const Icon(Icons.clear,size: 20.0,),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary: app_colors.ignoreCall,
        minimumSize:const Size(50.0, 50.0),

      ),
    ),
  );
  Widget hideClientContainerButton()=>Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(8,5)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(-8,-5)
          ),
        ]
    ),
    child: ElevatedButton(
      onPressed: (){
        setState(() {
          clientMainContainerShow=false;
          if(clientChosen){
            chosen_client.boxColor=app_colors.clientNitral;
          if(chosen_client.STATUS==2 || chosen_client.STATUS==3)chosen_client.boxColor=Colors.red;
          }

        });
      },
      child: const Icon(Icons.remove,size: 10.0,),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary: app_colors.hideClientContainer,
        minimumSize:const Size(40.0, 40.0),

      ),
    ),
  );
  Widget editContactButton(Client client)=>Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(8,5)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(-8,-5)
          ),
        ]
    ),
    child: ElevatedButton(
      onPressed: (){
        setState(() {
          saveContainShow=true;
        });
      },
      child: const Icon(Icons.edit,size: 20.0,),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary: Colors.blue,
        minimumSize:const Size(40.0, 40.0),

      ),
    ),
  );
  Widget closeContactButton(Client client)=>Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(8,5)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(-8,-5)
          ),
        ]
    ),
    child: ElevatedButton(
      onPressed: (){
        setState(() {
          closeContact(client);
        });
      },
      child: const Icon(Icons.clear,size: 20.0,),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary: Colors.red,
        minimumSize:const Size(40.0, 40.0),

      ),
    ),
  );
  Widget closeSaveButton()=>Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(8,5)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(-8,-5)
          ),
        ]
    ),
    child: ElevatedButton(
      onPressed: (){
        setState(() {
          saveContainShow=false;
        });
      },
      child: const Icon(Icons.clear,size: 20.0,),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary: Colors.red,
        minimumSize:const Size(40.0, 40.0),

      ),
    ),
  );
  Widget selectClientButton(Client client)=>IconButton(
    onPressed: () async
    {
        setState(() {
          if(clientChosen){
            chosen_client.boxColor=app_colors.clientNitral;
            if(chosen_client.STATUS!=1){
              chosen_client.boxColor=Colors.red;
            }
          }
          chosen_client=client;
          clientChosen=true;
          client.boxColor=app_colors.clientChosen;
          clientMainContainerShow=true;
          _topic.text=client.topic;
          _description.text=client.description;

          if(mapInitlaized) {
            _mapController.move(LatLng(client.lat,client.long), 13.0);
          } else {
            mapInitlaized=true;
          }

        });








    }
    ,
    icon:Column(children: [
      Text('${client.userName} ',style: const TextStyle(
          color: Colors.black,fontWeight: FontWeight.bold, fontSize:20
      ),),
      //Text(client.city ,style: TextStyle(fontSize: 15,color:app_colors.location,fontWeight:FontWeight.w900)),
     // Text(client.street ,style: TextStyle(fontSize: 20,color:app_colors.location,fontWeight:FontWeight.w900)),


      /*
      Align(alignment: const Alignment(0, -1),child: Text('${client.userName} ',style: const TextStyle(
          color: Colors.black,fontWeight: FontWeight.bold, fontSize: 15
      ),),),
      Align(alignment: const Alignment(0,-0.2),child: Text(client.city ,style: TextStyle(fontSize: 15,color:app_colors.location,fontWeight:FontWeight.w900)),),
      Align(alignment: const Alignment(0,1),child: Text(client.street ,style: TextStyle(fontSize: 20,color:app_colors.location,fontWeight:FontWeight.w900)),),
*/


    ],),
    iconSize: 200,


  );
  Widget changeTextAlineButton()=>Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(8,5)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(-8,-5)
          ),
        ]
    ),
    child: ElevatedButton(
      onPressed: () {
        print("change aline");
        print(myTextAline);
        if(myTextAline==TextAlign.left)
        {
          print("its left");
          setState(() {
            myTextAline=TextAlign.right;
          });
        }
        else
        {
          print("its right");
          setState(() {
            myTextAline=TextAlign.left;
          });
        }

        print("hereee");



      },
      child:  Icon(
        (myTextAline==TextAlign.left)?
        Icons.arrow_left:Icons.arrow_right_sharp ,
      size: 20.0,color: Colors.black,),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary:app_colors.background,
        minimumSize:const Size(40.0, 40.0),

      ),
    ),
  );
  Widget backButton()=>IconButton(
    icon: const Icon(Icons.logout,color: Colors.black,size: 40),
    onPressed:()async{

      print("befor pop");
      Navigator.pop(context);

    } ,
  );

  /////////////////////////////////////////////
/////////////////////////////////////////////
  /////////////////////////////////////////////////////
  Widget saveContainer(Client client)=>Container(
    height: 600,
    width: 600,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: app_colors.background,
        borderRadius: BorderRadius.circular(10),

        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(8,5)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(-8,-5)
          ),
        ]
    ),
    child: Stack(children: [
      Align(alignment: const Alignment(0,0),child:saveTextFieldsContainer(client),),
      Align(alignment: const Alignment(1,-1),child:closeSaveButton(),),
      Align(alignment: const Alignment(-1,1),child:changeTextAlineButton(),),
   ],),
  );
  Widget saveTextFieldsContainer(Client client)=>SingleChildScrollView(
    reverse: true,
    child: Container(
      height: 500,
      width: 500,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: app_colors.background,
          borderRadius: BorderRadius.circular(10),

          boxShadow:[
            BoxShadow(
                color: app_colors.buttom_shadow,
                blurRadius: 20,
                offset: Offset(8,5)

            ),
            BoxShadow(
                color: app_colors.buttom_shadow,
                blurRadius: 20,
                offset: Offset(-8,-5)
            ),
          ]
      ),
      child: Column(children: [
        topicRow(client),
        descriptionRow(client),

      ],),

    ),
  );
  Widget topicTextFieldContainer(Client client)=> Container(
    height: 50,
    width: 280,
    //  color: Colors.red,
      child: TextField(
        onChanged: (_topic){
          print(client.topic);
          setState(() {
          client.topic=_topic;


        });
          print(client.topic);
          },
        textAlign: myTextAline,
        controller:_topic,
        decoration:  InputDecoration(
          border:InputBorder.none,
          hintText: my_texts.topic,
          hintStyle: const TextStyle(color: Colors.black,fontSize: 30),
        ),
        style: const TextStyle(color: Colors.black,fontSize: 30),
      ),




  );
  Widget topicRow(Client client)=>Container(
    height: 80,
    width: 500,
  //  color:Colors.green,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            height:50,
            width:100 ,
         //   color: Colors.lightGreenAccent,
            child: Center(child: Text(my_texts.topic,style: const TextStyle(color: Colors.black,fontSize: 15,decoration: TextDecoration.underline,),))),
        topicTextFieldContainer(client),


    ],),
  );
  Widget descriptionRow(Client client)=>Container(
    height: 250,
    width: 500,
  //  color:Colors.lightGreen,
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
      Container(
            height:50,
            width:100 ,
            //color: Colors.lightGreenAccent,
            child: Center(child: Text(my_texts.description,style: const TextStyle(color: Colors.black,fontSize: 15,decoration: TextDecoration.underline,),))),
        descriptionTextFieldContainer(client),





      ],),
  );
  Widget descriptionTextFieldContainer(Client client)=> Container(
    height: 200,
    width: 280,
   // color: Colors.red,

    child:
      TextField(
        onChanged: (_description){
          print(client.description);
          setState(() {
            client.description=_description;


          });
          print(client.topic);
        },
        textAlign: myTextAline,

        controller:_description,
        decoration:  InputDecoration(
          border:InputBorder.none,
          hintText: my_texts.description,
          hintStyle: const TextStyle(color: Colors.black,fontSize: 30),
        ),
        style: const TextStyle(color: Colors.black,fontSize: 30),
      ),




  );
  ///////////////////////////////////////////////////////////////////////
  Widget addresDefaultTextStyle(Client client)=> DefaultTextStyle(  child:Text("${client.street} ${client.city}") ,style: TextStyle(fontSize: 30,color:app_colors.location,fontWeight:FontWeight.w900),);
  Widget detailBox(String varibal,String val)=>Container(
    height: 20,
    width: 200,
    //color: Colors.black12,
    child: Row(children: [
      if(data.language!=0)Text(val,style:GoogleFonts.abel(fontSize: 20,fontWeight: FontWeight.w800,color: app_colors.detail),),
      Text(varibal,style:GoogleFonts.abel(fontSize: 16,fontWeight: FontWeight.w800,color: Colors.black),),
      if(data.language==0)Text(val,style:GoogleFonts.abel(fontSize: 20,fontWeight: FontWeight.w800,color: app_colors.detail),),

    ],),

  );
  Widget detailsContainer(Client client)=>Container(
   // color: Colors.purpleAccent,
    height: 160,
    width: 300,
    padding: EdgeInsets.all(5),
    child: Stack(children: [
      Align(alignment: const Alignment(-1,-1),child: detailBox(my_texts.userName, client.userName)),
      Align(alignment: const Alignment(-1,-0.5),child: detailBox(my_texts.phone, client.phone),),
      Align(alignment: const Alignment(-1,0),child: detailBox(my_texts.date, client.dateTime.toString().substring(0, 10))),
      Align(alignment: const Alignment(-1,0.5),child: detailBox(my_texts.time, client.dateTime.toString().substring(10, 16))),

    ],),);
  Widget detailsContainer2(Client client)=>Container(
  //   color: Colors.purpleAccent,
    height: 160,
    width: 250,
    padding: EdgeInsets.all(5),
    child: Stack(children: [
      Align(alignment: const Alignment(1,-1),child: detailBox(my_texts.userName, client.userName)),
      Align(alignment: const Alignment(1,-0.5),child: detailBox(my_texts.phone, client.phone),),
      Align(alignment: const Alignment(1,0),child: detailBox(my_texts.date, client.dateTime.toString().substring(0, 10))),
      Align(alignment: const Alignment(1,0.5),child: detailBox(my_texts.time, client.dateTime.toString().substring(10, 16))),

    ],),);
  Widget statusContainer(Client client)=>Container(
      height: 50,
      width:300,
    //  color: Colors.white,
      child: Center(
        child: Stack(children: [
          if(client.STATUS==1) Text(my_texts.clientConnected,style: const TextStyle(fontSize: 30,color:Colors.green,fontWeight:FontWeight.w900)),
          if(client.STATUS==2)Text(my_texts.canceled,style: const TextStyle(fontSize: 30,color:Colors.red,fontWeight:FontWeight.w900)),
          if(client.STATUS==3) Text(my_texts.clientDisconnected,style: const TextStyle(fontSize: 30,color:Colors.red,fontWeight:FontWeight.w900)),


        ],),
      )
  );
  Widget clientContainer(Client client)=>Stack(children: [
    if(data.language!=0)Align(alignment: const Alignment(-1,-1),child: detailsContainer2(client),)
    else Align(alignment: const Alignment(-1,-1),child: detailsContainer(client),),

    Align(alignment: const Alignment(-1,0.7),child: mapContainer(client.lat,client.long),),
    Align(alignment: const Alignment(-1,-0.4),child:addresDefaultTextStyle(client),),
    Align(alignment: const Alignment(0.8,0.5),child:chatContainer(client),),
    Align(alignment: const Alignment(0.6,-1),child:statusContainer(client),),
    Align(alignment: const Alignment(-1,1),child:editContactButton(client),),
    Align(alignment: const Alignment(-0.8,1),child:closeContactButton(client),),
   if(saveContainShow) Align(alignment: const Alignment(0,0),child:saveContainer(client),),
    if(imageShow) Align(alignment:const Alignment(0,0),child:bigImageContainr(),),





  ],

);
  Widget clientMainContainer()=>Visibility(
    visible: clientMainContainerShow,
    maintainState: true,
    child: Container(
      height:630,
      width: 845,

      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: app_colors.background,
          borderRadius: BorderRadius.circular(10),

          boxShadow:[
            BoxShadow(
                color: app_colors.buttom_shadow,
                blurRadius: 20,
                offset: Offset(8,5)

            ),
            BoxShadow(
                color: app_colors.buttom_shadow,
                blurRadius: 20,
                offset: Offset(-8,-5)
            ),
          ]
      ),
      child: Stack(children: [
        if(clientChosen)Align(alignment: Alignment.center,child: clientContainer(chosen_client),),
        Align(alignment: Alignment.topRight,child: hideClientContainerButton(),),





      ],),

    ),
  );
  ///////////////////////////////////////////////////////
  Widget mangeCallsContainer()=>Container(
    height: 500,
    width: 800,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
        color: app_colors.background,
        borderRadius: BorderRadius.circular(10),

        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(8,5)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(-8,-5)
          ),
        ]
    ),
    child: CallListView(),
  );
  Widget callBox(Client client)=>Container(
  height: 100,
  width: 700,
  padding:const EdgeInsets.all(10),
  decoration: BoxDecoration(
      color: app_colors.boxBackground,
      borderRadius: BorderRadius.circular(10),

      boxShadow:[
        BoxShadow(
            color: app_colors.buttom_shadow,
            blurRadius: 20,
            offset: Offset(8,5)

        ),
        BoxShadow(
            color: app_colors.buttom_shadow,
            blurRadius: 20,
            offset: Offset(-8,-5)
        ),
      ]
  ),
  child: Stack(children: [
    Align(alignment: const Alignment(1, 0),child: Text('${client.userName} : ${client.city} ${client.street}',style: const TextStyle(
      color: Colors.black,fontWeight: FontWeight.bold, fontSize: 20
    ),),),
  Align(alignment: const Alignment(-1, 0),child:SizedBox(
    width: 130,
    //color: Colors.white,
    child: Row(
      children: [
        ignoreCallButton(client),
        const SizedBox(width: 10,),
        openCallButton(client),
      ],
    ),
  )),



  ],),


);
  Widget CallListView() => ListView(
    children: <Widget>[
      for(Client client in clients)
       Column(children: [SizedBox(height: 10,),callBox(client),],)


    ],


  );
  Widget mangeClientsContainer()=>Container(
    height: 630,
    width: 160,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: app_colors.background,
        borderRadius: BorderRadius.circular(10),

        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(8,5)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(-8,-5)
          ),
        ]
    ),
    child:myClientsListView(),
  );
  Widget clientBox(Client client)=>Container(
    height: 80,
    width: 270,
    padding:const EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: client.boxColor,
        borderRadius: BorderRadius.circular(10),

        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(8,5)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(-8,-5)
          ),
        ]
    ),
    child:selectClientButton(client),




  );
  Widget myClientsListView() => ListView(
    children: <Widget>[
      for(Client client in my_clients)
        Column(children: [SizedBox(height: 10,),clientBox(client),],)


    ],


  );
  ///////////////////////////////////////////////////
  Widget bigImageContainer()=>Container(
      height: 650,
      width: 650,
      // color: Colors.green,
      child: Stack(children: [
        Align(alignment: Alignment.center,child: Image.file(imageFile!) ,),
        Align(alignment: const Alignment(0.7,-1),child:
        Container(
          height: 80,
          width: 80,
          // color: Colors.yellow,
          alignment: Alignment(-1,-1),
          child: IconButton(
            highlightColor: Colors.pink,
            onPressed:() {
              print("pressed");
              setState(() {imageShow=false;});
            },






            icon: const Center(child: Icon(Icons.clear,color: Colors.red,size: 80,)),

          ),
        ),),


      ],)



  );
  ///////*******************///
  Widget audioPlaySlider(MessageModel msg)=>SizedBox(
    height: 50,
    width: 300,
    child: Slider(
        min: 0,
        max: msg.audio!.duration.inSeconds.toDouble(),
        value: msg.audio!.position.inSeconds.toDouble(),
        activeColor: Colors.green,
        inactiveColor: Colors.grey,
        onChanged: (value)async{
          final position=Duration(seconds: value.toInt());
          await msg.audio!.audioPlayer.seek(position);
          await msg.audio!.audioPlayer.resume();

        }),
  );
  String formatTime(Duration duration){
    String toDigits(int n)=>n.toString().padLeft(2,'0');
    final Seconds=toDigits(duration.inSeconds.remainder(60));
    final minutes=toDigits(duration.inMinutes.remainder(60));
    final hours=toDigits(duration.inHours);
    return [
      if(duration.inHours>0) hours,
      minutes,
      Seconds,
    ].join(':');

  }
  Widget recordPlayStateShowContainer(Duration dr , Duration ps)=>Container(

    height: 50,
    width: 250,
    child: Stack(children: [
      Align(alignment: Alignment.centerLeft,child:Text(formatTime(ps)) ,),
      Align(alignment: Alignment.centerRight,child:  Text(formatTime(dr-ps)),),

    ],),
  );
  Widget playRecordButton(MessageModel msg)=>Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 100,
              offset: const Offset(8,5)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 100,
              offset: const Offset(-8,-5)
          ),
        ]
    ),
    child: ElevatedButton(
      onPressed: () async{

        if(msg.audio!.isPlaying){
          await msg.audio!.audioPlayer.pause();
        }
        else{
          //  String url='https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3';
          msg.audio!.audioPlayer.resume();

        }


      },
      child: Icon(msg.audio!.isPlaying? Icons.pause :Icons.play_arrow,size: 8,),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary: Colors.green,
        minimumSize:const Size(30, 30),

      ),
    ),
  );
  Widget audioBox(MessageModel message) => SizedBox(
    height: 80,
    // color: Colors.black38,
    child: Stack(children: [
      Align(alignment: const Alignment(0,-1) ,child: audioPlaySlider(message),),
      Align(alignment: const Alignment(-1,-1) ,child: playRecordButton(message),),
      Align(alignment:const Alignment(0,0)  ,child:recordPlayStateShowContainer(message.audio!.duration,message.audio!.position)),


    ],),
  );
  Widget imageBox(MessageModel message) => Container(
    child: Column(children: [
      Container(
        decoration: BoxDecoration(
            color: app_colors.background,
            borderRadius: BorderRadius.circular(10),

            boxShadow:[
              BoxShadow(
                  color: app_colors.buttom_shadow,
                  blurRadius: 20,
                  offset: Offset(8,5)

              ),
              BoxShadow(
                  color: app_colors.buttom_shadow,
                  blurRadius: 20,
                  offset: Offset(-8,-5)
              ),
            ]
        ),
        width: 200,
        height: 200,

        alignment: Alignment.center,
        child: IconButton(
          onPressed: (){
            setState(() {
              imageFile=File(message.get_path());
              imageShow=true;
            });

          },
          icon:Image(image:FileImage(File(message.get_path())) ,) ,
          iconSize: 200,

        ),),
      const SizedBox(height: 10,),
      if(message.describe!="non")Text(message.describe),



    ],),

  );
  Widget bigImageContainr()=>Container(
      height: 650,
      width: 650,
      // color: Colors.green,
      child: Stack(children: [
        Align(alignment: Alignment.center,child: Image.file(imageFile!) ,),
        Align(alignment: const Alignment(0.7,-1),child:
        Container(
          height: 80,
          width: 80,
          // color: Colors.yellow,
          alignment: Alignment(-1,-1),
          child: IconButton(
            highlightColor: Colors.pink,
            onPressed:() {
              print("pressed");
              setState(() {imageShow=false;});
            },






            icon: const Center(child: Icon(Icons.clear,color: Colors.red,size: 80,)),

          ),
        ),),


      ],)



  );
  //////////
  Widget chatSendContainer(Client client)=>Container(
    height:70,
    width: 500,
    decoration: BoxDecoration(
        color: app_colors.messageInputFill,
        borderRadius: BorderRadius.circular(90),
        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(8,5)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(-8,-5)
          ),
        ]
    ),
    padding:const EdgeInsets.all(1),
    child: Stack(children: [
      Align(alignment:const Alignment(-0.6,0),child:chatSendTextFieldContainer() ,),
      Align(alignment:const Alignment(1,0),child:sendMessageButton(client),),

    ],),

  );
  Widget chatSendTextFieldContainer()=> Container(
    height: 70,
    width: 320,
    //  color: Colors.red,
    padding:const EdgeInsets.all(0),
    child: Center(
      child: TextField(
        onChanged: (_message){setState(() {

        });},
        controller: _message,
        decoration: const InputDecoration(
          border:InputBorder.none,
          hintText: "message",
          hintStyle: TextStyle(color: Colors.black),
        ),
        style: const TextStyle(color: Colors.black),
      ),
    ),



  );
  Widget messagesContainer(Client client)=>Container(
    height: 450,
    width: 400,
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
        color: app_colors.chatmessages,
        borderRadius: BorderRadius.circular(10),
        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(8,5)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: Offset(-8,-5)
          ),
        ]
    ),
    child: messageListView(client),



  );
  Widget messageBox(MessageModel msg) => Container(
    width: 350,
    //color: Colors.pink,
    alignment: Alignment.topLeft,
    child: Text(
      msg.message,
      style: TextStyle(
        color: (msg.senderType==0)?Colors.blue:Colors.black,
        fontSize: 25,
        fontWeight: FontWeight.bold,
      ),

    ),
  );
  Widget messageDetails(Client client,MessageModel msg)=>Row(
      children: [
        Text(msg.time,style:const TextStyle(color: Colors.green,fontSize: 15,fontWeight: FontWeight.bold),),
        if(msg.senderType==0)Text("${client.userName} >>",style:const TextStyle(color: Colors.blue,fontSize: 15,fontWeight: FontWeight.bold),),
        if(msg.senderType==1)const Text("Service representative>>",style:TextStyle(color: Colors.orangeAccent,fontSize: 15,fontWeight: FontWeight.bold),),

      ]);
  Widget messageListView(Client client) => ListView(
    children: <Widget>[
      for(MessageModel msg in client.messages)  Column(children: [
        messageDetails(client,msg),
        if(msg.messageType==0)messageBox(msg)
        else if(msg.messageType==1) imageBox(msg)

        else audioBox(msg)

      ],)


    ],
  );
  Widget sendMessageButton(Client client)=>Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(100),
        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: const Offset(8,5)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: const Offset(-8,-5)
          ),
        ]
    ),
    child: ElevatedButton(
      onPressed: (){
        if(_message.text.isNotEmpty) {
          setState(() {
            _sendingMessage=true;
          });
          newMsg=MessageModel(senderType: 1,
              messageType: 0,
              message: _message.text,
              describe: "non",
              time:  DateTime.now().toString().substring(10, 16));
          sendMessage(client);


        }

      },
      child:_sendingMessage? const CircularProgressIndicator(color: Colors.white, ): const Icon(Icons.send,size: 10,),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary:(my_socket.isconnect && (_message.text.isNotEmpty))? Colors.lightGreenAccent:Colors.grey,
        minimumSize: const Size(40, 40),

      ),
    ),
  );
  Widget chatContainer(Client client)=>SingleChildScrollView(
    reverse: true,
    child: Container(
      height:550,
      width: 440,
      decoration: BoxDecoration(
          color:app_colors.chatbackground,
          borderRadius: BorderRadius.circular(10),
          boxShadow:[
            BoxShadow(
                color: app_colors.buttom_shadow,
                blurRadius: 20,
                offset: Offset(8,5)

            ),
            BoxShadow(
                color: app_colors.buttom_shadow,
                blurRadius: 20,
                offset: Offset(-8,-5)
            ),
          ]
      ),
      padding: const EdgeInsets.all(10),
      child: Stack(
        children: [
          Center(
            child: Column(children: [
              messagesContainer(client),
              const SizedBox(height: 5,),
              chatSendContainer(client),
            ],

            ),
          ),

        ],
      ),


    ),
  );
  /////*********************///////
  Widget connectedToServer()=> Text(
    my_texts.connectedToServer,
    style:const TextStyle(
      fontSize:20,
      color:Colors.greenAccent,
      fontWeight: FontWeight.w800,
      shadows: <Shadow>[
        Shadow(
          offset: Offset(0, 0),
          blurRadius: 3.0,
          color: Color.fromARGB(500, 7, 0, 0),
        ),
        Shadow(
          offset: Offset(0.0, 10.0),
          blurRadius: 8.0,
          color: Color.fromARGB(125, 0, 0, 255),
        ),
      ],
    ),

  );
  Widget notConnectedToServer()=> Text(
    my_texts.NotconnectedToServer,
    style:const TextStyle(
      fontSize:20,
      color:Colors.red,
      fontWeight: FontWeight.w800,
      shadows: <Shadow>[
        Shadow(
          offset: Offset(0, 0),
          blurRadius: 3.0,
          color: Color.fromARGB(500, 7, 0, 0),
        ),
        Shadow(
          offset: Offset(0.0, 10.0),
          blurRadius: 8.0,
          color: Color.fromARGB(125, 0, 0, 255),
        ),
      ],
    ),

  );
  Widget mainStack()=> Stack(children: [
    Align(alignment: const Alignment(-0.7,0),child: mangeCallsContainer(),),
    Align(alignment: const Alignment(1,0),child: mangeClientsContainer(),),

    if(my_socket.isconnect) Align(alignment: const Alignment(0.0,-1),child:connectedToServer())
    else Align(alignment: const Alignment(0.0,-1),child:notConnectedToServer()),
    Align(alignment: const Alignment(-1,0),child:clientMainContainer()),





  ],

  );


  //////////////////////////////////////////


  /////////////////////
  Widget rahatLogo()=>Container(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      child: const Image(
        image: AssetImage('assets/images/rahatLogo2.png'),
        height: 100,
        width:100,
      )

  );


  Widget SOSLogo()=>Container(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      child: const Image(
        image: AssetImage('assets/images/logo.png'),
        height: 100,
        width:100,
      )

  );


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: app_colors.background,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: app_colors.app_bar_background,
          title://SOSLogo(),
           rahatLogo(),
        centerTitle: true,
          actions: [ backButton(),statisticButton(),const SizedBox(width: 10,),languageButton(),

          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: mainStack(),
        )

    );
  }
}
