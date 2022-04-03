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

class Sos extends StatefulWidget {
  const Sos({Key? key}) : super(key: key);

  @override
  _SosState createState() => _SosState();
}

class _SosState extends State<Sos> {

  late final MapController _mapController;
  List<String> _paths=my_images.getPaths();
  int img_size=0;
  bool soketConnect=false;
  late IO.Socket socket;
  late Call call;
   void makeCall()async{


     if(_paths.isNotEmpty) {
       ImagesClass imgs=await makeimagesClass() as ImagesClass;
       call=await newCall(data.user_name, data.phone,map_class.lat, map_class.long, "non",_paths.length ,imgs.id);
     }
     else{
       call=await newCall(data.user_name, data.phone,map_class.lat, map_class.long,"non",0,objId());
     }


     callConnect();

   }
   void Signin(Call call){
     socket.emit("clientSignin",call.id);
     
   }


  void SoS(Call call) {
    socket.emit("SOS",
        {call.toMap()});
    print("send");
  }

  void callConnect() {
    socket = IO.io("http://192.168.1.233:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,} );

    socket.connect();
    socket.onConnect((data) {
      print("Connected");
      Signin(call);
      SoS(call);
    });

    print(socket.connected);

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







  @override
  void initState() {
    super.initState();
    print("init sos page");
    _mapController = MapController();
    if(_paths.isNotEmpty)img_size=_paths.length;
    else img_size=0;
    data.getData();



    found_my_place_on_map();
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
        child: Text("SOS"),
        backgroundColor: Colors.red,
        onPressed: () {
         makeCall();
        },
      ),
    ),
  );
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
  Widget image_collect()=>Container(
    decoration: BoxDecoration(
        color: app_colors.image_count_background,
        borderRadius: BorderRadius.circular(10),
        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset:const Offset(4,5)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: const Offset(-4,-5)

          ),
        ]
    ),
    child:
    SizedBox(
      height: 50,
      width:20,
      child:  Text("$img_size",style: TextStyle(color: app_colors.image_count,fontSize: 20,fontWeight: FontWeight.bold),),

    ),

  );
  Widget photo(String p)=>Container(
    padding: const EdgeInsets.all(5),
    color: Colors.black54,
    child: Image.file(new File(p)),
  );


  Widget imageListView() =>
      ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
          for(String p in _paths)
            photo(p),

        ],


      );

  Widget photoContainer()=>Container(
    height: 100,
    width: 2000,
    //color: Colors.pink,
    child: imageListView(),

  );
  Widget my_stak()=>Stack(
    children: [
      map_widget(),

      Column(children: [
        SizedBox(height: 535,),
        Row(children: [ SizedBox(width: 50,),image_collect(),],),
      ],),
      Container(
        padding: const EdgeInsets.only(bottom:10),
        child:
        Column(
          children: [
            SizedBox(height: 560,),
            Row(
              children: [
                SizedBox(width: 30,),
                Camera_Button(),
              ],
            )
          ],
        ),
      ),
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
          Column(children: [
            const SizedBox(height: 480,),
            Row(children: [ SizedBox(width: 50,),image_collect(),],),
          ],),
          Container(
            padding: const EdgeInsets.only(bottom:10),
            child:
            Column(
              children: [
                SizedBox(height: 500,),
                Row(
                  children: [
                    SizedBox(width: 30,),
                    Camera_Button(),
                  ],
                )
              ],
            ),
          ),
          if(_paths.isNotEmpty) photoContainer(),
        ],
      ),
    ),
    floatingActionButton:SOS_Button(),
    floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
  );

  ///////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return sosPage();
  }


}