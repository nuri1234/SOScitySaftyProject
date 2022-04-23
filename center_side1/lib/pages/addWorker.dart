import 'package:center_side/compount/drawer.dart';
import 'package:flutter/material.dart';
import 'package:center_side/compount/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../dbHelper/worker_managment.dart';
import '../dbHelper/worker_model.dart';
import '../example2.dart';

class AddWorker extends StatefulWidget {
  const AddWorker({Key? key}) : super(key: key);

  @override
  State<AddWorker> createState() => _AddWorkerState();
}

class _AddWorkerState extends State<AddWorker> {
  final TextEditingController _fullName= TextEditingController();
  final TextEditingController _userName= TextEditingController();
  final TextEditingController _password= TextEditingController();

  void addWorker()async{
    var user=await searchUser(_userName.text);
    if(user.password==_password.text){
      print("ok");
      Navigator.push(context, MaterialPageRoute(builder: (context)=>(const examplePage2())),);
    }
    else print("no match");

    if(user==null) print("user not found");
  }

  Widget NextButton()=>Container(
    height: 100.0,
    width: 200.0,
    child:
    FloatingActionButton(
      //child: Icon(Icons.ac_unit),
      child: Text("הוספה",style: TextStyle(fontSize: 20,color: Colors.black),),

      backgroundColor: Colors.blue,
      onPressed: () {
        print("Next");
        addWorker();

      },
    ),
  );

  Widget fullNameTextField()=>Container(
    height:100,
    width:200,
    child: TextField(
      decoration: InputDecoration(
          hintText: "fullName",
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
      controller: _fullName,
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
    height:400,
    width:400,
    color: Colors.black,
    padding: EdgeInsets.all(8),
    child: Stack(children: [
      Align(alignment: const Alignment(0, -1),child: fullNameTextField(),),
      Align(alignment: const Alignment(0, -2),child: userNameTextField(),),
      Align(alignment: const Alignment(0, 0),child: passwordTextField(),),

    ],),
  );
  Widget mainStack()=>Stack(children: [
    ListView(children: [
      Container(
          height: 100,
          width: double.infinity,


      ),
      Container(
        child:Align(alignment: const Alignment(0, 0),child: inputContainer(),),
      ),
      // Container(
      //   child:Align(alignment: const Alignment(0, 0.8),child: NextButton(),),
      // )
    ],)


  ],);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: Text("הוספת עובד חדש"),
            backgroundColor: Colors.blue,
            centerTitle: true,
            elevation: 6,

          ),
          backgroundColor: Colors.white,
          drawer: MyDrawer(),
          body:mainStack(),
      ),
    );
  }
}
