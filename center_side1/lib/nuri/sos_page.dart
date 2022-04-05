import 'package:crossplat_objectid/crossplat_objectid.dart';
import 'package:flutter/material.dart';
import 'package:center_side/dbHelper/call_class.dart';
import 'package:center_side/dbHelper/calldb_management.dart';
import 'package:center_side/dbHelper/imagesdb_management.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'colors.dart';
import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/cupertino.dart';
import 'package:geocoding/geocoding.dart';




class SOS extends StatefulWidget {
  final Call call;
  SOS({ required this.call});


  @override
  State<SOS> createState() => _SOSState();
}



class _SOSState extends State<SOS> {

  File? _fileImg;
  bool showBigPic = false;
   File? fileImg1;
  File? fileImg2;
   File? fileImg3;
   File? fileImg4;
   File? fileImg5;
  bool _picLooading=true;
  double lat=50;
  double long=-0.12;
  String street="";


  void getCall()async{
   //for Test call=await searchCall("ObjectId(\"6246015787c326dc4d3d65ef\")");


    GetAddressFromLatLong();
  //  if(call.imgSize>0)getImages(call.imagesId.toString());
  //  else(_picLooading=false);
 //   print(call.toMap());

  }

  void getImages(String id) async{
    print("getImages0");
    //for Test var imgs= await searchImages("ObjectId(\"6246015587c326dc4d3d65ee\")");
    var imgs= await searchImages(id);
    print("getImages1");
    if(imgs.base64image1 !="non"){
      final decodedBytes = base64Decode(imgs.base64image1);
      final directory = await getApplicationDocumentsDirectory();
      fileImg1 = File('${directory.path}/testImage1.png');
      print(fileImg1!.path);
      fileImg1!.writeAsBytesSync(List.from(decodedBytes));
    }
    if(imgs.base64image2 !="non"){
      final decodedBytes = base64Decode(imgs.base64image2);
      final directory = await getApplicationDocumentsDirectory();
      fileImg2 = File('${directory.path}/testImage2.png');
      print(fileImg2!.path);
      fileImg2!.writeAsBytesSync(List.from(decodedBytes));
    }
    if(imgs.base64image3 !="non"){
      final decodedBytes = base64Decode(imgs.base64image3);
      final directory = await getApplicationDocumentsDirectory();
      fileImg3 = File('${directory.path}/testImage3.png');
      print(fileImg3!.path);
      fileImg3!.writeAsBytesSync(List.from(decodedBytes));
    }
    if(imgs.base64image4 !="non"){
      final decodedBytes = base64Decode(imgs.base64image4);
      final directory = await getApplicationDocumentsDirectory();
      fileImg4 = File('${directory.path}/testImage4.png');
      print(fileImg4!.path);
      fileImg4!.writeAsBytesSync(List.from(decodedBytes));
    }
    if(imgs.base64image5 !="non"){
      final decodedBytes = base64Decode(imgs.base65image1);
      final directory = await getApplicationDocumentsDirectory();
      fileImg5 = File('${directory.path}/testImage5.png');
      print(fileImg5!.path);
      fileImg5!.writeAsBytesSync(List.from(decodedBytes));
    }
    print("getImages2");
    setState(() {
      _picLooading=false;

    });


  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      lat=widget.call.lat;
      long=widget.call.long;
    });
    GetAddressFromLatLong();
    getImages(widget.call.imagesId);

  }

  Widget detailsContainr()=>Container(
    color: Colors.purpleAccent,
    height: 100,
    width: 350,
    padding: EdgeInsets.all(5),
    child: Column(children: [
      DefaultTextStyle(  child:Text("username: ${widget.call.userName}") ,style: TextStyle(fontSize:20,color:app_colors.sos_page_font),),
      DefaultTextStyle(  child:Text("phone: ${widget.call.phone}") ,style: TextStyle(fontSize: 20,color:app_colors.sos_page_font),),
      DefaultTextStyle(  child:Text("date: ${widget.call.dateTime}") ,style: TextStyle(fontSize: 20,color:app_colors.sos_page_font),)

    ],),


  );

  Widget messageContainr()=>Container(
   color: Colors.greenAccent,
    height: 150,
    width: 300,
    padding: EdgeInsets.all(5),
    alignment: Alignment.center,
    child:DefaultTextStyle(  child:Text("message: ${widget.call.msg}") ,style: TextStyle(fontSize: 20,color:app_colors.sos_page_font),),

  );


  Widget pictursContainr()=>Container(
    //color: Colors.pink,
    height: 200,
    width: 600,
    padding: EdgeInsets.all(5),
    child:_picLooading? Center(child: CircularProgressIndicator()): imageListView(),

  );

  Widget imgBox(File img) =>  Container(height:150,width: 150,
    color: Colors.black,
    padding: EdgeInsets.all(5),
    alignment: Alignment.center,
    child: IconButton(
      iconSize: 150,
      onPressed:(){
        setState(() {
          _fileImg=img;
          showBigPic=true;
        });
        print("pressd");},
      icon:Image.file(img) ,

    ),
  );

  void GetAddressFromLatLong() async{
    List<Placemark> placemark= await placemarkFromCoordinates(lat,long);
    print(placemark);
   setState(() {
     street=placemark.first.street.toString();
   });




  }


  Widget imageListView() =>
      ListView(
        scrollDirection: Axis.horizontal,
        children: <Widget>[
           if(fileImg1!=null) imgBox(fileImg1!),
          if(fileImg2!=null) imgBox(fileImg2!),
          if(fileImg3!=null) imgBox(fileImg3!),
          if(fileImg4!=null)imgBox(fileImg4!),
          if(fileImg5!=null)imgBox(fileImg5!),

        ],


      );



  Widget bigImageContainr()=>Container(
    height: 650,
    width: 650,
   // color: Colors.green,
    child: Stack(children: [
      Align(alignment: Alignment.center,child: Image.file(_fileImg!) ,),
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
            setState(() {showBigPic=false;});
          },






        icon: const Center(child: Icon(Icons.clear,color: Colors.red,size: 80,)),

        ),
      ),),


    ],)



  );



  Widget mapContainer()=>Container(
    height:450 ,
    width: 450,
    padding: EdgeInsets.all(0.5),
    color: Colors.black12,
    child: Stack(
      children: [
        FlutterMap(
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
        DefaultTextStyle(  child:Text("street: ${street}") ,style: TextStyle(fontSize: 30,color:app_colors.sos_page_font),)

      ],
    ),

  );








  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Container(
          padding: EdgeInsets.all(20),
          color: app_colors.background,
          child: Stack(children: [
           Align(alignment: Alignment.topLeft,child: detailsContainr(),),
            Align(alignment: Alignment(-1,-0.0),child:messageContainr(),),
            Align(alignment: Alignment(1,-1),child:pictursContainr(),),
            Align(alignment: Alignment(0,1),child:mapContainer(),),
            if(showBigPic)Align(alignment: Alignment(-0.0,0),child:bigImageContainr(),),
            Align(alignment: Alignment.topRight,child:
            IconButton(onPressed:(){Navigator.pop(context); },icon: const Icon(Icons.clear,color: Colors.red,)),),






          ],),


      ),
    );
  }
}
