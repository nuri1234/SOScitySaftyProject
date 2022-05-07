import 'package:client_side/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'texts.dart';
import 'colors.dart';
import 'local_data.dart';
import 'sos_main_screen.dart';
import 'verify_phone_number_page.dart';


class Registor extends StatefulWidget {


  const Registor({Key? key}) : super(key: key);

  @override
  State<Registor> createState() => _RegistorState();
}



class _RegistorState extends State<Registor> {
  final TextEditingController _user_name= TextEditingController();
  bool _save=false;
  bool isLoading=true;


  @override
  void initState(){
    super.initState();
    data.getData();
    setState(() {
      _user_name.text=data.user_name;
    });

  }
  void save(){

    setState(() {
      _save=false;
    });
    print("save");

    data.user_name=_user_name.text;
    data.updateData();

  }

  Widget languageButton()=> PopupMenuButton(
      color: Colors.grey,
      child: Icon(Icons.language,color:app_colors.languageButton,size: 40,) ,
      itemBuilder: (context) => [
        PopupMenuItem(
          child: const Text("عربيه"),
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
///////////////////////////////
  Widget logo()=>Container(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      child: const Image(
        image: AssetImage('assets/images/logo.png'),
        height: 150,
        width: 150,
      )

  );
  Widget welcome()=> DefaultTextStyle(
    style: GoogleFonts.pacifico(fontSize: 50,fontWeight: FontWeight.w300,color: app_colors.Welcome),
    child: Text(my_texts.welcome),

  );
  Widget welcomeContainer()=>Container(
    // color: Colors.red,
      height: 200,
      width:350,
      child:Stack(children: [
        Align(alignment: Alignment.topCenter,child: welcome(),),
        Align(alignment: const Alignment(0.0,1),child: logo(),),

      ],)

  );
  Widget saveButton()=>IconButton(
    key:Key('saveButton'),
    onPressed: _save? save: (){},
    icon:Icon(Icons.save,size: 50,color: _save? Colors.green: Colors.grey,) ,

  );
  Widget continueButton()=>Container(
    height: 70,
    width: 150,

    child: IconButton(
      onPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>(const SOS())),);
      },
    icon: const Icon(Icons.next_plan_rounded,color: Colors.blue,),
      iconSize: 50,

      ),

  );
  Widget clear_phone()=>IconButton(
    onPressed: (){

      setState(() {
        data.phone="non";
        data.phone_verified=false;
      });
      data.updateData();
    },
    icon:const Icon(Icons.clear,size: 20,color:Colors.red,) ,

  );
  Widget inputPhone_Button()=>Container(
    height: 70,
    width: 150,
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

        Navigator.push(context, MaterialPageRoute(builder: (context)=>(const verifyPhone())),).then((_) =>setState(() {}) );

}
      ,
      child:Text(my_texts.inputPhone,style:TextStyle(color: app_colors.text_button,fontWeight:FontWeight.bold ,fontSize: 18)),
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(200.0)),
        primary:app_colors.button,
        minimumSize: Size(70.0, 70.0),

      ),
    ),
  );
////////////////////////////////////////////////////
  Widget inputuserNameTextField()=>Container(
    height:110,
    width:300,
    padding: EdgeInsets.all(20),
    child: TextField(
      key:Key('userNameTextField'),
      decoration: InputDecoration(
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color:app_colors.BorderSide, width: 0.0),
          borderRadius: BorderRadius.circular(20.0),
        ),
        focusedBorder:OutlineInputBorder(
          borderSide: BorderSide(color:app_colors.BorderSide, width: 2.0),
          borderRadius: BorderRadius.circular(20.0) ,

        ),
        prefixIcon:Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text("${my_texts.username} : ",style: GoogleFonts.aBeeZee(fontSize:20,fontWeight: FontWeight.bold,color: Colors.black),),
        ),
        fillColor: app_colors.textInputFill,

        filled: true,
      ),
      maxLines: 15,
      controller: _user_name,
      style:  GoogleFonts.aBeeZee(fontSize:20,fontWeight: FontWeight.bold,color: Colors.green,),
      textAlign: TextAlign.left,
      onChanged: (_user_name){setState(() {
        _save=true;
      });},
    ),
  );
  Widget deatailsContainer()=>Container(
    // color: Colors.red,
    height: 110,
    width:350,
    // color: Colors.pink,
    child: Stack(
      children: [
        Align(alignment: const Alignment(-1,-1),child:inputuserNameTextField(),),
        Align(alignment: const Alignment(0.9,-0.4),child:saveButton(),),


      ],

    ),
  );
  Widget mainColumn()=>SingleChildScrollView(
      reverse: true,
      child: Column(
          children: [
            Center(child: logo(),),
            Container(
                height: 150,
                width: 300,
                // color: Colors.black12,
                child: my_texts.explaneText),
            deatailsContainer(),
            if(data.phone_verified) Center(
              child: Container(
                height: 80,
                width: 310,
                //color: Colors.white,
                child: Row(
                  children: [
                    Text(" ${my_texts.phoneNumber}: ${data.phone}",style: TextStyle(fontSize: 20),),
                    clear_phone()
                  ],
                ),
              ),
            ),
            if(!data.phone_verified) inputPhone_Button(),
            const SizedBox(height: 10,),
            continueButton() ,
          ]
      ));
  Widget mainStack()=>Stack(
    children: [
      Align(alignment: const Alignment(0,-0.5),child:mainColumn(),),
      //   Align(alignment: const Alignment(0,-0.7),child:welcomeContainer()),
      // Align(alignment: const Alignment(1,-0.9),child:continueButton() ),
      Align(alignment: const Alignment(-1,-0.9),child:languageButton()),

    ],

  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: app_colors.background,
      body:mainStack(),
    );
  }
}
