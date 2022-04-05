import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';
import 'dbHelper/call_class.dart';
import 'dbHelper/calldb_management.dart';


class connectionPage extends StatefulWidget {
  const connectionPage({Key? key}) : super(key: key);

  @override
  State<connectionPage> createState() => _connectionPageState();
}

class _connectionPageState extends State<connectionPage> {
  late IO.Socket socket;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    connect();
  }


  void connect() {
    socket = IO.io("http://localhost:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,
    });
    socket.connect();
    socket.onConnect((data) {
      print("Connected");
      socket.emit("/signin", 1);
      socket.on("message", (msg) {
        print(msg);
      });

      socket.on("SOS", (msg){
        print(msg);
        setState(() {
        });
      });

    });




    print(socket.connected);
    print("here99");



  }

  @override
  void dispose() {
    //socket.emit("/disconnect");
    socket.disconnect();
    super.dispose();
  }

  void sendMessage(String message, int sourceId, int targetId) {
    socket.emit("message",
        {"message": message, "sourceId": sourceId, "targetId": targetId});
    print("send");
  }

  void SoS(Call call) {
    socket.emit("SOS",
        {call.toMap()});
    print("send");
  }

  @override
  Widget build(BuildContext context) {
    int i=0;
    return Scaffold(


      body: Center(
        child: IconButton(onPressed: ()async{
          //Call call=await newCall("lolo", "0542256688",0.5, 0.6, 0);
          //SoS(call);
       // sendMessage("msg $i", 1, 1);
        i++;},
         icon: const Icon(Icons.volume_up),
    ),
      ));
  }
}
/*void callConnect() async {
  my_socket.socket = IO.io("http://192.168.1.233:5000", <String, dynamic>{
    "transports": ["websocket"],
    "autoConnect": false,} );

  my_socket.socket.connect();
  my_socket.socket.onConnect((data) {
    print("Connected");

    my_socket.socket.emit("clientSignin",1);
    my_socket.socket.on("SOS", (msg){
      print("recive SOS");
      print(msg['userName']);
      print("hhhh");
      print(msg);
    });
    my_socket.socket.on("Received", (msg){
      print("recive SOS");

      print(msg);
    });

    my_socket.socket.on("sos_send", (msg){
      print("sos_send");
      print(msg);
      setState(() {
        _sent=true;
      });



    });
  });


  print(my_socket.socket.connected);

}

*/