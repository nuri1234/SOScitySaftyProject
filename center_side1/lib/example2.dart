import 'dart:convert';
import 'dart:io';
import 'package:center_side/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'texts.dart';
import 'socket_class.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dbHelper/message_model.dart';
import 'dbHelper/client_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:audioplayers/audioplayers.dart';
import 'dbHelper/audio_model.dart';


import 'dart:async';


class examplePage2 extends StatefulWidget {
  const examplePage2({Key? key}) : super(key: key);

  @override
  State<examplePage2> createState() => _examplePage2State();
}

class _examplePage2State extends State<examplePage2> {
  int i=0;
  List<Client> _clients = [];
  late Client _client;
  bool clientPage=false;
  String street="";
  bool _sendingMessage=false;
  final TextEditingController _message= TextEditingController();
  final ScrollController _controller = ScrollController();
  File? imageFile;
  late MessageModel newMsg;
  late MessageModel newMsgTest;
  bool imageShow=false;
  int photoIndex=0;
  int audioIndex=0;
  int forTest=0;

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
      setState(() {
        _clients.insert(0, newClient);
      });

    });

    my_socket.socket.on("SOS_Call_Respone", (client_socketId) async{
      print("SOS_Call_Respone");
      for(Client client in _clients) {
        if (client.socketId == client_socketId) {
          setState(() {
            _clients.remove(client);
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
      addNewMsg();

    });

    my_socket.socket.on("cancel", (sourceId) async{
      print("cancel $sourceId");
      cancel(sourceId);


    });

    my_socket.socket.on("clientDisconnected", (sourceId) async{
      print("clientDisconnected $sourceId");
      clientDisconnected(sourceId);


    });






    my_socket.socket.onDisconnect((_){
      print("Disconnect from server");
      setState(() {
        my_socket.isconnect=false;
      });
    });

    my_socket.socket.onConnect((data) {

      print("Connected to server2");
      my_socket.socket.emit("centerSignin", my_socket.socket.id.toString());
      setState(() {
        my_socket.isconnect=true;
      });
    });


  }
  void endCall() {
    my_socket.socket.emit("end_call",_client.socketId);
    setState(() {
      _client.changeStatus(4);
    });

  }
  void openCall(Client client){
    print("open call");
    setState(() {
      client.changeStatus(1);
      _client=client;
      clientPage=true;
      GetAddressFromLatLong();

    });
    
    my_socket.socket.emit("SOS_Call_Respone",client.socketId);
    setState(() {
      client.STATUS=1;

    });

 




  }
  void cancel(sourceId) async{
    for(Client client in _clients){
      if(client.socketId==sourceId) {
        setState(() {
          client.STATUS=2;
        });
      }

    }



  }
  void clientDisconnected(sourceId) async{
    for(Client client in _clients){
      if(client.socketId==sourceId) {
        setState(() {
          client.STATUS=3;
        });
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
/////////////////////////chat functions///////////////
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


    for (Client client in _clients) {
      if (client.socketId == sourceId) {
        setState(() {
          client.addMessage(msg);
        });
      }
    }

  }
  void addNewMsg() async{


    print("hereeeeeeeeeeeeeeeeeeee");
    setState(() {

      _sendingMessage=false;
      _message.text="";
      _client.addMessage(newMsg);

    });




  }
  void sendMessage(Client client)async{
    print("sendMessage()");
    print(client.socketId);
    my_socket.socket.emit("message",{'msg':newMsg.toMap(),'targetId':client.socketId});

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socketListner();
  }

////////////////////////////
  void makeCallTest() async{
    my_socket.socket.emit("SOS_Call_Test",{'socketId':i.toString(),'client':{'userName':"testName$i",'phone':"0542259977",'lat':51.5,'long':-0.5}});
    i++;
  }
  Widget SOSTestButton()=>Container(
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

    child: SizedBox(
      height: 100.0,
      width: 100.0,
      child:
      FloatingActionButton(
        //child: Icon(Icons.ac_unit),
        child: Text("SOS CALL TEST",style: TextStyle(fontSize: 15,color: Colors.black),),

        backgroundColor: my_socket.isconnect? Colors.lightGreenAccent: Colors.grey,
        onPressed: () {
          print("SOS call test button pressd");
          if(my_socket.isconnect)makeCallTest();

        },
      ),
    ),
  );
  ////////////////////כל אלה בשביל תצוגת הלוגו והברוכים הבאים/////////////////////////////////
  Widget logo()=>Container(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      child: const Image(
        image: AssetImage('assets/images/logo.png'),
        height: 200,
        width: 200,
      )

  );
  Widget welcome()=> DefaultTextStyle(
    style: GoogleFonts.pacifico(fontSize: 60,fontWeight: FontWeight.w300,color: app_colors.Welcome),
    child: Text(my_texts.welcome),);
  Widget WelcomeContainer()=>Container(
      color: Colors.blueGrey,
      height: 250,
      width:400,
      child:Stack(children: [
        Align(alignment: Alignment.topCenter,child: welcome(),),
        Align(alignment: const Alignment(0.0,1),child: logo(),),

      ],)

  );
  //////////////////////////////////////////////////////////////
//////********chat widgets**************/////
  Widget chatSendContainer()=>Container(
    height:70,
    width: 500,
    decoration: BoxDecoration(
        color: Colors.blue,
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
        decoration: const InputDecoration(
          border:InputBorder.none,
          hintText: "enter your message",
          hintStyle: TextStyle(color: Colors.white),
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
        color: Colors.black38,
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
    child: messageListView(_client.messages),



  );
  Widget messageBox(MessageModel message) => Column(
    children: [
      Row(children: [Text(message.time,style:const TextStyle(color: Colors.white,fontSize: 10,fontWeight: FontWeight.bold),),
        if(message.senderType==0)Text(_client.userName,style:const TextStyle(color: Colors.blue,fontSize: 10,fontWeight: FontWeight.bold),),
        if(message.senderType==1)const Text("Service representative",style:TextStyle(color: Colors.orangeAccent,fontSize: 10,fontWeight: FontWeight.bold),),
        const Text(">>",style:TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold),),],),

      if(message.senderType==0) Text(message.message,style:const TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),),
      if(message.senderType==1) Text(message.message,style:const TextStyle(color: Colors.orangeAccent,fontSize: 20,fontWeight: FontWeight.bold),),
    ],
  );
  Widget imageBox(MessageModel message) => Container(
    child: Column(children: [
      Row(children: [Text(message.time,style:const TextStyle(color: Colors.white,fontSize: 10,fontWeight: FontWeight.bold),),
        if(message.senderType==0)Text(_client.userName,style:const TextStyle(color: Colors.blue,fontSize: 10,fontWeight: FontWeight.bold),),
        if(message.senderType==1)const Text("Service representative",style:TextStyle(color: Colors.orangeAccent,fontSize: 10,fontWeight: FontWeight.bold),),
        const Text(">>",style:TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold),),],),
      Container(
        width: 300,
        height: 300,
        alignment: Alignment.center,
       child: IconButton(
         onPressed: (){
           setState(() {
             imageFile=File(message.get_path());
             imageShow=true;
           });



         },
         icon:Image(image:FileImage(File(message.get_path())) ,) ,

      ),),
      Text(message.describe),



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
  Widget messageDetails(MessageModel msg)=>Row(
      children: [
        Text(msg.time,style:const TextStyle(color: Colors.white,fontSize: 10,fontWeight: FontWeight.bold),),
        if(msg.senderType==0)Text(_client.userName,style:const TextStyle(color: Colors.blue,fontSize: 10,fontWeight: FontWeight.bold),),
        if(msg.senderType==1)const Text("Service representative",style:TextStyle(color: Colors.orangeAccent,fontSize: 10,fontWeight: FontWeight.bold),),
        const Text(">>",style:TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold),),
      ]);
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
  Widget audioBox(MessageModel message) => Container(
    height: 80,
    // color: Colors.black38,
    child: Stack(children: [
      Align(alignment: const Alignment(0,-1) ,child: audioPlaySlider(message),),
      Align(alignment: const Alignment(-1,-1) ,child: playRecordButton(message),),
      Align(alignment:const Alignment(0,0)  ,child:recordPlayStateShowContainer(message.audio!.duration,message.audio!.position)),


    ],),
  );
  Widget messageListView(List<MessageModel> msgs) => ListView(
    children: <Widget>[
      for(MessageModel msg in msgs)  Column(children: [
        messageDetails(msg),
        if(msg.messageType==0)messageBox(msg)
        else if(msg.messageType==1) imageBox(msg)
        else audioBox(msg)

      ],)


    ],
  );
  Widget messageListView2(List<MessageModel> msgs) => ListView(
    children: <Widget>[
      for(MessageModel msg in msgs) if(msg.messageType==0)messageBox(msg)
      else imageBox(msg),

    ],
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
        if(_message.text.isNotEmpty) {
          setState(() {
            _sendingMessage=true;
          });
          newMsg=MessageModel(senderType: 1,
              messageType: 0,
              message: _message.text,
              describe: "non",
              time:  DateTime.now().toString().substring(10, 16));
          sendMessage(_client);


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
  Widget TestsendMessageButton()=>Container(
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
      onPressed: () {
        newMsgTest=MessageModel(senderType: 0,
            messageType: 0,
            message: "test msg $forTest",
            describe: "",
            time:DateTime.now().toString().substring(10, 16),
        );
        my_socket.socket.emit("message_test",{'sourceId':_client.socketId,'targitId':my_socket.socket.id,'msg':newMsgTest.toMap()});
        forTest++;

      },
      child: Text("send message Test"),

      ),

  );
  /////////////////////client page methods///////////////////////////////////
  Widget detailsContainer()=>Container(
    color: Colors.purpleAccent,
    height: 100,
    width: 350,
    padding: EdgeInsets.all(5),
    child: Column(children: [
      DefaultTextStyle(  child:Text("username: ${_client.userName}") ,style: TextStyle(fontSize:20,color:app_colors.sos_page_font),),
      DefaultTextStyle(  child:Text("phone: ${_client.phone}") ,style: TextStyle(fontSize: 20,color:app_colors.sos_page_font),),
      DefaultTextStyle(  child:Text("date: ${_client.dateTime}") ,style: TextStyle(fontSize: 20,color:app_colors.sos_page_font),)

    ],),);
  void GetAddressFromLatLong() async{
    List<Placemark> placemark= await placemarkFromCoordinates(_client.lat,_client.long);
    print(placemark);
    setState(() {
      street=placemark.first.street.toString();
    });
  }
  Widget mapContainer()=>Container(
    height:300 ,
    width: 250,
    padding: EdgeInsets.all(0.5),
    color: Colors.black12,
    child: Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            center: LatLng(_client.lat,_client.long),
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
                    point: LatLng(_client.lat,_client.long),
                    builder:(_){
                      return Icon(Icons.location_on,size: 50.0,color: Colors.red);
                    }
                ),
              ],
            ),
          ],

        ),
        DefaultTextStyle(  child:Text("street: ${street}") ,style: TextStyle(fontSize: 30,color:app_colors.sos_page_font),)

      ],
    ),

  );
  Widget chatContainer()=>SingleChildScrollView(
    reverse: true,
    child: Container(
      height:500,
      width: 400,
      decoration: BoxDecoration(
          color: Colors.lightGreenAccent,
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
             chatSendContainer(),
            ],

            ),
          ),

        ],
      ),


    ),
  );
  Widget clientContainer()=>Container(
    height: 700,
    width: 700,
    color: Colors.purple,
    child: Stack(children: [
      Align(alignment:const Alignment(1,-1),child:IconButton(
        icon: const Icon(Icons.clear,color: Colors.red,),
        onPressed:(){
          setState(() {
            clientPage=false;
          });
        },

      ),),
      Align(alignment:const Alignment(1,1),child:mapContainer(),),
      Align(alignment:const Alignment(-1,-1),child:detailsContainer(),),
      Align(alignment:const Alignment(-1,1),child:chatContainer(),),
      Align(alignment:const Alignment(-1,1),child:chatContainer(),),
      Align(alignment:const Alignment(1,-0.3),child:TestsendMessageButton(),),
      Align(alignment:const Alignment(1,-0.7),child:statusContainer(),),
      Align(alignment:const Alignment(0,-1),child:endCallButton(),),
     if(imageShow) Align(alignment:const Alignment(0,0),child:bigImageContainr(),),



    ],),
  );
  Widget statusContainer()=>Container(
    color: Colors.white,
    height: 50,
    width: 100,
    child: Stack(children: [
      if(_client.STATUS==1) const Text("client connected"),
      if(_client.STATUS==2) const Text("canceled"),
      if(_client.STATUS==3) const Text("client disconnected"),
      if(_client.STATUS==4) const Text("call ended"),

    ],)
     );
  /////////////////////////////////////////////////////////
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

  Widget endCallButton()=>Container(
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

    child: SizedBox(
      height: 100.0,
      width: 100.0,
      child:
      FloatingActionButton(
        //child: Icon(Icons.ac_unit),
        child: Text("End call",style: TextStyle(fontSize: 15,color: Colors.black),),

        backgroundColor:Colors.red,
        onPressed: () {
          endCall();
        },
      ),
    ),
  );

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
  Widget serverStateContainer()=>Container(
      height: 100,
      width: 200,
      color: Colors.orangeAccent,
      child: my_socket.isconnect? const Text("coneccted to server",style: TextStyle(color: Colors.green,fontSize: 20),)
          :const Text("Not coneccted to server",style: TextStyle(color: Colors.red,fontSize: 20))

  );
  Widget maninContainer()=>Container(
    padding: const EdgeInsets.all(5),
    color: Colors.greenAccent,
    child:  Stack(children: [
      Align(alignment: Alignment.topCenter,child: WelcomeContainer(),),
      Align(alignment:const Alignment(0,0.5),child: mangeCallsContainer(),),
      Align(alignment:const Alignment(-1,-1),child:serverStateContainer(),),
      Align(alignment:const Alignment(1,-1),child:SOSTestButton(),),
      if(clientPage)Align(alignment:const Alignment(0,0),child:clientContainer(),),



    ],),

  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: app_colors.background,
        appBar: AppBar(
          backgroundColor: app_colors.app_bar_background,
          title: Text("this is app bar") ,),
        body: maninContainer()
    );

  }
}
