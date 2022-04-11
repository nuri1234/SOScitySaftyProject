import 'dart:convert';
import 'package:client_side/camera_page.dart';
import 'package:client_side/dbHelper/calldb_management.dart';
import 'package:client_side/dbHelper/images_class.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'colors.dart';
import 'texts.dart';
import 'map_class.dart';
import 'dart:async';
import 'camera_page.dart';
import 'images.dart';
import 'dart:io';
import 'dbHelper/imagesdb_management.dart';
import 'dbHelper/images_class.dart';
import 'dbHelper/call_class.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'local_data.dart';
import 'socket_class.dart';
import 'registration_page.dart';
import 'dbHelper/message_model.dart';

class Sos extends StatefulWidget {
  const Sos({Key? key}) : super(key: key);

  @override
  _SosState createState() => _SosState();
}

class _SosState extends State<Sos> {

  late final MapController _mapController;
  List<String> _paths=my_images.getPaths();
  int img_size=0;
  late Call call;
  final TextEditingController _describe= TextEditingController();
  final TextEditingController _message= TextEditingController();
  bool _description=false;
  bool _sentSosCall=false;
  bool _sendingMessage=false;
  bool _showState=false;
  bool _receive=false;
  bool _sendRequestforChat=false;
  late String chatTargetSocket;
  bool _cancel_button=false;
  late MessageModel newMsg;
  late MessageModel newMsgTest;
  List<MessageModel> messages = [];
  bool chatOpen=false;




  ////////////////////////Functions/////////////////////////////////////////////
  void makeCall()async{
    setState(() {
     _showState=true;
     _cancel_button=true;
    });

    if(_paths.isNotEmpty) {
      ImagesClass imgs=await makeimagesClass() as ImagesClass;
      call=await newCall(data.user_name, data.phone,map_class.lat, map_class.long, _describe.text,_paths.length ,imgs.id.toHexString());
    }
    else{
      call=await newCall(data.user_name, data.phone,map_class.lat, map_class.long,_describe.text,0,"non");
    }

    SoS(call);

  }
  void Signin(Call call){
    my_socket.socket.emit("clientSignin",call.id);

  }
  void SoS(Call call) {
    my_socket.socket.emit("SOS",
        {call.toMap()});
    print("send");
  }
  void onReceive(){
    setState(() {
      _receive=true;

    });



  }
  void onAccept(){
    setState(() {
      my_images.restart();
      _paths=my_images.getPaths();
      _describe.text="";
      int img_size=0;
      _sentSosCall=false;
      _showState=false;
      _receive=false;
      _cancel_button=false;
    });


  }
  void sos_send(){
   setState(() {
     _sentSosCall=true;
   });

  }
  void socketListner() {
    my_socket.socket.on("sos_send", (msg){
      print("sos_send");
      print(msg);
      sos_send();});

    my_socket.socket.on("get_message", (data){
      print("get_message");
      getMessage(data['msg']);
    });
    my_socket.socket.on("chatReqestRespons", (socketId){
      print("chatReqestRespons $socketId");
      setState(() {
        chatTargetSocket=socketId;
      });
    });

    my_socket.socket.on("message_send", (msg){
      print("message_send");
      print(msg);
      setState(() {
        messages.add(newMsg);
        _sendingMessage=false;
        _message.text="";
      });

    });

    my_socket.socket.onDisconnect((_){
      print("Disconnect from server");
      setState(() {
        my_socket.isconnect=false;
      });
    });


    my_socket.socket.onConnect((data) {
      print("Connected to server");
      my_socket.socket.emit("clientSignin", my_socket.socket.id);
      my_socket.isconnect = true;
      setState(() {
        my_socket.isconnect=true;
      });
    });



  }
  void cancel(){
    my_socket.socket.emit("cancel",call.id);
    setState(() {
       _sentSosCall=false;
      _showState=false;
      _receive=false;
       _cancel_button=false;



    });

  }
void getMessage( msg){
    print("getMessage( msg)");
    print(msg);
  // MessageModel newmsg=MessageModel(senderType: msg['type'], message: msg['message'], time: msg['time']);
   setState(() {
    // messages.add(newmsg);
   });


}

