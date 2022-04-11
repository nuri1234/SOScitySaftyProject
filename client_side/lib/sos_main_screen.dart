import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:image_picker/image_picker.dart';
import 'colors.dart';
import 'texts.dart';
import 'dart:async';
import 'images.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'local_data.dart';
import 'socket_class.dart';
import 'registration_page.dart';
import 'dbHelper/message_model.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';






class SOS extends StatefulWidget {
  const SOS({Key? key}) : super(key: key);

  @override
  State<SOS> createState() => _SOSState();
}

class _SOSState extends State<SOS> {
  late final MapController _mapController;
  List<String> _paths=my_images.getPaths();
  int img_size=0;
  final TextEditingController _describe= TextEditingController();
  final TextEditingController _message= TextEditingController();
  bool calling=false;
  bool sendrequest=false;
  bool requestResponse=false;
  late MessageModel newMsg;
  late MessageModel newMsgTest;
  List<MessageModel> messages = [];
  bool chatOpen=false;
  double lat = 51.5;
  double long = -0.5;
  Timer? timer;
  bool sosButtonRotation=true;
  double sosButtonHigh=100;
  double sosButtonWidth=100;
  double cancelButtonHigh=90;
  double cancelButtonWidth=90;
  late String targetSocket;
  bool buttonsCollection=false;
  bool _sendingMessage=false;
  bool _sendingPhotoMessage=false;
  File? imageFile;
  bool imageShow=false;
  final ScrollController _controller = ScrollController();
  int photoIndex=0;



  ////////////////////////Functions/////////////////////////////////////////////



  void socketListner() {


    my_socket.socket.on("sos_call_request_send", (client){
      print("sos_call_request_send");
      print(client);
      setState(() {
        sendrequest=true;
      });

    });

    my_socket.socket.on("SOS_Call_Respone", (id){
      print("SOS_Call_Respone");
      print(id);
      setState(() {
        targetSocket=id;
      });
      SOScallRespon();

    });



    my_socket.socket.on("get_message",(msg) async{
      newMsg=MessageModel(senderType:msg['senderType'] ,
          messageType: msg['senderType'],
          message: msg['message'],
          describe:msg['describe'],
          time: msg['time']);
     addNewMsg();

    });

    my_socket.socket.on("message_send", (data) async{
      print("message_send");
      addNewMsg();

    });

    my_socket.socket.on("error", (msg){
      print("error: $msg");



    });

    my_socket.socket.onDisconnect((_){
      print("Disconnect from server");
      setState(() {
        my_socket.isconnect=false;
      });
    });


    my_socket.socket.onConnect((data) {
      print("Connected to server2");
      my_socket.socket.emit("clientSignin", my_socket.socket.id);
      my_socket.isconnect = true;
      setState(() {
        my_socket.isconnect=true;
      });
    });



  }

  void SOScallRespon(){
print("SOScallRespon()");
    setState(() {
      requestResponse=true;
      calling=false;
    });

  }
void ButtonRotator(){
    setState(() {
      if(sosButtonRotation) {
        sosButtonHigh=110;
        sosButtonWidth=110;
        sosButtonRotation=false;

      } else {
        sosButtonHigh=100;
        sosButtonWidth=100;
        sosButtonRotation=true;

      }
    });


}
  void SOS_Call()async{
    print("SOS_Call()");
    setState(() {
      calling=true;
      chatOpen=true;
    });
    my_socket.socket.emit("SOS_Call",{'user_name':data.user_name,'phone':data.phone,'lat':lat,'long':long});
    my_socket.socket.emit("SOS_Call_Respone",my_socket.socket.id);
  }

  void getImage({required ImageSource source}) async {
    final file = await ImagePicker().pickImage(source: source);

    if (file?.path != null) {
      setState(() {
        imageFile = File(file!.path);
        imageShow=true;
      });
    }
  }
  void addNewMsg() async{
    if(newMsg.messageType==1){
      final decodedBytes = base64Decode(newMsg.message);
      final directory = await getApplicationDocumentsDirectory();
      File fileImge = File('${directory.path}/testImage${photoIndex}.png');
      print(fileImge.path);
      fileImge.writeAsBytesSync(List.from(decodedBytes));
      newMsg.insert_path(fileImge.path);
      photoIndex++;

    }
    setState(() {

      if(_sendingPhotoMessage) {
        _sendingPhotoMessage=false;
        imageShow=false;
      }
      _sendingMessage=false;
      _message.text="";
      messages.add(newMsg);

    });
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _controller.jumpTo(_controller.position.maxScrollExtent);
    });


  }
  void sendMessage()async{
    print("sendMessage()");

    targetSocket=my_socket.socket.id.toString();
    requestResponse=true;
    if(requestResponse) {
      my_socket.socket.emit("message",{'msg':newMsg.toMap(),'targetId':targetSocket});
    }
    else {
      my_socket.socket.emit("laterMessage", {newMsg.toMap()});
    }


  }

  @override
  void initState() {
    super.initState();
    print("init sos page");
    _mapController = MapController();
    data.getData();
    socketListner();
    timer = Timer.periodic(const Duration(seconds:1), (Timer t) => ButtonRotator());

    initMap();
  }
  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
