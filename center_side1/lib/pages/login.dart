import 'package:flutter/material.dart';
import 'package:center_side/dbHelper/user_management.dart';
import 'package:center_side/dbHelper/user_management.dart';
import 'package:center_side/example2.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  State<LogIn> createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final TextEditingController _userName= TextEditingController();
  final TextEditingController _password= TextEditingController();

  void chekUser()async{
    var user=await searchUser(_userName.text);
    if(user.password==_password.text){
      print("ok");
      Navigator.push(context, MaterialPageRoute(builder: (context)=>(const examplePage2())),);
    }
    else print("no match");

    if(user==null) print("user not found");
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(textDirection: TextDirection.rtl, child: Scaffold(
      appBar: AppBar(
        title: Text('כניסה למערכת'),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.back_hand)),
        ],
      ),
      body: ListView(children: [
        Form(child: Column(children: [
          TextFormField(
            decoration: InputDecoration(hintText: null),
          )
        ],))
      ],)
    ));

  }
}