  void sendMessage(){

    chatTargetSocket=my_socket.socket.id.toString();
    print("send message");
    setState(() {
      _sendingMessage=true;

    });
     /*newMsg=MessageModel(
        senderType: 0,
        message: _message.text,
        time: DateTime.now().toString().substring(10, 16))
    */

    if(chatTargetSocket==null){my_socket.socket.emit("chatReqest", {newMsg.toMap()});}
     else{ my_socket.socket.emit("message", {'msg':newMsg.toMap(),'targetId':chatTargetSocket});}

  }

  void Testchat(){
    chatTargetSocket=my_socket.socket.id.toString();
   /* newMsgTest=MessageModel(
        senderType: 1,
        message: _message.text,
        time: DateTime.now().toString().substring(10, 16));*/

    my_socket.socket.emit("message", {'msg':newMsgTest.toMap(),'targetId':chatTargetSocket});



  }


  @override
  void initState() {
    super.initState();
    print("init sos page");
    _mapController = MapController();
    if(_paths.isNotEmpty)img_size=_paths.length;
    else img_size=0;
    data.getData();
    socketListner();





    found_my_place_on_map();
  }

  Future<ImagesClass> makeimagesClass() async {
    print(_paths.length);
    for(String p in _paths){
      File f= File(p);
      List<int> imageBytes = f.readAsBytesSync();
      String base64Image = base64Encode(imageBytes);
      my_images.putbase64EncodeImages(base64Image);
    }
    return await newImages();
  }
  void found_my_place_on_map() async{
    Position position=await _determinePosition();
    setState(() {
      map_class.lat=position.latitude;
      map_class.long=position.longitude;
      _mapController.move(LatLng(map_class.lat,map_class.long), 13.0);

    });



  }
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }
  Future<void> GetAddressFromLatLong(Position position) async{
    List<Placemark> placemark= await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemark);




  }
  ///////////////////////EN DFunctions///////////////////////////////////////

////////////////////////BUTTONSSSS//////////////////////////////////////////
  Widget Camera_Button()=>Container(
    decoration: BoxDecoration(
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
    child: ElevatedButton(
      onPressed: (){
        setState(() {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>const camera_page()));
        });
      },
      child: Icon(Icons.camera_alt,size: 40.0,),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary: app_colors.cmera_button,
        minimumSize: Size(70.0, 70.0),

      ),
    ),
  );
  Widget SOS_Button()=>Container(
    decoration: BoxDecoration(
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

    child: SizedBox(height: 100.0,
      width: 100.0,
      child:
      FloatingActionButton(
        //child: Icon(Icons.ac_unit),
        child: Text("SOS",style: TextStyle(fontSize: 40),),

        backgroundColor: my_socket.isconnect? app_colors.sos_button: app_colors.sos_disablbutton,
        onPressed: () {
          print("SOS button presswd");
          if(my_socket.isconnect)makeCall();

        },
      ),
    ),
  );
  Widget CancelButton()=>Container(
    decoration: BoxDecoration(
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

    child: SizedBox(height: 100.0,
      width: 100.0,
      child:
      FloatingActionButton(
        //child: Icon(Icons.ac_unit),
        child: Icon(Icons.clear,size:80,),
        backgroundColor: app_colors.sos_button,
        onPressed: () {
          print("Cncel button presswd");
          cancel();
        },
      ),
    ),
  );
  Widget descriptionButton()=>Container(
    decoration: BoxDecoration(
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
    child: ElevatedButton(
      onPressed: (){

        setState(() {
          if(_description) _description=false;
          else _description=true;
        });
      },
      child: Icon(Icons.drive_file_rename_outline,size: 40.0,),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary: app_colors.description_button,
        minimumSize: Size(70.0, 70.0),

      ),
    ),
  );
  Widget chatButton()=>Container(
    decoration: BoxDecoration(
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
    child: ElevatedButton(
      onPressed: (){
        setState(() {
          chatOpen=true;
        });

      },
      child: const Icon(Icons.chat,size: 40.0,),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary:app_colors.chat_button,
        minimumSize: Size(70.0, 70.0),

      ),
    ),
  );
  Widget TestButton()=>Container(
    decoration: BoxDecoration(
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
    child: ElevatedButton(
      onPressed: (){
        Testchat();

      },
      child: const Icon(Icons.send_outlined,size: 40.0,),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary:app_colors.chat_button,
        minimumSize: Size(70.0, 70.0),

      ),
    ),
  );

  Widget sendIcone()=>Container(
    decoration: BoxDecoration(
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

    child: SizedBox(height: 100.0,
      width: 100.0,
      child:
      FloatingActionButton(
        //child: Icon(Icons.ac_unit),
        child:_sentSosCall? _receive?const Icon(Icons.verified_user_sharp,size: 50,color: Colors.white,) :const Icon(Icons.send,size: 50,color: Colors.white,):const CircularProgressIndicator(
          color: Colors.white,),
        backgroundColor:_sentSosCall? _receive?Colors.green:Colors.blue : Colors.grey,
        onPressed: () {
          if(_receive) {
            print("ok");
            onAccept();
          }
        },
      ),
    ),
  );
  Widget sendMessageButton()=>Container(
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
        if(my_socket.isconnect && (_message.text.length>0) ) sendMessage();

      },
      child:_sendingMessage? const CircularProgressIndicator(color: Colors.white, ): const Icon(Icons.send,size: 18,),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary:(my_socket.isconnect && (_message.text.length>0))? app_colors.sentMessagebutton:Colors.grey,
        minimumSize: const Size(50, 50),

      ),
    ),
  );


  /////////////////////////Containers/////////////////////////////////////////////
  Widget photo(String p)=>Container(
    padding: const EdgeInsets.all(5),
    color: Colors.black54,
    child: Image.file(new File(p)),
  );
