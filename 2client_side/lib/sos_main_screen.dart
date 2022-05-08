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
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'local_data.dart';
import 'socket_class.dart';
import 'registration_page.dart';
import 'message_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_sound/flutter_sound.dart' as FS;
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'audio_model.dart';



class SOS extends StatefulWidget {
  const SOS({Key? key}) : super(key: key);

  @override
  State<SOS> createState() => _SOSState();
}

class _SOSState extends State<SOS> {
  final MapController _mapController=MapController();
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
  bool onProgress=false;
  bool _sendingMessage=false;
  bool _sendingPhotoMessage=false;
  bool _centeDissconected=false;
  bool _endCall=false;
  bool _record=false;
  File? imageFile;
  bool imageShow=false;
  final ScrollController _controller = ScrollController();
  int photoIndex=0;
  int audioIndex=0;
  int audioRecordIndex=0;
  static AudioCache player = AudioCache(prefix:'assets/sounds/');
  final recorder =FS.FlutterSoundRecorder() ;
  late File audioRecordFile;
  static late AudioPlayer audioPlayer;
  bool isRecorderReady=false;
  bool isAudioReady=false;
  bool isPlaying=false;
//  bool clientSigninEmit=false;
  Duration duration=Duration.zero;
  Duration position=Duration.zero;


