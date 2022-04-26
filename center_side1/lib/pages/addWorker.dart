import 'package:center_side/compount/colors.dart';
import 'package:center_side/compount/drawer.dart';
import 'package:flutter/material.dart';
import 'package:center_side/compount/drawer.dart';
import 'package:flutter/cupertino.dart';
import 'package:center_side/dbHelper/mongodb.dart';
import '../dbHelper/worker_managment.dart';
import '../dbHelper/worker_model.dart';
import '../example2.dart';
import 'package:center_side/dbHelper/worker_model.dart';
import 'package:mongo_dart/mongo_dart.dart'as M;

class AddWorker extends StatefulWidget {
  const AddWorker({Key? key}) : super(key: key);

  @override
  State<AddWorker> createState() => _AddWorkerState();
}

class _AddWorkerState extends State<AddWorker> {
  final TextEditingController _fullName= TextEditingController();
  final TextEditingController _userName= TextEditingController();
  final TextEditingController _password= TextEditingController();

  Future<void> addWorker(String fullName,String userName,String password)async{
    var _id=M.ObjectId();
    final data=WorkerModel(id: _id, fullName: fullName, userName: userName, password: password);
    var result=await MongoDB.insertWorker(data);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Inserting "+fullName.toString())));
    _clearAll();
    //var worker=await MongoDB.insertWorker(_fullName.text,_userName.text,_password.text);
    // print("ok");
    //Navigator.push(context, MaterialPageRoute(builder: (context)=>(Container())),);

  }
  void _clearAll(){
    _fullName.text="";
    _userName.text="";
    _password.text="";
  }

  Widget NextButton()=>Container(
    height: 100.0,
    width: 200.0,
    padding: EdgeInsets.all(8),
    child:
    FloatingActionButton(
      //child: Icon(Icons.ac_unit),
      child: Text("הוספה",style: TextStyle(fontSize: 20,color: Colors.black),),

      backgroundColor: app_colors.app_bar_background,
      onPressed: () {
        print("Next");
        addWorker(_fullName.text,_userName.text,_password.text);

      },
    ),
  );

  Widget fullNameTextField()=>Container(
    height:100,
    width:250,
    child: TextField(
      decoration: InputDecoration(
          hintText: "שם מלא",
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color:Colors.black, width: 5.0),
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedBorder:OutlineInputBorder(
            borderSide: const BorderSide(color:Colors.black, width: 2.0),
            borderRadius: BorderRadius.circular(20.0) ,

          ),
          fillColor: app_colors.background,
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
    width:250,
    child: TextField(
      decoration: InputDecoration(
          hintText: "שם משתמש",
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color:Colors.black, width: 5.0),
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedBorder:OutlineInputBorder(
            borderSide: const BorderSide(color:Colors.black, width: 2.0),
            borderRadius: BorderRadius.circular(20.0) ,

          ),
          fillColor: app_colors.background,
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
    width:250,
    child: TextField(
      decoration: InputDecoration(
          hintText: "סיסמה",
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color:Colors.black, width: 5.0),
            borderRadius: BorderRadius.circular(20.0),
          ),
          focusedBorder:OutlineInputBorder(
            borderSide: const BorderSide(color:Colors.black, width: 2.0),
            borderRadius: BorderRadius.circular(20.0) ,

          ),
          fillColor: app_colors.background,
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
    color: app_colors.boxBackground,
    padding: EdgeInsets.all(8),
    child: Stack(children: [
      Align(alignment: const Alignment(0, -1.1),child:SizedBox(height: 50,)),
      Align(alignment: const Alignment(0, -1),child: fullNameTextField(),),
      Align(alignment: const Alignment(0, -0.4),child: userNameTextField(),),
      Align(alignment: const Alignment(0, 0.3),child: passwordTextField(),),
      Align(alignment: const Alignment(0, 0.9),child: NextButton(),),

    ],),
  );
  Widget mainStack()=>Stack(children: [
    ListView(children: [
      Container(
       width: double.infinity,
       height: 100,
      ),
      Container(
        child:Align(alignment: const Alignment(0, 0),child: inputContainer(),),
      ),
    ],)


  ],);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          leading:IconButton
              (
                icon:Icon(Icons.logout),
            onPressed: (){
                  Navigator.of(context).popAndPushNamed('homePage');
            },

            ),
          actions: [
            IconButton(icon: Icon(Icons.arrow_back),onPressed: (){
              Navigator.of(context).popAndPushNamed('workerList');
            },),
          ],
          title: Text("הוספת עובד חדש"),
          backgroundColor: app_colors.app_bar_background,
          centerTitle: true,
          elevation: 6,


        ),
        backgroundColor: app_colors.background,
        drawer: MyDrawer(),
        body:mainStack(),
      ),
    );
  }
}
