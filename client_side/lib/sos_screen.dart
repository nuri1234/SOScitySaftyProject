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
  final TextEditingController _msg= TextEditingController();
  bool _msgshow=false;
  bool _sent=false;
  bool _showState=false;
  bool _receive=false;
  bool _cancel_button=false;



  ////////////////////////Functions/////////////////////////////////////////////
  void makeCall()async{
    setState(() {
     _showState=true;
     _cancel_button=true;
    });

    if(_paths.isNotEmpty) {
      ImagesClass imgs=await makeimagesClass() as ImagesClass;
      call=await newCall(data.user_name, data.phone,map_class.lat, map_class.long, _msg.text,_paths.length ,imgs.id.toHexString());
    }
    else{
      call=await newCall(data.user_name, data.phone,map_class.lat, map_class.long,_msg.text,0,"non");
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
      _msg.text="";
      int img_size=0;
      _sent=false;
      _showState=false;
      _receive=false;
      _cancel_button=false;
    });


  }
  void sos_send(){
   setState(() {
     _sent=true;
   });

  }
  void socketListner() {
    my_socket.socket.on("sos_send", (msg){
      print("sos_send");
      print(msg);
      sos_send();});

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
       _sent=false;
      _showState=false;
      _receive=false;
       _cancel_button=false;



    });

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
        backgroundColor: Colors.red,
        onPressed: () {
          print("Cncel button presswd");
          cancel();
        },
      ),
    ),
  );
  Widget message_Button()=>Container(
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
          if(_msgshow) _msgshow=false;
          else _msgshow=true;
        });
      },
      child: Icon(Icons.message,size: 40.0,),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary: app_colors.messag_button,
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
        child:_sent? _receive?const Icon(Icons.verified_user_sharp,size: 50,color: Colors.white,) :const Icon(Icons.send,size: 50,color: Colors.white,):const CircularProgressIndicator(
          color: Colors.white,),
        backgroundColor:_sent? _receive?Colors.green:Colors.blue : Colors.grey,
        onPressed: () {
          if(_receive) {
            print("ok");
            onAccept();
          }
        },
      ),
    ),
  );


  /////////////////////////Containers/////////////////////////////////////////////
  Widget photo(String p)=>Container(
    padding: const EdgeInsets.all(5),
    color: Colors.black54,
    child: Image.file(new File(p)),
  );
  Widget inputMessageTextField()=>Container(
    height: 200,
    width:350,
    color: Colors.black12,
    child: TextField(
      decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color:app_colors.BorderSide, width: 5.0),
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedBorder:OutlineInputBorder(
            borderSide: BorderSide(color:app_colors.BorderSide, width: 2.0),
            borderRadius: BorderRadius.circular(20.0) ,

          ),
          prefixIcon: Icon(Icons.message,color:app_colors.BorderSide,size: 20.0,),
          fillColor: app_colors.textInputFill,
          filled: true,
          prefix: Padding(
            padding: EdgeInsets.all(4),
          ) ),
      maxLines: 10,
      maxLength: 100,
      controller: _msg,
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
      if(_sent) Align(alignment: const Alignment(0,-0.6), child:sentToServer() ,),
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
        IconButton(
          onPressed:()=> {},
          icon: Icon(Icons.arrow_drop_down_circle),
        ),
      ],
    ),
    body:Container(
      child: Stack(
        children: [
          map_widget(),
          Align(alignment: Alignment(-0.7,0.9),child:Camera_Button() ,),
          Align(alignment: Alignment(0.7,0.9),child:message_Button() ,),
          if(_paths.isNotEmpty) photoContainer(),
          if(_msgshow)Align(alignment: Alignment(0.0,0.0),child: inputMessageTextField(),),
          if(my_socket.isconnect) Align(alignment: Alignment(0.0,-1),child:connectedToServer())
          else Align(alignment: Alignment(0.0,-1),child:notConnectedToServer()),
          if(_showState)Align(alignment: Alignment(0.0,-0.5),child:ShowStat()),

        ],
      ),
    ),
    floatingActionButton:_cancel_button? CancelButton():SOS_Button(),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
  );

  ///////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return sosPage();
  }


}