Widget chatSendContainer()=>Container(
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
    Align(alignment:const Alignment(1,0),child:sendMessageButton(),),

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
              decoration: InputDecoration(
                border:InputBorder.none,
                hintText: my_texts.enterYourMessage,
                hintStyle: const TextStyle(color: Colors.white),
              ),
              style: const TextStyle(color: Colors.white),
            ),
          ),



  );

  Widget messagesContainer()=>Container(
    height: 380,
    width: 380,
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
    //child: messageListView(),



  );
  Widget messageBox(MessageModel message) =>  Row(
    children: [
      Text(message.time,style:const TextStyle(color: Colors.white,fontSize: 10,fontWeight: FontWeight.bold),),
      //if(message.senderType==0)Text(message.client,style:const TextStyle(color: Colors.blue,fontSize: 10,fontWeight: FontWeight.bold),),
      if(message.senderType==1)Text("Service representative",style:const TextStyle(color: Colors.orangeAccent,fontSize: 10,fontWeight: FontWeight.bold),),
      const Text(">>",style:TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold),),
      if(message.senderType==0) Text(message.message,style:const TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),),
      if(message.senderType==1) Text(message.message,style:const TextStyle(color: Colors.orangeAccent,fontSize: 20,fontWeight: FontWeight.bold),),
    ],
  );

  Widget messageListView() => ListView(

      children: <Widget>[
        for(MessageModel msg in messages) messageBox(msg),




      ],
  );

  Widget chatContainer()=>SingleChildScrollView(
    reverse: true,
    child: Container(
      height:480,
      width: 400,
      decoration: BoxDecoration(
          color: app_colors.chatbackground,
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
               messagesContainer(),
              const SizedBox(height: 10,),
              chatSendContainer(),

            ],),
          ),
          Align(alignment: Alignment.topRight,child: IconButton(
            icon:const Icon(Icons.clear,size: 50,color: Colors.red,) ,
            onPressed:(){
              setState(() {
                chatOpen=false;
              });
            } ,
          ),)
        ],
      ),


    ),
  );

  Widget inputdescriptionTextField()=>Container(
    height: 200,
    width:350,
    child: TextField(
      decoration: InputDecoration(
          hintText: my_texts.inputDescription,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color:app_colors.BorderSide, width: 5.0),
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedBorder:OutlineInputBorder(
            borderSide: BorderSide(color:app_colors.BorderSide, width: 2.0),
            borderRadius: BorderRadius.circular(20.0) ,

          ),
          fillColor: app_colors.describeInputFill,
          filled: true,
          prefix: const Padding(
            padding: EdgeInsets.all(4),
          ) ),
      maxLines: 10,
      maxLength: 100,
      controller: _describe,
    ),
  );
  Widget photoContainer()=>Container(
    height: 100,
    width: 2000,
    //color: Colors.pink,
    child: imageListView(),

  );
  Widget ShowStat()=>Container(
    height: 250,
    width: 300,
    padding: EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: app_colors.statshow,
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
    child:Stack(children: [
      if(_sentSosCall) Align(alignment: const Alignment(0,-0.6), child:sentToServer() ,),
      if(_receive) Align(alignment: const Alignment(0,-0.2), child:sosReceived() ,),
      Align(alignment: const Alignment(0,0.6), child:sendIcone(),),



    ],) ,
  );

  ///////////////////////END Containers//////////////////////////////////////
