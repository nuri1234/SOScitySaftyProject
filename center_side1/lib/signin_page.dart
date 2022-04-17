import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dbHelper/user_management.dart';
import 'dbHelper/user_model.dart';
import 'example2.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}


class _SignInState extends State<SignIn> {
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

  Widget NextButton()=>SizedBox(
    height: 100.0,
    width: 100.0,
    child:
    FloatingActionButton(
      //child: Icon(Icons.ac_unit),
      child: Text("Next",style: TextStyle(fontSize: 15,color: Colors.black),),

      backgroundColor: Colors.blue,
      onPressed: () {
        print("Next");
        chekUser();

      },
    ),
  );

  Widget userNameTextField()=>Container(
    height:100,
    width:200,
    child: TextField(
      decoration: InputDecoration(
          hintText: "userName",
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color:Colors.black, width: 5.0),
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedBorder:OutlineInputBorder(
            borderSide: const BorderSide(color:Colors.black, width: 2.0),
            borderRadius: BorderRadius.circular(20.0) ,

          ),
          fillColor: Colors.white,
          filled: true,
          prefix: const Padding(
            padding: EdgeInsets.all(4),
          ) ),
      maxLines: 1,
      maxLength: 20,
      controller: _userName,
    ),
  );
  Widget passwordTextField()=>Container(
    height:100,
    width:200,
    child: TextField(
      decoration: InputDecoration(
          hintText: "password",
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color:Colors.black, width: 5.0),
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedBorder:OutlineInputBorder(
            borderSide: const BorderSide(color:Colors.black, width: 2.0),
            borderRadius: BorderRadius.circular(20.0) ,

          ),
          fillColor: Colors.white,
          filled: true,
          prefix: const Padding(
            padding: EdgeInsets.all(4),
          ) ),
      maxLines: 1,
      maxLength: 20,
      controller: _password,
    ),
  );

  Widget inputContainer()=>Container(
    height: 300,
    width: 300,
    color: Colors.redAccent,
    padding: EdgeInsets.all(5),
    child: Stack(children: [
      Align(alignment: const Alignment(0, -1),child: userNameTextField(),),
      Align(alignment: const Alignment(0, 0),child: passwordTextField(),),

    ],),

  );

  Widget mainStak()=>Stack(children: [
    Align(alignment: const Alignment(0, 0),child: inputContainer(),),
    Align(alignment: const Alignment(0, 0.8),child: NextButton(),),


  ],);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("app bar"),
      ),
      backgroundColor: Colors.lightGreen,
      body: mainStak(),



    );
  }
}