////////////////////////////////////////////////////////
  void initMap() async{
    Position position=await _determinePosition();
    setState(() {
      lat=position.latitude;
      long=position.longitude;
      _mapController.move(LatLng(lat,long), 13.0);

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
        getImage(source: ImageSource.camera);
      },
      child: const Icon(Icons.camera_alt,size: 30.0,),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary: app_colors.cmera_button,
        minimumSize:const Size(60.0, 60.0),

      ),
    ),
  );
  Widget gallery_Button()=>Container(
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
        getImage(source: ImageSource.gallery);
      },
      child: const Icon(Icons.image,size: 30.0,),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary: app_colors.galarry_button,
        minimumSize:const Size(60.0, 60.0),

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

    child: SizedBox(
      height: sosButtonHigh,
      width: sosButtonWidth,
      child:
      FloatingActionButton(
        //child: Icon(Icons.ac_unit),

        child: const Text("SOS",style: TextStyle(fontSize: 40),),

        backgroundColor: my_socket.isconnect? app_colors.sos_button: app_colors.sos_disablbutton,
        onPressed: () {
          print("SOS button pressed");
          if(my_socket.isconnect)SOS_Call();

        },
      ),
    ),
  );

  Widget CancelButton2()=>Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
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

    child: SizedBox(height: 50,
      width: 50 ,
      child:
      FloatingActionButton(
        //child: Icon(Icons.ac_unit),
        child: const Icon(Icons.clear,size:40,),
        backgroundColor: app_colors.cansel_button,
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context)=>(const SOS())),);
          print("Cancel button pressed");

        },
      ),
    ),
  );
  Widget CancelPhoto()=>Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
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

    child: SizedBox(height: 50,
      width: 50 ,
      child:
      FloatingActionButton(
        //child: Icon(Icons.ac_unit),
        child: const Icon(Icons.clear,size:40,color:Colors.red),
        backgroundColor: Colors.black.withOpacity(0),
        onPressed: () {
          print("Cancel photo button pressed");
          setState(() {
            imageShow=false;
            imageFile=null;
          });

        },
      ),
    ),
  );
  Widget sendPhoto()=>Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
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

    child: SizedBox(height: 50,
      width: 50 ,
      child:
      FloatingActionButton(
        //child: Icon(Icons.ac_unit),
        child: const Icon(Icons.check,size:40,color:Colors.lightGreenAccent),
        backgroundColor: Colors.black.withOpacity(0),
        onPressed: () {
          print("send photo button pressed");
          List<int> imageBytes = imageFile!.readAsBytesSync();
          String base64Image = base64Encode(imageBytes);
          String discription;
        if(_describe.text.isNotEmpty){ discription=_describe.text;}
        else {discription="non";}
        newMsg=MessageModel(senderType: 0,
            messageType: 1,
            message: base64Image,
            describe: discription,
            time: DateTime.now().toString().substring(10, 16));

        setState(() {
          _sendingPhotoMessage=true;
        });
          sendMessage();
        },

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


  Widget optionsButtons()=>Container(
    height:70,
    width: 400,
     // color:Colors.lightGreenAccent,

    child: Row(children: [Camera_Button(),const SizedBox(width: 10,),gallery_Button()],)
  );
  ///////////////////////////////////////////////

  Widget photoContainer()=>Container(
    height: 450,
    width: 360,
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
        color: app_colors.messageInputFill,
        borderRadius: BorderRadius.circular(20),
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
    child:
    Stack(
      children: [
        Center(
          child: Column(children: [
            Container(
              width: 300,
              height: 300,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:app_colors.cameraPageInputimage,
                border: Border.all(width: 8, color: Colors.black12),
                borderRadius: BorderRadius.circular(12.0),
                image: DecorationImage(image: FileImage(imageFile!), fit: BoxFit.cover),
              ),),
            SizedBox(height: 5,),
            inputdescriptionTextField(),

          ]
          ),
        ),
        Align(alignment: const Alignment(0,1),child:Container(
          //color: Colors.green,
            width: 105,
            child: Row(children: [CancelPhoto(),const SizedBox(width: 5,),sendPhoto()],))),
        if(_sendingPhotoMessage)Center(child: loading(),),

      ],
    ),
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
    child: messageListView(),



  );
  Widget messageBox(MessageModel message) => Column(
    children: [
      Row(children: [Text(message.time,style:const TextStyle(color: Colors.white,fontSize: 10,fontWeight: FontWeight.bold),),
        if(message.senderType==0)Text(data.user_name,style:const TextStyle(color: Colors.blue,fontSize: 10,fontWeight: FontWeight.bold),),
        if(message.senderType==1)const Text("Service representative",style:TextStyle(color: Colors.orangeAccent,fontSize: 10,fontWeight: FontWeight.bold),),
        const Text(">>",style:TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold),),],),

      if(message.senderType==0) Text(message.message,style:const TextStyle(color: Colors.blue,fontSize: 20,fontWeight: FontWeight.bold),),
      if(message.senderType==1) Text(message.message,style:const TextStyle(color: Colors.orangeAccent,fontSize: 20,fontWeight: FontWeight.bold),),
    ],
  );
  Widget imageBox(MessageModel message) => Container(
    child: Column(children: [
      Row(children: [Text(message.time,style:const TextStyle(color: Colors.white,fontSize: 10,fontWeight: FontWeight.bold),),
        if(message.senderType==0)Text(data.user_name,style:const TextStyle(color: Colors.blue,fontSize: 10,fontWeight: FontWeight.bold),),
        if(message.senderType==1)const Text("Service representative",style:TextStyle(color: Colors.orangeAccent,fontSize: 10,fontWeight: FontWeight.bold),),
        const Text(">>",style:TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold),),],),
      Container(
        width: 300,
        height: 300,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color:app_colors.cameraPageInputimage,
          border: Border.all(width: 8, color: Colors.black12),
          borderRadius: BorderRadius.circular(12.0),
          image: DecorationImage(image: FileImage(File(message.get_path())), fit: BoxFit.cover),
        ),),
      Text(message.describe),



    ],),


  );
  Widget messageListView() => ListView(
     controller:_controller,
    children: <Widget>[
      for(MessageModel msg in messages) if(msg.messageType==0)messageBox(msg)
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
          newMsg=MessageModel(senderType: 0,
              messageType: 0,
              message: _message.text,
              describe: "non",
              time:  DateTime.now().toString().substring(10, 16));
          sendMessage();

        }

      },
      child:_sendingMessage? const CircularProgressIndicator(color: Colors.white, ): const Icon(Icons.send,size: 10,),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary:(my_socket.isconnect && (_message.text.isNotEmpty))? app_colors.sentMessagebutton:Colors.grey,
        minimumSize: const Size(40, 40),

      ),
    ),
  );


  Widget inputdescriptionTextField()=>Container(
    height:80,
    width:300,
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
  /////////////////////////Containers/////////////////////////////////////////////
  Widget mapContainer()=>Container(
      height:480,
      width: 400,
      decoration: BoxDecoration(
          color: app_colors.chatmessages,
          borderRadius: BorderRadius.circular(10),
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

      child: map_widget());

  ///////////////////////END Containers//////////////////////////////////////
////////######################TEXT############/////////////////////////////
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

  Widget loading()=> Center(child: CircularProgressIndicator(color: sendrequest?Colors.blue:Colors.grey, ));

////////######################END TEXT############/////////////////////////////
  Widget map_widget()=>FlutterMap(
    mapController: _mapController,
    options: MapOptions(
      screenSize:const Size(300,300),
      center: LatLng(lat,long),
      zoom: 20.0,
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
                return const Icon(Icons.location_on,size: 50.0,color: Colors.red);
              }
          ),
        ],
      ),
    ],

  );
  Widget mainStack()=>Stack(
  children: [
   if(chatOpen) Align(alignment: const Alignment(0.0,-0.5),child: chatContainer(),),
    if(!chatOpen) Align(alignment: const Alignment(0.0,-0.5),child: mapContainer(),),
    if(!chatOpen) Align(alignment: const Alignment(0.0,0.9),child: SOS_Button(),),
  if(my_socket.isconnect) Align(alignment: const Alignment(0.0,-1),child:connectedToServer())
  else Align(alignment: const Alignment(0.0,-1),child:notConnectedToServer()),
    if(calling) Align(alignment: const Alignment(0.0,-1),child:loading(),),





  ],
  );
  Widget chatContainer()=>SingleChildScrollView(
    reverse: true,
    child: Container(
      height:540,
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
              optionsButtons(),
              if(!imageShow)chatSendContainer(),
            ],

            ),
          ),
          Align(alignment: Alignment.topRight,child: CancelButton2(),),
          if(imageShow)Align(alignment: Alignment.topCenter,child: photoContainer(),),



        ],
      ),


    ),
  );
  ///////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
   return Scaffold
      (
      appBar: AppBar(
        centerTitle: true,
        title: Text(my_texts.CitySafty, style: TextStyle(color: app_colors.city_safty),),
        backgroundColor: app_colors.app_bar_background,
        elevation: 10,
        leading:  Icon(Icons.online_prediction,size: 40,color:requestResponse? Colors.lightGreenAccent:Colors.grey,),
        actions: [

          PopupMenuButton(
              color: Colors.grey,
              child:const Icon(Icons.language,color:Colors.orangeAccent,size: 40,) ,
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
            icon: const Icon( Icons.perm_identity_rounded,color:Colors.purple,size: 40,),
          ),


        ],
      ),
      backgroundColor: app_colors.background,
      body:Container(
        padding: const EdgeInsets.all(10),
        child: mainStack(),
      ),
    );
  }


}