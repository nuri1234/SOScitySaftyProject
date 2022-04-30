import 'package:center_side/compount/colors.dart';
import 'package:center_side/compount/drawer.dart';
import 'package:center_side/pages/maneger.dart';
import 'package:center_side/pages/workPage.dart';
import 'package:center_side/sos/sos_main_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../dbHelper/worker_managment.dart';
import '../dbHelper/worker_model.dart';
import '../example2.dart';
import 'package:center_side/uses/share_data.dart';
import 'package:center_side/dbHelper/mng_managment.dart';


class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  State<SignIn> createState() => _SignInState();
}


class _SignInState extends State<SignIn> {
  var islogin;
  final TextEditingController _userName= TextEditingController();
  final TextEditingController _password= TextEditingController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _password.text="";
  }
  void chekUser()async{
    var user=await searchWorker(_userName.text);
    var mng=await searchMng(_userName.text);
    if(user.password==_password.text || mng.password==_password.text){
      print("ok");
      data.userName=_userName.text;
      Navigator.push(context, MaterialPageRoute(builder: (context)=>(const SOS())),);
    }
    else{if(_userName.text=='mng1'&&_password.text=='an123'){
      Navigator.push(context, MaterialPageRoute(builder: (context)=>(const ManagerPage())),);

    }
    } print("no match");

    if(user==null) print("user not found");
  }


  Widget NextButton()=>Container(
    height: 100.0,
    width: 200.0,
    child:
    FloatingActionButton(
      //child: Icon(Icons.ac_unit),
      child: Text("כניסה",style: TextStyle(fontSize: 20,color: Colors.black),),

      backgroundColor: Colors.orange,
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
    width:200,
    child: TextField(
        obscureText: true,
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
    height: 300,
    width: 300,
    color: app_colors.background,
    padding: EdgeInsets.all(8),
    child: Stack(children: [
      Align(alignment: const Alignment(0, -1),child: userNameTextField(),),
      Align(alignment: const Alignment(0, 0),child: passwordTextField(),),

    ],),

  );

  Widget mainStak()=>Stack(children: [
    ListView(children: [
      Container(
          height: 180,
          width: double.infinity,
          child:Image.asset('assets/images/logo.png',fit: BoxFit.contain,)

      ),
      Container(
        child:Align(alignment: const Alignment(0, 0),child: inputContainer(),),
      ),
      Container(
        child:Align(alignment: const Alignment(0, 0.8),child: NextButton(),),
      )

    ],)


  ],);



  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child:Scaffold(
          appBar: AppBar(
            backgroundColor: app_colors.app_bar_background,
            title: Text('כניסה למערכת'),
            centerTitle: true,
          ),
          backgroundColor: app_colors.background,
          body: mainStak(),

        ));
  }
}