  ////////////////////////Functions/////////////////////////////////////////////
  void socketListner() {
    my_socket.socket.on("sos_call_request_send", (client){
      print("sos_call_request_send");
      print(client);
      setState(() {
        sendrequest=true;
      });

    });


    my_socket.socket.on("end_call",(_){
      print("end_call");
      if(requestResponse) {
        endCall();
      }


    });


    my_socket.socket.on("centerDisconnected", (sourceId) async{
      print("centerDisconnected $sourceId");
      if( (requestResponse) && sourceId==targetSocket){
        centerDisconnected();
      }

    });

    my_socket.socket.on("SOS_Call_Respone", (id){
      print("SOS_Call_Respone");
      print(id);
      setState(() {
        targetSocket=id;
      });
      SOScallRespon();

    });

    my_socket.socket.on("get_message",(msg) {


      print("get msg");
      MessageModel getNewMsg=MessageModel(senderType:msg['senderType'] ,
          messageType: msg['messageType'],
          message: msg['message'],
          describe:msg['describe'],
          time: msg['time']);
      setState(() {
        messages.add(getNewMsg);
      });
      player.play('message.wav');
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
        data.clientSigninEmit=false;
      });
    });


    my_socket.socket.onConnect((data) {
      print("Connected to server2");
      if(!data.clientSigninEmit) {
        my_socket.socket.emit("clientSignin", my_socket.socket.id);
        data.clientSigninEmit=true;
      }
      setState(() {
        my_socket.isconnect=true;
      });
    });

    my_socket.socket.on("center_inactive", (_){
      print("center_inactive2");

      setState(() {
        my_socket.centerActive=false;
      });
    });

    my_socket.socket.on("center_active", (_)async{
      print("center_active");
      await Future.delayed(const Duration(seconds: 3));
      setState(() {
        my_socket.centerActive=true;
      });
    });



  }
  void endCall()async{
    setState(() {
      _endCall=true;
      requestResponse=false;
    });
    await Future.delayed(const Duration(seconds: 3));


    Navigator.push(context, MaterialPageRoute(builder: (context)=>(const SOS())),);

  }
  void centerDisconnected()async{
    setState(() {
      _centeDissconected=true;
    });
    await Future.delayed(const Duration(seconds: 3));


    Navigator.push(context, MaterialPageRoute(builder: (context)=>(const SOS())),);

  }
  void SOScallRespon(){
    player.play('sosResponse.wav');
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
    my_socket.socket.emit("SOS_Call",{'userName':data.user_name,'phone':data.phone,'lat':lat,'long':long});


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
    if(newMsg.messageType==2){
      print("its audio");
      final decodedBytes = base64Decode(newMsg.message);
      final directory = await getApplicationDocumentsDirectory();
      File file= File('${directory.path}/testRecord${audioIndex}.mp3');
      print(file.path);
      file.writeAsBytesSync(List.from(decodedBytes));
      newMsg.insert_path(file.path);
      audioIndex++;
      newMsg.audio=AudioModel();
      audioListner2(newMsg);
      newMsg.audio!.audioPlayer.setUrl(file.path,isLocal: true);
      await newMsg.audio!.audioPlayer.seek(newMsg.audio!.position);

    }

    setState(() {

      if(_sendingPhotoMessage) {
        _sendingPhotoMessage=false;
        imageShow=false;
      }
      if(newMsg.messageType==2) {
        _record=false;
        isAudioReady=false;
        duration=Duration.zero;
        position=Duration.zero;
        audioPlayer.stop();

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


    if(requestResponse) {
      my_socket.socket.emit("message",{'msg':newMsg.toMap(),'targetId':targetSocket});
    }
    else {
      my_socket.socket.emit("laterMessage", {newMsg.toMap()});
    }


  }

  //////////////////////////////////////////////////
  Future recordAudio() async {
    setState(() {
      _record=true;
    });
    await recorder.startRecorder(toFile:'audio$audioRecordIndex'
    );
    audioRecordIndex++;

  }
  Future stopRecord() async {
    if (!isRecorderReady) return;
    final path= await recorder.stopRecorder();
    audioRecordFile=File(path!);
    print('Recorder audio: $audioRecordFile');
    position=Duration.zero;
    audioPlayer=AudioPlayer();
    audioListner();
    audioPlayer.setUrl(path,isLocal: true);
    await audioPlayer.seek(position);
    setState(() {
      isAudioReady=true;
      position=Duration.zero;
    });

    print("yoyo");

  }
  Future initRecorder()async{
    print("record init");
    final status=await Permission.microphone.request();
    print("record init1");
    if(status!=PermissionStatus.granted){
      throw 'microphone permission not granted';
    }
    print("record init2");
    await recorder.openRecorder();
    isRecorderReady=true;
    print("record init3");
    recorder.setSubscriptionDuration(
      const Duration(milliseconds:500),
    );
  }
  Future audioListner()async{
    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying=state==PlayerState.PLAYING;});
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      print("newDuration");
      setState(() {duration=newDuration;});

    });

    audioPlayer.onAudioPositionChanged.listen((newPosition) {
      setState(() {position=newPosition;});

    });

  }
  Future audioListner2(MessageModel msg)async{

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
  void sendAudio(){
    print('$audioRecordFile');
    List<int> audioBytes = audioRecordFile.readAsBytesSync();
    String base64Image = base64Encode(audioBytes);
    newMsg=MessageModel(senderType: 0,
        messageType:2,
        message: base64Image,
        describe: "non",
        time: DateTime.now().toString().substring(10, 16));


    sendMessage();

  }

  ////////////////////////////////////

  @override
  void initState() {
    super.initState();
    if(my_socket.isconnect && !data.clientSigninEmit) {
      my_socket.socket.emit("clientSignin", my_socket.socket.id);
      data.clientSigninEmit=true;
    }

    print("init sos page");
    data.getData();
    socketListner();
    timer = Timer.periodic(const Duration(seconds:1), (Timer t) => ButtonRotator());
    initRecorder();

    initMap();
  }
  @override
  void dispose() {
    timer?.cancel();
    recorder.closeRecorder();
    audioPlayer.dispose();
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
  Widget recordShowStreamBuilder()=>StreamBuilder<FS.RecordingDisposition>(
      stream: recorder.onProgress,
      builder:(context,snapshot){
        final duration=snapshot.hasData
            ? snapshot.data!.duration
            : Duration.zero;
        //  return Text('${duration.inSeconds} s',style: TextStyle(color: Colors.black,fontSize: 50),);
        String toDigits(int n)=>n.toString().padLeft(2,'0');
        final toDigitMinutes=toDigits(duration.inMinutes.remainder(60));
        final toDigitSeconds=toDigits(duration.inSeconds.remainder(60));
        return Text(
          '$toDigitMinutes:$toDigitSeconds',
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
          ),
        );
      }
  );

  Widget mainRecordAudioContainer()=>Container(
    height:200,
    width: 350,
    // color: Colors.green,
    child: Stack(children: [
      if(isAudioReady) Align(alignment:Alignment.center,child: playRecordPartContainer(),)
      else Align(alignment:Alignment.center ,child: recordPartContainer(),),

    ],),

  );
  Widget recordPartContainer()=>Container(
    height:80,
    width: 200,
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
        color: app_colors.recorderTimeShow,
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
    child:Center(child: recordShowStreamBuilder()),

  );
  Widget recordPlayStateShowContainer()=>Container(
    height: 50,
    width: 250,
    child: Stack(children: [
      Align(alignment: Alignment.centerLeft,child:Text(formatTime(position)) ,),
      Align(alignment: Alignment.centerRight,child:  Text(formatTime(duration-position)),),

    ],),
  );

  Widget playRecordPartContainer()=>Container(
    height:130,
    width: 400,
    padding: const EdgeInsets.all(15),
    decoration: BoxDecoration(
        color: app_colors.recorderTimeShow,
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
      Align(alignment: const Alignment(0,-1) ,child: audioPlaySlider(),),
      Align(alignment:const Alignment(0,1) ,child: playRecordButton()),
      Align(alignment:const Alignment(0,0)  ,child:recordPlayStateShowContainer()),
      Align(alignment:const Alignment(1,1)  ,child:sendAudioButton()),
      Align(alignment:const Alignment(0.7,1)  ,child:cancelAudio()),

    ],),


  );
  Widget audioPlaySlider()=>SizedBox(
    height: 50,
    width: 350,
    child: Slider(
        min: 0,
        max: duration.inSeconds.toDouble(),
        value: position.inSeconds.toDouble(),
        onChanged: (value)async{
          final position=Duration(seconds: value.toInt());
          await audioPlayer.seek(position);
          await audioPlayer.resume();



        }),
  );
  Widget audioPlaySlider2(MessageModel msg)=>SizedBox(
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
  Widget recordPlayStateShowContainer2(Duration dr , Duration ps)=>Container(

    height: 50,
    width: 250,
    child: Stack(children: [
      Align(alignment: Alignment.centerLeft,child:Text(formatTime(ps)) ,),
      Align(alignment: Alignment.centerRight,child:  Text(formatTime(dr-ps)),),

    ],),
  );
////////////////////////BUTTONSSSS//////////////////////////////////////////
  Widget languageButton()=> PopupMenuButton(
      color: Colors.grey,
      child: Icon(Icons.language,color:app_colors.languageButton,size: 40,) ,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Text("العربية"),
          value: 1,
          onTap: (){print("change to arbic");
          setState(() {
            my_texts.changeToArabic();
          });
          data.language=1;
          data.updateData();
          },
        ),
        PopupMenuItem(
          child: const Text("English"),
          value: 1,
          onTap: (){
            print("change to english");
            setState(() {
              my_texts.changeEnglish();
            });
            data.language=0;
            data.updateData();

          },
        ),
        PopupMenuItem(
          child: const Text("עברית"),
          value: 1,
          onTap: (){
            print("change to עברית");
            setState(() {
              my_texts.changeToHebrew();
            });
            data.language=2;
            data.updateData();

          },
        ),
      ]
  );
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
        player.play('button.mp3');
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
        player.play('button.mp3');
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
  Widget recordAudioButton()=>Container(
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
    child: ElevatedButton(
      onPressed: (){
        if(_record) {
          stopRecord();

        } else {
          _record=true;
          recordAudio();
        }

      },
      child: Icon(_record? Icons.stop :Icons.mic, size: 30.0,),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary: app_colors.record_audio_button,
        minimumSize:const Size(60.0, 60.0),

      ),
    ),
  );
  Widget playRecordButton()=>Container(
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
    child: ElevatedButton(
      onPressed: () async{

        if(isPlaying){
          await audioPlayer.pause();
        }
        else{
          //  String url='https://www.soundhelix.com/examples/mp3/SoundHelix-Song-13.mp3';
          audioPlayer.resume();

        }


      },
      child: Icon(isPlaying? Icons.pause :Icons.play_arrow,size: 20,),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary: app_colors.record_audio_button,
        minimumSize:const Size(50.0, 50.0),

      ),
    ),
  );
  Widget playRecordButton2(MessageModel msg)=>Container(
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
        primary: app_colors.record_audio_button,
        minimumSize:const Size(30, 30),

      ),
    ),
  );
  Widget SOS_Button()=>Container
    (
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

        backgroundColor: (my_socket.isconnect && my_socket.centerActive)? app_colors.sos_button: app_colors.sos_disablbutton,
        onPressed: () {
          //  player.play('SOScall.wav');
          print("SOS button pressed");
          if(my_socket.isconnect )SOS_Call();

        },
      ),
    ),
  );
  Widget CancelButton()=>Container(
    height: 50,
    width: 110,
    decoration: BoxDecoration(
        color: Colors.red,
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

    child:IconButton(

      //child: Icon(Icons.ac_unit),
      icon: Text(my_texts.endContact,style: const TextStyle(color: Colors.white,fontSize:15),),
      //  backgroundColor: app_colors.cancel_button,
      onPressed: () {
        player.play('cancel.wav');
        my_socket.socket.emit("cancel");

        Navigator.push(context, MaterialPageRoute(builder: (context)=>(const SOS())),);
        print("Cancel button pressed");

      },
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
  Widget sendPhotoButton()=>Container(
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
  Widget sendAudioButton()=>Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: const Offset(5,3)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: const Offset(-5,-3)

          ),
        ]
    ),

    child: SizedBox(height: 20,
      width: 20 ,
      child:
      FloatingActionButton(
        //child: Icon(Icons.ac_unit),
        child: const Icon(Icons.check,size:20,color:Colors.lightGreenAccent),
        backgroundColor: Colors.black.withOpacity(0),
        onPressed: () {
          print("send audio button pressed");
          sendAudio();

        },

      ),
    ),
  );
  Widget cancelAudio()=>Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
        boxShadow:[
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: const Offset(5,3)

          ),
          BoxShadow(
              color: app_colors.buttom_shadow,
              blurRadius: 20,
              offset: const Offset(-5,-3)

          ),
        ]
    ),

    child: SizedBox(height: 20,
      width: 20 ,
      child:
      FloatingActionButton(
        //child: Icon(Icons.ac_unit),
        child: const Icon(Icons.clear,size:20,color:Colors.red),
        backgroundColor: Colors.black.withOpacity(0),
        onPressed: ()async {
          setState(() {
            _record=false;
            isAudioReady=false;
            duration=Duration.zero;
            position=Duration.zero;
            audioPlayer.stop();

          });
          print("Cancel audio button pressed");


        },
      ),
    ),
  );
  Widget optionsButtons()=>Container(
    height:70,
    width: 230,
    // color:Colors.lightGreenAccent,

    child: Stack(
        children: [
          if(!_record) Align(alignment: Alignment.centerLeft,child: Camera_Button(),),
          if(!_record) Align(alignment: Alignment.centerRight,child: gallery_Button(),),
          if(!isAudioReady) Align(alignment: Alignment.center,child:recordAudioButton(),),

        ]

    ),
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
            child: Row(children: [CancelPhoto(),const SizedBox(width: 5,),sendPhotoButton()],))),
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
          hintStyle: const TextStyle(color: Colors.black),
        ),
        style: const TextStyle(color: Colors.black),
      ),
    ),



  );
  Widget messagesContainer()=>Container(
    height: 380,
    width: 380,
    padding: const EdgeInsets.fromLTRB(5, 15, 5, 15),
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
  Widget messageDetails(MessageModel msg)=>Row(
      children: [
        Text(msg.time,style:const TextStyle(color: Colors.white,fontSize: 10,fontWeight: FontWeight.bold),),
        if(msg.senderType==0)Text(data.user_name,style:const TextStyle(color: Colors.blue,fontSize: 10,fontWeight: FontWeight.bold),),
        if(msg.senderType==1)const Text("Service representative",style:TextStyle(color: Colors.orangeAccent,fontSize: 10,fontWeight: FontWeight.bold),),
        const Text(">>",style:TextStyle(color: Colors.black,fontSize: 10,fontWeight: FontWeight.bold),),
      ]);
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
  Widget imageBox(MessageModel message) =>  Column(children: [
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

  ],


  );
  Widget audioBox(MessageModel message) => Container(
    height: 80,
    // color: Colors.black38,
    child: Stack(children: [
      Align(alignment: const Alignment(0,-1) ,child: audioPlaySlider2(message),),
      Align(alignment: const Alignment(-1,-1) ,child: playRecordButton2(message),),
      Align(alignment:const Alignment(0,0)  ,child:recordPlayStateShowContainer2(message.audio!.duration,message.audio!.position)),


    ],),
  );
  Widget messageListView() => ListView(
    controller:_controller,
    children: <Widget>[
      for(MessageModel msg in messages)
        Column(children: [
          messageDetails(msg),
          if(msg.messageType==0)messageBox(msg)
          else if(msg.messageType==1) imageBox(msg)
          else audioBox(msg)

        ],)


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
          fillColor: app_colors.textInputFill,
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
      height:450,
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

  Widget centerDisconnectedText()=> Text(
    my_texts.centerDissconected,
    style:const TextStyle(
      fontSize:25,
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
  Widget endCallText()=> Text(
    my_texts.endCall,
    style:const TextStyle(
      fontSize:15,
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
  Widget centerInactive()=> Text(
    my_texts.centerInactive,
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
      if(chatOpen) Align(alignment: const Alignment(0.0,-0.5),child: mainChatContainer(),),
      if(!chatOpen) Align(alignment: const Alignment(0.0,-0.5),child: mapContainer(),),
      if(!chatOpen) Align(alignment: const Alignment(0.0,0.9),child: SOS_Button(),),
      if(!my_socket.isconnect) Align(alignment: const Alignment(0.0,-1),child:notConnectedToServer()),
      if(my_socket.isconnect && my_socket.centerActive) Align(alignment: const Alignment(0.0,-1),child:connectedToServer()),
      if(my_socket.isconnect && !my_socket.centerActive) Align(alignment: const Alignment(0.0,-1),child:centerInactive()),
      //if(calling) Align(alignment: const Alignment(0.0,-1),child:loading(),),





    ],
  );
  Widget mainChatContainer()=>SingleChildScrollView(
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
              if(!imageShow && !_record)chatSendContainer(),
            ],

            ),
          ),
          Align(alignment: Alignment.topRight,child: CancelButton(),),
          if(imageShow)Align(alignment: Alignment.topCenter,child: photoContainer(),),
          if(_centeDissconected) Align(alignment: const Alignment(0,-0.4),child: centerDisconnectedText()),
          if(_endCall) Align(alignment: Alignment.center,child: endCallText()),
          if(_record)Align(alignment: const Alignment(0,0),child: mainRecordAudioContainer()),



        ],
      ),


    ),
  );
  Widget rahatLogo()=>Container(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      child: const Image(
        image: AssetImage('assets/images/rahatLogo2.png'),
        height: 70,
        width:70,
      )

  );
  ///////////////////////////////////////////////////////////////////
  @override
  Widget build(BuildContext context) {
    return Scaffold
      (
      appBar: AppBar(
        centerTitle: true,
        title:
        rahatLogo(),


        backgroundColor: app_colors.app_bar_background,
        elevation: 10,
        automaticallyImplyLeading: false,

        leading: Icon(Icons.online_prediction,size: 40,color:requestResponse? Colors.lightGreenAccent:Colors.grey,),

        actions: [
          languageButton(),
          IconButton(
            onPressed:() {
              if(!chatOpen){
               Navigator.push(context, MaterialPageRoute(builder: (context)=> (const Registor())));
              }
              }
              ,

            icon: Icon( Icons.perm_identity_rounded,color: chatOpen? Colors.grey :Colors.pink,size: 40,),
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