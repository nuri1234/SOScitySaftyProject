import 'package:client_side/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'texts.dart';
import 'colors.dart';
import 'local_data.dart';
import 'sos_screen.dart';

class first extends StatefulWidget {
  const first({Key? key}) : super(key: key);

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {
  final double button_h=100;
  final double button_w=100;
  final double button_fontSize=15;
  bool isLoading=true;


  void loadData() async{
    await Future.delayed(Duration(milliseconds: 5000),(){});
    //  await data.initData();
    await data.getData();
    print(data.first_time);
    setState(() {
      isLoading=false;
    });

  }
  @override
  void initState() {
    super.initState();
    loadData();
  }
  void anonymousButtonAction(){
    data.first_time=false;
    data.anonymous=true;
    data.updateData();
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Sos()),);

  }

  void nonAnonymousButtonAction(){
    data.first_time=false;
    data.anonymous=false;
    data.updateData();
    Navigator.push(context, MaterialPageRoute(builder: (context)=>Sos()),);

  }

  Widget loading()=>const Center(child: CircularProgressIndicator(color: Colors.black, ));
  Widget logo()=>Container(
    padding: const EdgeInsets.all(0),
    margin: const EdgeInsets.all(0),
    child: const Image(
      image: AssetImage('assets/images/logo.png'),
      height: 200,
      width: 200,
    )

  );
  Widget welcome()=> DefaultTextStyle(
    style: GoogleFonts.pacifico(fontSize: 60,fontWeight: FontWeight.w300,color: app_colors.Welcome),
    child: Text(my_texts.welcome),

  );

  Widget anonymous_explane()=> Container(
    height:60,
    width: 300,
    //color: Colors.pinkAccent,
    child: DefaultTextStyle(
      style: GoogleFonts.abel(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),
      child:const Text("Anonymous mode allows you to use the app services anonymously"),

    ),
  );
  Widget non_anonymous_explane()=> Container(
    height:80,
    width: 300,
    //color: Colors.pinkAccent,
    child: SingleChildScrollView(child:  DefaultTextStyle(
      style: GoogleFonts.abel(fontSize: 16,fontWeight: FontWeight.w500,color: Colors.black),
      child:const Text("A non-anonymous mode lets you fill in your details and it stores them locally. Only when you use the distress button the device will use the data.(This mode can be changed at any time)"),

    ) ,),

  );

  Widget WelcomeContainer()=>Container(
   // color: Colors.red,
    height: 250,
    width:400,
    child:Stack(children: [
      Align(alignment: Alignment.topCenter,child: welcome(),),
      Align(alignment: const Alignment(0.0,1),child: logo(),),

    ],)

  );
  Widget buttonText()=>Container(
    height:button_h,
    width: button_w,
    //color: Colors.black26,
    child: Center(child: Column(children:  [
     const SizedBox(height: 25,),
      Text("non",style: TextStyle(color:app_colors.text_button,fontSize: button_fontSize,fontWeight: FontWeight.w500),),
      Text("anonymous",style: TextStyle(color:app_colors.text_button,fontSize: button_fontSize,fontWeight: FontWeight.w500)),
    ],)),

  );
  Widget anonymous_Button()=>Container(
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
     child: SizedBox(
       height:button_h,
       width: button_w,
      child:
      FloatingActionButton(
        //child: Icon(Icons.ac_unit),
        child: Text(my_texts.anonymous,style: TextStyle(color: app_colors.text_button,fontSize: button_fontSize,fontWeight: FontWeight.w500),),
        backgroundColor: app_colors.button,
        onPressed: ()  {

        },
      ),
    ),
      );
  Widget non_anonymous_Button()=>Container(
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
              offset: Offset(-8,-5)

          ),
        ]
    ),
    child: SizedBox(
      height:button_h,
      width: button_w,
      child:
      FloatingActionButton(
        child:buttonText(),
        backgroundColor: app_colors.button,
        onPressed: ()  {

        },
      ),
    ),
  );
  Widget buttonsContainer()=>Container(
   // color: Colors.green,
    height:370,
    width: 500,
    child: Column(children: [
      anonymous_Button(),
    const SizedBox(height: 10,),
     anonymous_explane(),
      non_anonymous_Button(),
      const SizedBox(height: 10,),
      non_anonymous_explane(),
    ],),
  );



  @override
  Widget build(BuildContext context) {
    if(isLoading || data.first_time==true) {
      return Container(
      color: app_colors.background,
      padding: const EdgeInsets.all(10),
      child: Column(children: [
        const SizedBox(height: 30,),
        Stack(children: [
          Column(
            children: [
              WelcomeContainer(),
            ],
          ),
          Column(
            children: [
              const SizedBox(height: 210,),
              if(isLoading) loading()
              else buttonsContainer(),
            ],
          ),

        ],),




      ],),







    );
    } else return Sos();

  }
}
