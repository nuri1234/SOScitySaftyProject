import 'package:client_side/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'texts.dart';
import 'colors.dart';
import 'local_data.dart';
import 'registration_page.dart';
import 'sos_main_screen.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool isLoading=true;

  Widget loading()=> Center(child: CircularProgressIndicator(color:app_colors.Welcome));
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
  Widget WelcomeContainer()=>Container(
      height: 500,
      width:400,
      child:Stack(children: [
        Align(alignment: Alignment.topCenter,child: welcome(),),
        Align(alignment: const Alignment(0.0,-0.65),child: logo(),),
        Align(alignment:  const Alignment(0.0,0.0),child: DefaultTextStyle(
          style: GoogleFonts.pacifico(fontSize: 60,fontWeight: FontWeight.w300,color: app_colors.Welcome),
          child: const Text("by"),),),
        Align(alignment:  const Alignment(0.0,1),child: rahatLogo(),),

      ],)

  );
  Widget rahatLogo()=>Container(
      padding: const EdgeInsets.all(0),
      margin: const EdgeInsets.all(0),
      child: const Image(
        image: AssetImage('assets/images/rahatLogo.png'),
        height: 200,
        width: 200,
      )

  );


  void loadData() async{
    //  await data.initData();
    await data.getData();
    print("is first time?");
    print(data.first_time);
    if(data.language==1) my_texts.changeToArabic();
    if(data.language==2) my_texts.changeToHebrew();

  if(data.first_time){
    data.first_time=false;
    data.updateData();
    Navigator.push(context, MaterialPageRoute(builder: (context)=>(const Registor())),);}
  else {
    Navigator.push(context, MaterialPageRoute(builder: (context)=>(const SOS())),);
  }

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();


  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: app_colors.background,
      child: Center(
        child: Column(children: [
          const SizedBox(height:50,),
          WelcomeContainer(),
          loading(),

        ],),
      ),

    );
  }
}
