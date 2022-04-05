import 'package:socket_io_client/socket_io_client.dart' as IO;
class my_socket {
  static late IO.Socket socket;
  static bool isconnect = false;


  static connect() {
    socket = IO.io("http://192.168.1.233:5000", <String, dynamic>{
      "transports": ["websocket"],
      "autoConnect": false,});

    socket.connect();
    socket.onConnect((data) {
      print("Connected");
      socket.emit("clientSignin", socket.id);
      isconnect = true;
    });
  }





}