////////######################TEXT############/////////////////////////////

  Widget connectedToServer()=> Text(
    my_texts.connectedToServer,
    style:TextStyle(
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
    style:TextStyle(
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
  Widget sentToServer()=> Text(
    my_texts.sentReferral,
    style:TextStyle(
      fontSize:20,
      color:Colors.blue,
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
  Widget sosReceived()=> Text(
    my_texts.sosReceived,
    style:TextStyle(
      fontSize:20,
      color:Colors.green,
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
////////######################END TEXT############/////////////////////////////
  Widget map_widget()=>FlutterMap(
    mapController: _mapController,

    options: MapOptions(
      center: LatLng(map_class.lat,map_class.long),
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
              point: LatLng(map_class.lat, map_class.long),
              builder:(_){
                return Icon(Icons.location_on,size: 50.0,color: Colors.red);
              }
          ),
        ],
      ),
    ],

  );
  Widget imageListView() => ListView(
    scrollDirection: Axis.horizontal,
    children: <Widget>[
      for(String p in _paths)
        photo(p),

    ],


  );
  Widget sosPage()=> Scaffold
    (
    appBar: AppBar(
      centerTitle: true,
      title: Text(my_texts.CitySafty, style: TextStyle(color: app_colors.city_safty),),
      backgroundColor: app_colors.app_bar_background,
      elevation: 10,
      actions: [
        PopupMenuButton(
          color: Colors.grey,
          child:const Icon(Icons.language) ,
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text("عربيه"),
                value: 1,
                onTap: (){print("change to arbic");},
              ),
              const PopupMenuItem(
                child: Text("English"),
                value: 2,

              ),
            ]
        ),
        IconButton(
          onPressed:() {Navigator.push(context, MaterialPageRoute(builder: (context)=> (Registor())));},
          icon: const Icon(Icons.perm_identity_rounded),
        ),
      ],
    ),
    body:Container(
      child: Stack(
        children: [
          map_widget(),
          Align(alignment: const Alignment(-0.7,0.9),child:Camera_Button() ,),
          Align(alignment: const Alignment(0.7,0.9),child:descriptionButton() ,),
          Align(alignment: const Alignment(0.7,0.6),child:chatButton()),
          Align(alignment: const Alignment(0.0,0.9),child:_cancel_button? CancelButton():SOS_Button()),
          if(_paths.isNotEmpty) photoContainer(),
          if(_description)Align(alignment: const Alignment(0.0,0.0),child: inputdescriptionTextField(),),
          if(my_socket.isconnect) Align(alignment: const Alignment(0.0,-1),child:connectedToServer())
          else Align(alignment: const Alignment(0.0,-1),child:notConnectedToServer()),
          if(_showState)Align(alignment: const Alignment(0.0,-0.5),child:ShowStat()),
          if(chatOpen)Align(alignment: const Alignment(0.0,0.0),child:chatContainer()),
        //  Align(alignment: const Alignment(0.0,0.0),child:TestButton()),

        ],
      ),
    ),
  );

  ///////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return sosPage();
  }


}