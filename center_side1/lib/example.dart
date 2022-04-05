import 'dart:async';

import 'package:center_side/dbHelper/calldb_management.dart';
import 'package:center_side/nuri/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'nuri/texts.dart';
import 'socket_class.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dbHelper/call_class.dart';
import 'nuri/sos_page.dart';
class examplePage extends StatefulWidget {
  const examplePage({Key? key}) : super(key: key);

  @override
  State<examplePage> createState() => _examplePageState();
}

class _examplePageState extends State<examplePage> {
  int i=0;
  List<Call> _calls = [];



  void newCallReceived(Call  call){
    print("new call");
    setState(() {
      _calls.insert(0, call);
    });


  }

  void socketListner() {
    my_socket.socket.on("SOS", (sos) async{
      print("SOS Received");
      print(sos);
      var call_new= await searchCall(sos['call']['_id']);
      if(call_new!=null) newCallReceived(call_new);
      else print("cant find call");
    });


    my_socket.socket.on("call_recived", (socketId) async{
      print("call_recived");
      print(socketId);
      for(Call call in _calls) {
        if(call.socketId==socketId) setState(() {call.changeStatus(1);});
      }
    });

    my_socket.socket.on("cancel", (socketId) async{
      print("cancel");
      print(socketId);
      for(Call call in _calls) {
        if(call.socketId==socketId) setState(() {call.changeStatus(2);});
      }
    });


    my_socket.socket.onDisconnect((_){
      print("Disconnect from server");
      setState(() {
        my_socket.isconnect=false;
      });
    });

    my_socket.socket.onConnect((data) {
      if(my_socket.isconnect==false){
        print("Connected to server2");
        my_socket.socket.emit("centerSignin", my_socket.socket.id.toString());
        setState(() {
          my_socket.isconnect=true;
        });}
    });


  }
  
  void openCall(Call call){
    print("open call");
    setState(() {
      call.changeStatus(1);
    });

    my_socket.socket.emit("receive",call.socketId);
    Navigator.push(context, MaterialPageRoute(builder: (context)=> SOS(call: call,)));


    
    
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    socketListner();
  }

////////////////////////////
  void makeCallTest() async{
    /////פונקציה לבדיקה של פניית
  var call=await newCall("teste_username ${i}", "0542259977", 51.5, -0.5, "test message", 3, "624ba45d84f6df223cd1ed99");
    my_socket.socket.emit("SOS",{call.toMap()});
    i++;
    print("send");
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
        child: Text("SOS TEST",style: TextStyle(fontSize: 15,color: Colors.black),),

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
      for(Call call in _calls)
       callBox(call),

    ],


  );

  Widget callBox(Call call) => Container(
    height: 80,
    width:100,
    padding: const EdgeInsets.all(5),
   // color: Colors.blue,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      color:(call.STATUS==0)? Colors.lightGreenAccent :(call.STATUS==1)?Colors.grey:Colors.red,
        border: Border.all(color: Colors.black,width: 10)
    ),
    child: IconButton(
      onPressed: () {
        openCall(call);
      },
      icon: Text("SOS call from ${call.userName}"),
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
    padding: const EdgeInsets.all(5), //זה קובע כמה אפשר להתקרב לקצוות של הקונטאינר מבפנים
    color: Colors.greenAccent,
    child:  Stack(children: [
      Align(alignment: Alignment.topCenter,child: WelcomeContainer(),),
      Align(alignment:const Alignment(0,0.5),child: mangeCallsContainer(),),
      Align(alignment:const Alignment(-1,-1),child:serverStateContainer(),),
      Align(alignment:const Alignment(1,-1),child:SOSTestButton(),),


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
